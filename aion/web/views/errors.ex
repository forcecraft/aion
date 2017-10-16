defmodule Aion.ErrorCodesViews do
  @moduledoc """
  Module to share common http error codes
  """
  use Aion.Web, :controller

  def unauthenticated(conn) do
    conn
      |> put_status(401)
      |> render("error.json", message: "Authentication required")
  end
end
