defmodule Aion.QuestionTest do
  use Aion.ModelCase

  alias Aion.Question

  @valid_attrs %{content: "some content", image_name: "some content"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Question.changeset(%Question{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Question.changeset(%Question{}, @invalid_attrs)
    refute changeset.valid?
  end

  def get_question(question_id) do
    Repo.get(Question, question_id)
  end

  def get_random_question(category_id) do
    query = from q in Question, where: q.category_id == ^category_id
    question =
      query
      |> Repo.all()
      |> Enum.random()
  end

end
