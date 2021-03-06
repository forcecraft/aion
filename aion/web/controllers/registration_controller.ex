defmodule Aion.RegistrationController do
  use Aion.Web, :controller
  alias Aion.{SessionController, User}

  def show(conn, %{"id" => id}) do
    user = Repo.get!(User, id)
    render(conn, "show.json", user: user)
  end

  def create(conn, user_params) do
    changeset = User.registration_changeset(%User{}, user_params)

    case Repo.insert(changeset) do
      {:ok, user} ->
        SessionController.create(conn, %{"email" => user.email, "password" => user.password})

      {:error, changeset} ->
        Errors.unprocessable_entity(conn, changeset)
    end
  end
end
