defmodule Aion.QuestionTransactions do
  @moduledoc """
  Implements transactions used by Aion.QuestionController
  """
  use Aion.Web, :controller

  alias Aion.{Answer, Question, Category}
  alias Ecto.Multi

  @answer_separator ","

  def create_question_with_answers(question, answers, category_id) do
      Multi.new
      |> Multi.insert(:insert_question, create_question_changeset(category_id, question))
      |> Multi.run(:insert_answers, &insert_answers(&1.insert_question, answers))
  end

  defp create_question_changeset(category_id, question) do
    question_category = Repo.get(Category, category_id)
    Question.changeset(%Question{}, Map.put(question, "belongs_to", question_category))
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
