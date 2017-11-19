defmodule Aion.RankingTest do
  use Aion.ModelCase
  alias Aion.{Repo, User, Category, UserCategoryScore, Ranking}

  @user1_attrs %{name: "John", email: "test1@example.com", password: "test123"}
  @user2_attrs %{name: "Michael", email: "test2@example.com", password: "test123"}

  describe "Ranking.data" do
    test "returns player scores for each category" do
      user1 = Repo.insert! User.registration_changeset(%User{}, @user1_attrs)
      user2 = Repo.insert! User.registration_changeset(%User{}, @user2_attrs)
      category1 =  Repo.insert! %Category{name: "category1"}
      category2 =  Repo.insert! %Category{name: "category2"}
      Repo.insert! %UserCategoryScore{user: user1, category: category1, score: 2}
      Repo.insert! %UserCategoryScore{user: user1, category: category2, score: 4}
      Repo.insert! %UserCategoryScore{user: user2, category: category2, score: 5}

      result = Ranking.data()

      assert result == [%{category_id: category1.id, category_name: "category1", scores: [%{user_name: "John", score: 2}]},
                        %{category_id: category2.id, category_name: "category2", scores: [%{user_name: "John", score: 4}, %{user_name: "Michael", score: 5}]}]
    end
  end
end
