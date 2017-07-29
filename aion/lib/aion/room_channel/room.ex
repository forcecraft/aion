defmodule Room do
  @moduledoc """
  This module represents one game room
  """


  defp get_new_question_with_answers(category_id) do
    query = from q in Question, where: q.subject_id == ^category_id
    question = query
               |> Repo.all()
               |> Enum.random()

    question_id = Map.get(question, :id)
    answers = Repo.all(from a in Answer, where: a.question_id == ^question_id)
    Logger.debug fn -> "Answers: #{inspect(answers)}" end
    %{question: question, answers: answers}
  end


  def compare_answers(first, second) do
      JaroWinkler.compare (String.capitalize first), (String.capitalize second)
  end
end