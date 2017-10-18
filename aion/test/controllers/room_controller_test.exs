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

  test "creates and renders resource when data is valid", %{conn: conn} do
    conn = post conn, room_path(conn, :create), room: @valid_attrs
    assert json_response(conn, 201)["data"]["id"]
    assert Repo.get_by(Room, @valid_attrs)
  end

  test "creates room with associated categories", %{conn: conn} do
    category1 = Repo.insert! %Category{}
    category2 = Repo.insert! %Category{}
    room_params = Map.merge(@valid_attrs, %{category_ids: [category1.id, category2.id]})
    conn = post conn, room_path(conn, :create), room: room_params
    assert length(Repo.all(RoomCategory)) == 2
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, room_path(conn, :create), room: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "updates and renders chosen resource when data is valid", %{conn: conn} do
    room = Repo.insert! %Room{}
    conn = put conn, room_path(conn, :update, room), room: @valid_attrs
    assert json_response(conn, 200)["data"]["id"]
    assert Repo.get_by(Room, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    room = Repo.insert! %Room{}
    conn = put conn, room_path(conn, :update, room), room: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "deletes chosen resource", %{conn: conn} do
    room = Repo.insert! %Room{}
    conn = delete conn, room_path(conn, :delete, room)
    assert response(conn, 204)
    refute Repo.get(Room, room.id)
  end
end
