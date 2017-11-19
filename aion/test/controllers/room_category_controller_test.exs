defmodule Aion.RoomCategoryControllerTest do
  use Aion.AuthConnCase

  alias Aion.RoomCategory
  @valid_attrs %{}

  test "lists all entries on index", %{conn: conn} do
    conn = get(conn, room_category_path(conn, :index))
    assert json_response(conn, 200)["data"] == []
  end

  test "shows chosen resource", %{conn: conn} do
    room_category = Repo.insert!(%RoomCategory{})
    conn = get(conn, room_category_path(conn, :show, room_category))

    assert json_response(conn, 200)["data"] == %{
             "id" => room_category.id,
             "room_id" => room_category.room_id,
             "category_id" => room_category.category_id
           }
  end

  test "renders page not found when id is nonexistent", %{conn: conn} do
    assert_error_sent(404, fn ->
      get(conn, room_category_path(conn, :show, -1))
    end)
  end
end
