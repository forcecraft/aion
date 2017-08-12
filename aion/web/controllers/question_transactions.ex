defmodule Aion.QuestionTransactions do
  @moduledoc """
  Implements transactions used by Aion.QuestionController
  """
  use Aion.Web, :controller

  alias Aion.Question
  alias Aion.Answer
  alias Aion.Subject
  alias Ecto.Multi

  @answer_separator ","

  def create_question_with_answers(question, answers, subject_id) do
      Multi.new
      |> Multi.run(:create_changeset, fn _ -> create_question_changeset(subject_id, question) end)
      |> Multi.run(:insert_question, &insert_question(&1.create_changeset))
      |> Multi.run(:insert_answers, &insert_answers(&1.insert_question, answers))
  end

  defp create_question_changeset(subject_id, question) do
    question_subject = Repo.get(Subject, subject_id)
    {:ok, Question.changeset(%Question{}, Map.put(question, "belongs_to", question_subject))}
  end

  defp insert_question(question_changeset) do
    question_changeset |> Repo.insert
  end

  defp insert_answers(question, answers) do
    answers_inserted? =
      answers
      |> String.split(@answer_separator)
      |> Enum.map(fn answer_content -> Answer.changeset(%Answer{}, %{"content" => answer_content, "belongs_to" => question}) end)
      |> Enum.map(fn answer_changeset -> Repo.insert(answer_changeset) end)
      |> Enum.all?(fn {insert_result, _} -> insert_result == :ok end)

    if answers_inserted? do {:ok, true} else {:error, false} end
  end
end
