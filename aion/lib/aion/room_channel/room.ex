defmodule Aion.RoomChannel.Room do
  @moduledoc """
  This module represents one game room, and fetches resources from the db
  """
  alias Aion.{Question, Answer}
  alias Aion.RoomChannel.{Room, UserRecord}
  require Logger

  @type t :: %__MODULE__{users: %{String.t => UserRecord.t},
                         users_count: integer,
                         question: Question.t,
                         answers: list Answer.t}

  defstruct users: %{},
            users_count: 0,
            question: nil,
            answers: []

  @spec new(integer, [question: nil | Question.t]) :: %__MODULE__{}
  def new(room_id, state \\ []) do
    case state do
      [] ->
        %Room{}
        |> change_question(room_id)

      {:question, question} ->
        %Room{question: question}

      _ -> Logger.error fn -> "Unexpected state passed to Room.new: #{state}" end
           %Room{}
    end
  end

  @spec evaluate_answer(__MODULE__.t, String.t) :: float
  def evaluate_answer(room, user_answer) do
    room
    |> Map.get(:answers)
    |> Enum.map(&(Map.get(&1, :content)))
    |> Enum.map(fn correct_answer -> Answer.compare_answers(correct_answer, user_answer) end)
    |> Enum.max()
  end

  @spec award_user(__MODULE__.t, String.t, integer) :: __MODULE__.t
  def award_user(room, username, amount \\ 1) do
    update_in room, [Access.key!(:users), Access.key!(username)], &UserRecord.update_score(&1, amount)
  end

  @doc """
  Note: this function's signature will change as soon as we get rid of categories = subject_id = room_id mapping.
  """
  @spec change_question(%__MODULE__{}, integer) :: __MODULE__.t
  def change_question(room, room_id) do
    room
    |> struct(get_new_question_with_answers(room_id))
  end

  @spec add_user(__MODULE__.t, UserRecord.t) :: __MODULE__.t
  def add_user(room, user) do
    updated_users = Map.put(room.users, user.username, user)
    %Room{room | users: updated_users}
  end

  @spec remove_user(__MODULE__.t, String.t) :: __MODULE__.t
  def remove_user(room, username) do
    updated_users = Map.delete(room.users, username)
    %Room{room | users: updated_users}
  end

  @spec get_scores(__MODULE__.t) :: list UserRecord.t
  def get_scores(room) do
    Map.values(room.users)
  end

  @spec get_current_question(__MODULE__.t) :: Question.t
  def get_current_question(room) do
    room.question
  end

  @spec get_new_question_with_answers(integer) :: %{question: Question.t, answers: list Answer.t}
  defp get_new_question_with_answers(room_id) do
      question = Question.get_random_question(room_id)
      answers = Answer.get_answers(question.id)
      Logger.debug fn -> "Answers: #{inspect(Enum.map(answers, fn answer -> answer.content end))}" end

      %{question: question, answers: answers}
  end
end
