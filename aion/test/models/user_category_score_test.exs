defmodule Aion.UserCategoryScoreTest do
  use Aion.ModelCase

  alias Aion.UserCategoryScore

  @valid_attrs %{}
  @invalid_attrs %{score: -1}

  test "changeset with valid attributes" do
    changeset = UserCategoryScore.changeset(%UserCategoryScore{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = UserCategoryScore.changeset(%UserCategoryScore{}, @invalid_attrs)
    refute changeset.valid?
  end
end
