defmodule Aion.RankingTest do
  use Aion.ModelCase
  alias Aion.{Repo, User, UserCategoryScore, Ranking}

  @user1_attrs %{name: "John", email: "test1@example.com", password: "test123"}
  @user2_attrs %{name: "Michael", email: "test2@example.com", password: "test123"}

  describe "Ranking.general" do
    test "returns scored points in each category for each user" do
      user1 = Repo.insert! User.registration_changeset(%User{}, @user1_attrs)
      user2 = Repo.insert! User.registration_changeset(%User{}, @user2_attrs)
      Repo.insert! %UserCategoryScore{user: user1, score: 2}
      Repo.insert! %UserCategoryScore{user: user1, score: 4}
      Repo.insert! %UserCategoryScore{user: user2, score: 5}

      result = Ranking.general()

      assert result == [%{user_name: "John", score: 6}, %{user_name: "Michael", score: 5}]
    end
  end
end
