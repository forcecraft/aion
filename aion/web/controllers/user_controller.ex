defmodule Aion.UserController do
  use Aion.Web, :controller
  alias Addict.Helper

  def get_user_info(conn, _params) do
    user = Helper.current_user(conn)
    json conn, user
  end
end