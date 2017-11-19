defmodule Aion.RankingController do
  use Aion.Web, :controller
  alias Guardian.Plug
  alias Aion.Ranking

  plug(Plug.EnsureAuthenticated, handler: __MODULE__)

  def ranking(conn, _params) do
    result = Ranking.data()
    render(conn, "ranking.json", category_scores: result)
  end

  def unauthenticated(conn, _params) do
    Errors.unauthenticated(conn)
  end
end
