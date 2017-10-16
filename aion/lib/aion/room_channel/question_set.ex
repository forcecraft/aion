defmodule Aion.RoomChannel.QuestionSet do
  @moduledoc """
  This module provides logic for generating new question set
  """
  alias Aion.{Question, Answer}
  require Logger

  @type t :: %__MODULE__{questions: (list Question.t), current_question: Question.t, answers: (list Answer.t)}

  defstruct questions: [],
            current_question: nil,
            answers: []

  @spec create((list Question.t), integer) :: __MODULE__.t
  def create(questions, room_id) do
    case questions do
      [] ->
        %{questions: [], current_question: nil, answers: []}

      [last_question] ->
        remaining_questions = Question.get_questions_by_room_id(room_id)
        build_new(last_question, remaining_questions)

      [next_question | remaining_questions] ->
        build_new(next_question, remaining_questions)
    end
  end

  @spec build_new(Question.t, (list Question.t)) :: __MODULE__.t
  defp build_new(current_question, remaining_questions) do
    answers = Answer.get_answers(current_question.id)
    Logger.debug fn -> "Answers: #{inspect(Enum.map(answers, fn answer -> answer.content end))}" end
    %{questions: remaining_questions, current_question: current_question, answers: answers}
  end
end
