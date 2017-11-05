defmodule Aion.RoomControllerTest do
  use Aion.AuthConnCase

  alias Aion.{Room, Question}
  alias Aion.RoomChannel.{Monitor, QuestionSet}

  @room %Room{description: "Here come dat boi", name: "Dat Boi"}
  @question1 %Question{content: "Who dat boi?"}
  @question2 %Question{content: "Wat do?"}
  @questions %QuestionSet{
    questions: [@question1, @question2]
  }
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

  test "list rooms with counts with no rooms in db", %{conn: conn} do
    conn = get conn, "/api/rooms?with_counts=true"
    assert json_response(conn, 200)["data"] == []
  end

  test "list rooms with counts with an empty room", %{conn: conn} do
    %Room{id: room_id} = room = Repo.insert! @room

    Monitor.create(room_id, questions: @questions)

    conn = get conn, "/api/rooms?with_counts=true"

    assert json_response(conn, 200)["data"] == [
      %{
        "id" => room.id,
        "name" => room.name,
        "description" => room.description,
        "player_count" => 0,
      }
    ]
  end

  test "list rooms with counts with players in rooms", %{conn: conn} do
    %Room{id: room_id} = room = Repo.insert! @room

    Monitor.create(room_id, questions: @questions)
    Monitor.user_joined(room_id, @player)

    conn = get conn, "/api/rooms?with_counts=true"

    assert json_response(conn, 200)["data"] == [
      %{
        "id" => room.id,
        "name" => room.name,
        "description" => room.description,
        "player_count" => 1,
      }
    ]
  end
end
