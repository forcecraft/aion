defmodule Aion.RoomCategoryController do
  use Aion.Web, :controller

  alias Aion.{RoomCategory, ErrorCodesViews}

  plug Guardian.Plug.EnsureAuthenticated, handler: __MODULE__

  def index(conn, _params) do
    room_categories = Repo.all(RoomCategory)
    render(conn, "index.json", room_categories: room_categories)
  end

  def create(conn, %{"room_category" => room_category_params}) do
    changeset = RoomCategory.changeset(%RoomCategory{}, room_category_params)

    case Repo.insert(changeset) do
      {:ok, room_category} ->
        conn
        |> put_status(:created)
        |> put_resp_header("location", room_category_path(conn, :show, room_category))
        |> render("show.json", room_category: room_category)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(Aion.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    room_category = Repo.get!(RoomCategory, id)
    render(conn, "show.json", room_category: room_category)
  end

  def update(conn, %{"id" => id, "room_category" => room_category_params}) do
    room_category = Repo.get!(RoomCategory, id)
    changeset = RoomCategory.changeset(room_category, room_category_params)

    case Repo.update(changeset) do
      {:ok, room_category} ->
        render(conn, "show.json", room_category: room_category)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(Aion.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    room_category = Repo.get!(RoomCategory, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(room_category)

    send_resp(conn, :no_content, "")
  end

  def unauthenticated(conn, _params) do
    ErrorCodesViews.unauthenticated(conn)
  end
end
