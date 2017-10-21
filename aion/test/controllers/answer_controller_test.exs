defmodule Aion.AnswerControllerTest do
  use Aion.AuthConnCase

  alias Aion.Answer
  @valid_attrs %{content: "some content"}
  @invalid_attrs %{}

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, answer_path(conn, :index)
    assert is_list json_response(conn, 200)["data"]
  end

  test "shows chosen resource", %{conn: conn} do
    answer = Repo.insert! %Answer{}
    conn = get conn, answer_path(conn, :show, answer)
    assert json_response(conn, 200)["data"] == %{"id" => answer.id,
      "question_id" => answer.question_id,
      "content" => answer.content}
  end

  test "renders page not found when id is nonexistent", %{conn: conn} do
    assert_error_sent 404, fn ->
      get conn, answer_path(conn, :show, -1)
    end
  end
end
