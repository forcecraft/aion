defmodule Aion.AnswerController do
  use Aion.Web, :controller

  alias Aion.{Answer, ErrorCodesViews}

  plug Guardian.Plug.EnsureAuthenticated, handler: __MODULE__

  def index(conn, _params) do
    answers = Repo.all(Answer)
    render(conn, "index.json", answers: answers)
  end

  def create(conn, %{"answer" => answer_params}) do
    changeset = Answer.changeset(%Answer{}, answer_params)

    case Repo.insert(changeset) do
      {:ok, answer} ->
        conn
        |> put_status(:created)
        |> put_resp_header("location", answer_path(conn, :show, answer))
        |> render("show.json", answer: answer)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(Aion.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    answer = Repo.get!(Answer, id)
    render(conn, "show.json", answer: answer)
  end

  def update(conn, %{"id" => id, "answer" => answer_params}) do
    answer = Repo.get!(Answer, id)
    changeset = Answer.changeset(answer, answer_params)

    case Repo.update(changeset) do
      {:ok, answer} ->
        render(conn, "show.json", answer: answer)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(Aion.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    answer = Repo.get!(Answer, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(answer)

    send_resp(conn, :no_content, "")
  end

  def unauthenticated(conn, _params) do
    ErrorCodesViews.unauthenticated(conn)
  end
end
