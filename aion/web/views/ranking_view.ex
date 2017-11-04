defmodule Aion.RankingView do
  require Logger
  use Aion.Web, :view

  def render("ranking.json", %{scores: scores}) do
    %{data: render_many(scores, Aion.RankingView, "score.json", as: :user_score)}
  end

  def render("score.json", %{user_score: user_score}) do
    %{userName: user_score.user_name, score: user_score.score}
  end
end
