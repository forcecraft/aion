defmodule Aion.PageController do
  use Aion.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
