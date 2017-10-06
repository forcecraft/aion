defmodule Aion.UserController do
  use Aion.Web, :controller

  def get_user_info(conn, _params) do
    user = Guardian.Plug.current_resource(conn)
    IO.inspect user, label: "current user"
    IO.inspect Guardian.Plug.authenticated?(conn), label: "is Authenticated"
    json conn, user
  end
end
