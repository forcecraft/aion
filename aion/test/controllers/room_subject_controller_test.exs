defmodule Aion.RoomSubjectControllerTest do
  use Aion.ConnCase

  alias Aion.RoomSubject
  @valid_attrs %{}
  @invalid_attrs %{}

  setup do
    user = %{ email: "test@example.com", name: "something" }
    conn = Plug.Test. init_test_session(build_conn(), %{current_user: user})
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, room_subject_path(conn, :index)
    assert json_response(conn, 200)["data"] == []
  end

  test "shows chosen resource", %{conn: conn} do
    room_subject = Repo.insert! %RoomSubject{}
    conn = get conn, room_subject_path(conn, :show, room_subject)
    assert json_response(conn, 200)["data"] == %{"id" => room_subject.id,
      "room_id" => room_subject.room_id,
      "subject_id" => room_subject.subject_id}
  end

  test "renders page not found when id is nonexistent", %{conn: conn} do
    assert_error_sent 404, fn ->
      get conn, room_subject_path(conn, :show, -1)
    end
  end

  test "creates and renders resource when data is valid", %{conn: conn} do
    conn = post conn, room_subject_path(conn, :create), room_subject: @valid_attrs
    assert json_response(conn, 201)["data"]["id"]
    assert Repo.get_by(RoomSubject, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, room_subject_path(conn, :create), room_subject: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "updates and renders chosen resource when data is valid", %{conn: conn} do
    room_subject = Repo.insert! %RoomSubject{}
    conn = put conn, room_subject_path(conn, :update, room_subject), room_subject: @valid_attrs
    assert json_response(conn, 200)["data"]["id"]
    assert Repo.get_by(RoomSubject, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    room_subject = Repo.insert! %RoomSubject{}
    conn = put conn, room_subject_path(conn, :update, room_subject), room_subject: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "deletes chosen resource", %{conn: conn} do
    room_subject = Repo.insert! %RoomSubject{}
    conn = delete conn, room_subject_path(conn, :delete, room_subject)
    assert response(conn, 204)
    refute Repo.get(RoomSubject, room_subject.id)
  end
end
