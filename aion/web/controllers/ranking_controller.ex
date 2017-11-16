defmodule Aion.RankingController do
  use Aion.Web, :controller
  alias Guardian.Plug
  alias Aion.Ranking

  plug(Plug.EnsureAuthenticated, handler: __MODULE__)

  def ranking(conn, _params) do
    general_scores = Ranking.general()
    render(conn, "ranking.json", scores: general_scores)
  end

  def unauthenticated(conn, _params) do
    Errors.unauthenticated(conn)
  end
end
