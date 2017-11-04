defmodule Aion.RankingTest do
  use Aion.ModelCase
  alias Aion.{Repo, User, UserCategoryScore, Ranking}

  describe "Ranking.general" do
    test "returns scored points in each category for each user" do
      user1 = Repo.insert! User.registration_changeset(%User{}, %{name: "John", email: "test1@example.com", password: "test123"})
      user2 = Repo.insert! User.registration_changeset(%User{}, %{name: "Michael", email: "test2@example.com", password: "test123"})
      Repo.insert! %UserCategoryScore{user: user1, score: 2}
      Repo.insert! %UserCategoryScore{user: user1, score: 4}
      Repo.insert! %UserCategoryScore{user: user2, score: 5}

      result = Ranking.general()

      assert [%{user_name: "John", score: 6}, %{user_name: "Michael", score: 5}] = result
    end
  end
end