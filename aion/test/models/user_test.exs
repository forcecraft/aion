defmodule Aion.UserTest do
  use Aion.ModelCase

  alias Aion.{Repo, User, Category, UserCategoryScore}

  @valid_attrs %{name: "John Wink", email: "test@example.com", password: "test123"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = User.changeset(%User{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = User.changeset(%User{}, @invalid_attrs)
    refute changeset.valid?
  end

  describe "User.change_score_by/3" do
    test "when user never scored in given category" do
      user = Repo.insert! User.registration_changeset(%User{}, @valid_attrs)
      category = Repo.insert! %Category{name: "Category A"}

      User.change_score_by(user.id, category.id, 1)
      user_score = Repo.get_by(UserCategoryScore, user_id: user.id, category_id: category.id)

      assert user_score.score == 1201
    end

    test "when user already scored in given category" do
      user = Repo.insert! User.registration_changeset(%User{}, @valid_attrs)
      category = Repo.insert! %Category{name: "Category A"}
      Repo.insert! %UserCategoryScore{user: user, category: category, score: 1200}

      User.change_score_by(user.id, category.id, 5)
      user_score = Repo.get_by(UserCategoryScore, user_id: user.id, category_id: category.id)

      assert user_score.score == 1205
    end
  end
end
