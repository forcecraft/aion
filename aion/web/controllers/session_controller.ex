defmodule Aion.SessionController do
  use Aion.Web, :controller

  alias Aion.Auth
  alias Guardian.Plug

  def index(conn, _params) do
    render(conn, "login.json")
  end

  def create(conn, %{"email" => email, "password" => password}) do
    case Auth.login_by_username_and_pass(conn, email, password, repo: Repo) do
      {:ok, conn} ->
        new_conn = Plug.api_sign_in(conn, conn.assigns[:current_user])
        jwt = Plug.current_token(new_conn)
        {:ok, claims} = Plug.claims(new_conn)
        exp = claims["exp"]

        new_conn
        |> put_resp_header("authorization", "Bearer #{jwt}")
        |> put_resp_header("x-expires", "#{exp}")
        |> render("login.json", jwt: jwt)

      {:error, _reason, conn} ->
        Errors.internal_error(conn)
    end
  end
end
