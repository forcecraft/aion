defmodule Aion.RoomChannel.Room do
  @moduledoc """
  This module represents one game room
  """
  alias Aion.{Repo, Question}
  import Ecto.Query, only: [from: 2]
  require Logger

  def get_new_question_with_answers(category_id) do
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