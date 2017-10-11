defmodule Aion.QuestionControllerTest do
  use Aion.ConnCase

  alias Aion.Question

  @valid_attrs %{content: "some content", image_name: "some content"}
  @invalid_attrs %{}
  @answers "some content"
  @category 1

  setup %{conn: _} do
    user = %Aion.User{ email: "test@example.com", name: "something", password: "2131231", id: 1 }
    {:ok, jwt, _} = Guardian.encode_and_sign(user)
    conn =
      build_conn()
      |> put_req_header("authorization", "Bearer #{jwt}")
    {:ok, %{conn: conn}}
  end
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

  test "creates and renders resource when data is valid", %{conn: conn} do
    conn = post conn, question_path(conn, :create), question: @valid_attrs, answers: @answers, category: @category
    assert json_response(conn, 201)["data"]["id"]
    assert Repo.get_by(Question, @valid_attrs)
  end

  test "does not create resource and returns 500 when data is invalid", %{conn: conn} do
    conn = post conn, question_path(conn, :create), question: @invalid_attrs, answers: @answers, category: @category
    assert response(conn, 500)
  end

  test "updates and renders chosen resource when data is valid", %{conn: conn} do
    question = Repo.insert! %Question{}
    conn = put conn, question_path(conn, :update, question), question: @valid_attrs
    assert json_response(conn, 200)["data"]["id"]
    assert Repo.get_by(Question, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    question = Repo.insert! %Question{}
    conn = put conn, question_path(conn, :update, question), question: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "deletes chosen resource", %{conn: conn} do
    question = Repo.insert! %Question{}
    conn = delete conn, question_path(conn, :delete, question)
    assert response(conn, 204)
    refute Repo.get(Question, question.id)
  end
end
