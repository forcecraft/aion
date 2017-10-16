defmodule Aion.RoomCategoryControllerTest do
  use Aion.ConnCase

  alias Aion.RoomCategory
  @valid_attrs %{}

  setup do
    Aion.TestHelpers.setup
  end

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, room_category_path(conn, :index)
    assert json_response(conn, 200)["data"] == []
  end

  test "shows chosen resource", %{conn: conn} do
    room_category = Repo.insert! %RoomCategory{}
    conn = get conn, room_category_path(conn, :show, room_category)
    assert json_response(conn, 200)["data"] == %{"id" => room_category.id,
      "room_id" => room_category.room_id,
      "category_id" => room_category.category_id}
  end

  test "renders page not found when id is nonexistent", %{conn: conn} do
    assert_error_sent 404, fn ->
      get conn, room_category_path(conn, :show, -1)
    end
  end

  test "creates and renders resource when data is valid", %{conn: conn} do
    conn = post conn, room_category_path(conn, :create), room_category: @valid_attrs
    assert json_response(conn, 201)["data"]["id"]
    assert Repo.get_by(RoomCategory, @valid_attrs)
  end

  test "updates and renders chosen resource when data is valid", %{conn: conn} do
    room_category = Repo.insert! %RoomCategory{}
    conn = put conn, room_category_path(conn, :update, room_category), room_category: @valid_attrs
    assert json_response(conn, 200)["data"]["id"]
    assert Repo.get_by(RoomCategory, @valid_attrs)
  end

  test "deletes chosen resource", %{conn: conn} do
    room_category = Repo.insert! %RoomCategory{}
    conn = delete conn, room_category_path(conn, :delete, room_category)
    assert response(conn, 204)
    refute Repo.get(RoomCategory, room_category.id)
  end
end
