defmodule Aion.SessionController do
  use Aion.Web, :controller

  alias Aion.User
  alias Aion.Auth

  # to be delted?
  def index(conn, _params) do
    render(conn, "data.json")
  end

  def create(conn, %{"email" => email, "password" => password}) do
    case Auth.login_by_username_and_pass(conn, email, password, repo: Repo) do
      {:ok, conn} ->
        new_conn = Guardian.Plug.api_sign_in(conn, conn.assigns[:current_user])
        jwt = Guardian.Plug.current_token(new_conn)
        {:ok, claims} = Guardian.Plug.claims(new_conn)
      #   IO.inspect(claims)
        exp = Map.get(claims, "exp")

        new_conn
        |> put_resp_header("authorization", "Bearer #{jwt}")
        |> put_resp_header("x-expires", "#{exp}")
        |> render("login.json", jwt: jwt)
      {:error, _reason, conn} ->
        IO.inspect(_reason)
        conn
        |> put_status(500)
        |> render("error.json")
    end
  end
end
