defmodule Aion.RoomControllerTest do
  use Aion.ConnCase

  alias Aion.Room
  @valid_attrs %{description: "some content", name: "some content"}
  @invalid_attrs %{}

  setup do
    user = %{ email: "test@example.com", name: "something" }
    conn = Plug.Test. init_test_session(build_conn(), %{current_user: user})
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

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

  test "creates room with associated subjects", %{conn: conn} do
    subject1 = Repo.insert! %Aion.Subject{}
    subject2 = Repo.insert! %Aion.Subject{}
    room_params = Map.merge(@valid_attrs, %{subject_ids: [subject1.id, subject2.id]})
    conn = post conn, room_path(conn, :create), room: room_params
    assert length(Repo.all(Aion.RoomSubject)) == 2
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
