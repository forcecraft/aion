defmodule Aion.RoomChannel.QuestionSet do
  @moduledoc """
  This module provides logic for generating new question set
  """
  alias Aion.{Question, Answer}
  require Logger

  @type t :: %__MODULE__{
    questions: (list Question.t),
    current_question: Question.t,
    answers: (list Answer.t),
  }

  defstruct questions: [],
    current_question: nil,
    answers: []


  @spec change_question(__MODULE__.t, integer) :: __MODULE__.t
  def change_question(questions, room_id) do
    case questions do
      [] ->
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
end
