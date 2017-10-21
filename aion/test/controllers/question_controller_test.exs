defmodule Aion.QuestionControllerTest do
  use Aion.AuthConnCase

  alias Aion.Question

  @valid_attrs %{content: "some content", image_name: "some content"}
  @invalid_attrs %{}
  @answers "some content"
  @category 1

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, question_path(conn, :index)
    data = json_response(conn, 200)["data"]
    assert is_list data
  end

  test "shows chosen resource", %{conn: conn} do
    question = Repo.insert! %Question{}
    conn = get conn, question_path(conn, :show, question)
    assert json_response(conn, 200)["data"] == %{"id" => question.id,
      "category_id" => question.category_id,
      "content" => question.content,
      "image_name" => question.image_name}
  end

  test "renders page not found when id is nonexistent", %{conn: conn} do
    assert_error_sent 404, fn ->
      get conn, question_path(conn, :show, -1)
    end
  end
end
