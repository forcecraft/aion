defmodule Aion.RoomControllerTest do
  use Aion.AuthConnCase

  alias Aion.{Room, Question, User, Category, RoomCategory}
  alias Aion.RoomChannel.{Monitor, QuestionSet}

  @room %Room{description: "Here come dat boi", name: "Dat Boi"}
  @invalid_room %Room{name: "The provided data is invalid, it does not contain the description field"}
  @question1 %Question{content: "Who dat boi?"}
  @question2 %Question{content: "Wat do?"}
  @questions %QuestionSet{
    questions: [@question1, @question2]
  }
  @player %User{id: 5, name: "Stephan"}

  test "lists all entries on index", %{conn: conn} do
    conn = get(conn, room_path(conn, :index))
    assert json_response(conn, 200)["data"] == []
  end

  test "shows chosen resource", %{conn: conn} do
    room = Repo.insert!(@room)
    conn = get(conn, room_path(conn, :show, room))

    assert json_response(conn, 200)["data"] == %{
             "id" => room.id,
             "name" => room.name,
             "description" => room.description
           }
  end

  test "creates and renders resource when data is valid", %{conn: conn} do
    conn = post(conn, room_path(conn, :create), room: Map.from_struct(@room))
    assert json_response(conn, 201)["data"]["id"]
    assert Repo.get_by(Room, name: @room.name)
  end

  test "creates room with associated categories", %{conn: conn} do
    category1 = Repo.insert!(%Category{})
    category2 = Repo.insert!(%Category{})
    room_params = Map.merge(Map.from_struct(@room), %{category_ids: [category1.id, category2.id]})
    conn = post(conn, room_path(conn, :create), room: room_params)
    assert length(Repo.all(RoomCategory)) == 2
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post(conn, room_path(conn, :create), room: Map.from_struct(@invalid_room))
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "renders page not found when id is nonexistent", %{conn: conn} do
    assert_error_sent(404, fn ->
      get(conn, room_path(conn, :show, -1))
    end)
  end

  test "list rooms with counts with no rooms in db", %{conn: conn} do
    conn = get(conn, "/api/rooms?with_counts=true")
    assert json_response(conn, 200)["data"] == []
  end

  test "list rooms with counts with an empty room", %{conn: conn} do
    %Room{id: room_id} = room = Repo.insert!(@room)

    Monitor.create(room_id, questions: @questions)

    conn = get(conn, "/api/rooms?with_counts=true")

    assert json_response(conn, 200)["data"] == [
             %{
               "id" => room.id,
               "name" => room.name,
               "description" => room.description,
               "player_count" => 0
             }
           ]
  end

  test "list rooms with counts with players in rooms", %{conn: conn} do
    %Room{id: room_id} = room = Repo.insert!(@room)

    Monitor.create(room_id, questions: @questions)
    Monitor.user_joined(room_id, @player)

    conn = get(conn, "/api/rooms?with_counts=true")

    assert json_response(conn, 200)["data"] == [
             %{
               "id" => room.id,
               "name" => room.name,
               "description" => room.description,
               "player_count" => 1
             }
           ]
  end
end
