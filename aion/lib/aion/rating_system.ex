defmodule Aion.RatingSystem do
  @moduledoc """
  This module provides logic for calculating change in player elo score after a single game (good answer provided)
  """
  alias Aion.User
  alias Aion.RoomChannel.UserRecord

  @k_factor 32
  @initial_value 1200
  @magnitude 400

  @spec update_users_scores(integer, list(UserRecord.t()), integer) :: none
  def update_users_scores(winner_id, users, category_id) do
    losers_scores =
      users
      |> Enum.reject(&(&1.user_id == winner_id))
      |> Enum.map(fn(loser) -> %{user_id: loser.user_id, score: user_category_score(loser.user_id, category_id)} end)

    winner_score = user_category_score(winner_id, category_id)
    winner_delta = winner_delta(winner_score, Enum.map(losers_scores, &(&1.score)))

    User.change_score_by(winner_id, category_id, winner_delta)

    losers_scores
      |> Enum.each(fn(loser_score) ->
        User.change_score_by(loser_score.user_id, category_id, loser_delta(loser_score.score, winner_score))
      end)
  end

  @spec winner_delta(integer, list(integer)) :: integer
  def winner_delta(winner_score, opponents_scores) do
    opponents_scores
      |> Enum.map(&expected_score(winner_score, &1))
      |> Enum.map(&(@k_factor * (1 - &1)))
      |> Enum.map(&Float.round(&1))
      |> Enum.map(&trunc(&1))
      |> Enum.sum
  end

  @spec loser_delta(integer, integer) :: integer
  def loser_delta(loser_score, winner_score) do
    delta = (-1) * @k_factor * expected_score(loser_score, winner_score)
    delta
      |> Float.round()
      |> trunc()
  end

  def initial_value do
    @initial_value
  end

  @spec odds_for(integer) :: float
  defp odds_for(score) do
    :math.pow(10, score / @magnitude)
  end

  @spec user_category_score(integer, integer) :: integer
  defp user_category_score(user_id, category_id) do
    User.get_user_category_score(user_id, category_id).score
  end

  @spec expected_score(integer, integer) :: float
  defp expected_score(player_score, opponent_score) do
    odds_for(player_score) / (odds_for(player_score) + odds_for(opponent_score))
  end
end
