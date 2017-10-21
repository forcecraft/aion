defmodule Aion.RoomControllerTest do
  use Aion.AuthConnCase

  alias Aion.{Room, Category, RoomCategory}
  @valid_attrs %{description: "some content", name: "some content"}
  @invalid_attrs %{}

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, room_path(conn, :index)
    assert json_response(conn, 200)["data"] == []
  end

  test "shows chosen resource", %{conn: conn} do
    room = Repo.insert! %Room{}
    conn = get conn, room_path(conn, :show, room)
    assert json_response(conn, 200)["data"] == %{"id" => room.id,
      "name" => room.name,
      "description" => room.description}
  end

  test "renders page not found when id is nonexistent", %{conn: conn} do
    assert_error_sent 404, fn ->
      get conn, room_path(conn, :show, -1)
    end
  end
end
