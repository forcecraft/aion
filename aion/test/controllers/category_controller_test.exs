defmodule Aion.CategoryControllerTest do
  use Aion.ConnCase

  alias Aion.Category
  @valid_attrs %{name: "some content"}
  @invalid_attrs %{}

  setup %{conn: _} do
    user = %Aion.User{ email: "test@example.com", name: "something", password: "2131231", id: 1 }
    {:ok, jwt, _} = Guardian.encode_and_sign(user)
    conn =
      build_conn()
      |> put_req_header("authorization", "Bearer #{jwt}")
      |> put_req_header("accept", "application/json")
    {:ok, %{conn: conn}}
  end

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

  test "creates and renders resource when data is valid", %{conn: conn} do
    conn = post conn, category_path(conn, :create), category: @valid_attrs
    assert json_response(conn, 201)["data"]["id"]
    assert Repo.get_by(Category, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, category_path(conn, :create), category: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "updates and renders chosen resource when data is valid", %{conn: conn} do
    category = Repo.insert! %Category{}
    conn = put conn, category_path(conn, :update, category), category: @valid_attrs
    assert json_response(conn, 200)["data"]["id"]
    assert Repo.get_by(Category, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    category = Repo.insert! %Category{}
    conn = put conn, category_path(conn, :update, category), category: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "deletes chosen resource", %{conn: conn} do
    category = Repo.insert! %Category{}
    conn = delete conn, category_path(conn, :delete, category)
    assert response(conn, 204)
    refute Repo.get(Category, category.id)
  end
end
