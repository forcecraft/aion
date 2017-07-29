defmodule Aion.RoomChannel.Room do
  @moduledoc """
  This module represents one game room, and fetches resources from the db
  """

  alias Simetric.Jaro.Winkler, as: JaroWinkler
  alias Aion.{Repo, Question, Answer}
  import Ecto.Query, only: [from: 2]
  require Logger

  def compare_answers(first, second) do
      JaroWinkler.compare (String.capitalize first), (String.capitalize second)
  end

  def get_new_question_with_answers(category_id) do
    question = get_random_question(category_id)
    answers = get_answers(question.id)
    Logger.debug fn -> "Answers: #{inspect(answers)}" end

    %{question: question, answers: answers}
  end

  def get_random_question(category_id) do
    query = from q in Question, where: q.subject_id == ^category_id
    question =
      query
      |> Repo.all()
      |> Enum.random()
  end

  defp get_question(question_id) do
    Repo.get(Question, question_id)
  end

  defp get_answers(question_id) do
    Repo.all(from a in Answer, where: a.question_id == ^question_id)
  end
end