defmodule Aion.ControllerErrors do
  @moduledoc """
  Module to share common http error codes
  """
  use Aion.Web, :controller

  def unauthenticated(conn) do
    conn
    |> put_status(401)
    |> render("error.json", message: "Authentication required")
  end

  def unprocessable_entity(conn, changeset) do
    conn
    |> put_status(:unprocessable_entity)
    |> render(Aion.ChangesetView, "error.json", changeset: changeset)
  end

  def internal_error(conn) do
    conn
    |> put_status(500)
    |> render("error.json")
  end
end
