defmodule Aion.RegistrationController do
  use Aion.Web, :controller
  alias Aion.User

  def new(conn, _params) do
    changeset = User.changeset(%User{})
    render conn, changeset: changeset
  end
end
