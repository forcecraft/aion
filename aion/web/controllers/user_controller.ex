defmodule Aion.UserController do
  use Aion.Web, :controller

  def get_user_info(conn, _params) do
    user = Guardian.Plug.current_resource(conn)
    # add case user of to prevent 500
    render(conn, "user.json", user: user)
  end
end
