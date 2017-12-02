defmodule Aion.RankingController do
  use Aion.Web, :controller
  alias Guardian.Plug
  alias Aion.Ranking

  plug(Plug.EnsureAuthenticated, handler: __MODULE__)

  def general_ranking(conn, _params) do
    result = Ranking.general_ranking()
    render(conn, "ranking.json", category_scores: result)
  end

  def user_ranking(conn, _params) do
    result = Ranking.user_ranking(Plug.current_resource(conn).id)
    render(conn, "user_ranking.json", user_scores: result)
  end

  def unauthenticated(conn, _params) do
    Errors.unauthenticated(conn)
  end
end
