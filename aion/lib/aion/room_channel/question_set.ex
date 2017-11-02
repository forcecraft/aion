defmodule Aion.RoomChannel.QuestionSet do
  @moduledoc """
  This module provides logic for generating new question set
  """
  alias Aion.{Question, Answer}
  require Logger

  @type t :: %__MODULE__{
    answers: (list Answer.t),
    current_question: Question.t,
    next_question: Question.t,
    questions: (list Question.t),
  }

  defstruct answers: [],
    current_question: nil,
    next_question: nil,
    questions: []

  @spec change_question(__MODULE__.t, integer) :: __MODULE__.t
  def change_question(question_set, room_id) do
    case question_set.questions do
      [] ->
        Logger.error "No questions loaded in room"
        %__MODULE__{}

      [last_question] ->
        remaining_questions = Question.get_questions_by_room_id(room_id)
        new(last_question, remaining_questions)

      [next_question | remaining_questions] ->
        new(next_question, remaining_questions)
    end
  end

  @spec new(Question.t, (list Question.t)) :: __MODULE__.t
  defp new(current_question, remaining_questions) do
    answers = Answer.get_answers(current_question.id)
    Logger.debug fn -> "Answers: #{inspect(Enum.map(answers, fn answer -> answer.content end))}" end

    %__MODULE__{
      questions: remaining_questions,
      current_question: current_question,
      answers: answers,
    }
  end

  @spec load_questions(integer) :: __MODULE__.t
  def load_questions(room_id) do
    questions =
      room_id
      |> Question.get_questions_by_room_id()
      |> Enum.shuffle()

    %__MODULE__{questions: questions}
  end
end
