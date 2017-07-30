defmodule Aion.RoomChannel.Room do
  @moduledoc """
  This module represents one game room, and fetches resources from the db
  """

  alias Aion.{Repo, Question, Answer}
  alias Aion.RoomChannel.{Room, UserRecord}
  alias Aion.Types
  import Ecto.Query, only: [from: 2]
  require Logger

  defstruct users: %{},
            users_count: 0,
            question: nil,
            answers: []

  @spec new(room_id :: integer) :: Types.room
  def new(room_id, state \\ []) do
    case state do
      [] ->
        %Room{}
        |> change_question(room_id)

      {:question, question} ->
        %Room{question: question}
    end
  end

  @spec evaluate_answer(room :: Types.room, user_answer :: binary) :: float
  def evaluate_answer(room, user_answer) do
    room
    |> Map.get(:answers)
    |> Enum.map(&(Map.get(&1, :content)))
    |> Enum.map(fn correct_answer -> Answer.compare_answers(correct_answer, user_answer) end)
    |> Enum.max
  end

  @spec award_user(room :: Types.room, username :: binary, amount :: integer) :: Types.room
  def award_user(room, username, amount \\ 1) do
    update_in room, [Access.key!(:users), Access.key!(username)], &UserRecord.update_score(&1, amount)
  end

  @doc """
  Note: this function's signature will change as soon as we get rid of categories = subject_id = room_id mapping.
  """
  @spec change_question(room :: Types.room, room_id :: integer) :: Types.room
  def change_question(room, room_id) do
    room
    |> struct(get_new_question_with_answers(room_id))
  end

  @spec change_question(room :: Types.room, user :: Types.user_record) :: Types.room
  def add_user(room, user) do
    updated_users = Map.put(room.users, user.username, user)
    %Room{room | users: updated_users}
  end

  @spec get_scores(room :: Types.room) :: list(Types.user_record)
  def get_scores(room) do
    Map.values(room.users)
  end

  @spec get_current_question(room: Types.room) :: Types.question
  def get_current_question(room) do
    room.question
  end

  @spec get_new_question_with_answers(category_id :: integer)
  :: %{question: Types.question, answers: list(Types.answer)}
  defp get_new_question_with_answers(category_id) do
      question = Question.get_random_question(category_id)
      answers = Answer.get_answers(question.id)
      Logger.debug fn -> "Answers: #{inspect(Enum.map(answers, fn answer -> answer.content end))}" end

      %{question: question, answers: answers}
    end
end
