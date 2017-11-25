defmodule Aion.RankingView do
  require Logger
  use Aion.Web, :view

  def render("ranking.json", %{category_scores: category_scores}) do
    %{rankingList: render_many(category_scores, Aion.RankingView, "category_score.json", as: :category_score)}
  end

  def render("category_score.json", %{category_score: category_score}) do
    %{categoryId: category_score.category_id,
      categoryName: category_score.category_name,
      scores: render_many(category_score.scores, Aion.RankingView, "user_score.json", as: :user_score)}
  end

  def render("user_score.json", %{user_score: user_score}) do
    %{userName: user_score.user_name, score: user_score.score}
  end

  def render("user_ranking.json", %{user_scores: user_scores}) do
    %{categoryScores: render_many(user_scores, Aion.RankingView, "user_category_score.json", as: :user_category_score)}
  end

  def render("user_category_score.json", %{user_category_score: user_category_score}) do
    %{categoryName: user_category_score.category_name, score: user_category_score.score}
  end
end
