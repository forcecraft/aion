defmodule Aion.CategoryController do
  use Aion.Web, :controller

  alias Aion.Category

  plug Guardian.Plug.EnsureAuthenticated, handler: __MODULE__

  def index(conn, _params) do
    categories = Repo.all(Category)
    render(conn, "index.json", categories: categories)
  end

  def create(conn, %{"category" => category_params}) do
    changeset = Category.changeset(%Category{}, category_params)

    case Repo.insert(changeset) do
      {:ok, category} ->
        conn
        |> put_status(:created)
        |> put_resp_header("location", category_path(conn, :show, category))
        |> render("show.json", category: category)
      {:error, changeset} ->
        Errors.unprocessable_entity(conn, changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    category = Repo.get!(Category, id)
    render(conn, "show.json", category: category)
  end

  def update(conn, %{"id" => id, "category" => category_params}) do
    category = Repo.get!(Category, id)
    changeset = Category.changeset(category, category_params)

    case Repo.update(changeset) do
      {:ok, category} ->
        render(conn, "show.json", category: category)
      {:error, changeset} ->
        Errors.unprocessable_entity(conn, changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    category = Repo.get!(Category, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(category)

    send_resp(conn, :no_content, "")
  end

  def unauthenticated(conn, _params) do
    Errors.unauthenticated(conn)
  end
end
