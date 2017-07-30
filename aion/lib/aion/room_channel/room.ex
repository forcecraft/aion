defmodule Aion.RoomChannel.Room do
  @moduledoc """
  This module represents one game room, and fetches resources from the db
  """

  alias Simetric.Jaro.Winkler, as: JaroWinkler
  alias Aion.{Repo, Question, Answer}
  alias Aion.RoomChannel.{Room, PlayerRecord}

  import Ecto.Query, only: [from: 2]
  require Logger

  defstruct players: %{},
            player_count: 0,
            question: nil,
            answers: []

  def new(room_id, players \\ [], question \\ nil, answers \\ []) do
    room = %Room{}

    if is_nil question && answers == [] do
      change_question(room, room_id)
    end
  end

  def evaluate_answer(room, player_answer) do
    room
    |> Map.get(:answers)
    |> Enum.map(&(Map.get(&1, :content)))
    |> Enum.map(fn correct_answer -> compare_answers(correct_answer, player_answer) end)
    |> Enum.max
  end

  defp compare_answers(first, second) do
    JaroWinkler.compare (String.capitalize first), (String.capitalize second)
  end

  def award_player(room, username, amount \\ 1) do
    update_in room, [Access.key!(:players), Access.key!(username)], &PlayerRecord.update_score(&1, amount)
  end

  @doc """
  Note: this function's signature will change as soon as we get rid of categories = subject_id = room_id mapping.
  """
  def change_question(room, room_id) do
    room
    |> struct(get_new_question_with_answers(room_id))
  end

  def add_player(room, player) do
    updated_players = Map.put(room.players, player.username, player)
    %Room{room | players: updated_players}
  end

  def get_scores(room) do
    Map.values(room.players)
  end

  defp get_new_question_with_answers(category_id) do
      question = Question.get_random_question(category_id)
      answers = Answer.get_answers(question.id)
      Logger.debug fn -> "Answers: #{inspect(answers)}" end

      %{question: question, answers: answers}
    end

end
