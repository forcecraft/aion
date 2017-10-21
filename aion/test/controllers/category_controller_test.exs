defmodule Aion.CategoryControllerTest do
  use Aion.AuthConnCase

  alias Aion.Category
  @valid_attrs %{name: "some content"}
  @invalid_attrs %{}

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, category_path(conn, :index)
    data = json_response(conn, 200)["data"]
    assert is_list data
  end

  test "shows chosen resource", %{conn: conn} do
    category = Repo.insert! %Category{}
    conn = get conn, category_path(conn, :show, category)
    assert json_response(conn, 200)["data"] == %{"id" => category.id,
      "name" => category.name}
  end

  test "renders page not found when id is nonexistent", %{conn: conn} do
    assert_error_sent 404, fn ->
      get conn, category_path(conn, :show, -1)
    end
  end
end
