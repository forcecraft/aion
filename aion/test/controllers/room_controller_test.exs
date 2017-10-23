defmodule Aion.RoomControllerTest do
  use Aion.AuthConnCase

  alias Aion.{Room, Question}
  alias Aion.RoomChannel.Monitor

  @room %Room{description: "Here come dat boi", name: "Boi"}
  @question %Question{content: "Content"}
  @player "Stephan"

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, room_path(conn, :index)
    assert json_response(conn, 200)["data"] == []
  end

  test "shows chosen resource", %{conn: conn} do
    room = Repo.insert! @room
    conn = get conn, room_path(conn, :show, room)
    assert json_response(conn, 200)["data"] == %{
      "id" => room.id,
      "name" => room.name,
      "description" => room.description,
    }
  end

  test "renders page not found when id is nonexistent", %{conn: conn} do
    assert_error_sent 404, fn ->
      get conn, room_path(conn, :show, -1)
    end
  end

  test "GET /counts with no rooms in db", %{conn: conn} do
    conn = get conn, "/api/counts"
    assert json_response(conn, 200) == []
  end

  test "GET /counts with empty room", %{conn: conn} do
    room = Repo.insert! @room
    room_id = room.id

    Monitor.create(room_id, current_question: @question)

    conn = get conn, "/api/counts"

    assert json_response(conn, 200) == [
      %{
        "id" => room.id,
        "name" => room.name,
        "description" => room.description,
        "player_count" => 0,
      }
    ]
  end

  test "GET /counts with players inside", %{conn: conn} do
    room = Repo.insert! @room
    room_id = room.id

    Monitor.create(room_id, current_question: @question)
    Monitor.user_joined(room_id, @player)

    conn = get conn, "/api/counts"

    assert json_response(conn, 200) == [
      %{
        "id" => room.id,
        "name" => room.name,
        "description" => room.description,
        "player_count" => 1,
      }
    ]
  end
end
