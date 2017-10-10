defmodule Aion.RegistrationController do
  use Aion.Web, :controller
  alias Aion.User

  def show(conn, %{"id" => id}) do
    user = User.get!(User, id)
    render(conn, "show.json", user: user)
  end

  def create(conn, user_params) do
    changeset = User.registration_changeset(%User{}, user_params)

    case Repo.insert(changeset) do
      {:ok, user} ->
        conn
        |> put_status(:created)
        |> render("show.json", user: user)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(Aion.ChangesetView, "error.json", changeset: changeset)
    end
  end
end
