defmodule Aion.Rating do
  @moduledoc """
  This module provides logic for calculating change in player elo rating after a single game (good answer provided)
  """
  @k_factor 32

  @spec winner_delta(integer, list(integer)) :: integer
  def winner_delta(winner_rating, opponents_ratings) do
    opponents_ratings
      |> Enum.map(&expected_score(winner_rating, &1))
      |> Enum.map(&(@k_factor * (1 - &1)))
      |> Enum.map(&Float.round(&1))
      |> Enum.map(&trunc(&1))
      |> Enum.sum
  end

  @spec loser_delta(integer, integer) :: integer
  def loser_delta(loser_rating, winner_rating) do
    (-1) * @k_factor * expected_score(loser_rating, winner_rating)
      |> Float.round()
      |> trunc()
  end

  def initial_value do
    1200
  end

  @spec odds_for(integer) :: float
  defp odds_for(rating) do
    :math.pow(10, rating / 400)
  end

  @spec expected_score(integer, integer) :: float
  defp expected_score(player_rating, opponent_rating) do
    odds_for(player_rating) / (odds_for(player_rating) + odds_for(opponent_rating))
  end
end
