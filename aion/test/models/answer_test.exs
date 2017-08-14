defmodule Aion.AnswerTest do
  use Aion.ModelCase
  alias Aion.Answer

  @valid_attrs %{content: "some content"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Answer.changeset(%Answer{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Answer.changeset(%Answer{}, @invalid_attrs)
    refute changeset.valid?
  end

  test "compare equal answers" do
    [first, second] = ["ABC", "abc"]
    assert Answer.compare_answers(first, second) == 1.0
  end

  test "compare totally different answers" do
    [first, second] = ["a", "b"]
    assert Answer.compare_answers(first, second) == 0.0
  end
end
