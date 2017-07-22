defmodule Aion.QuestionController do
  use Aion.Web, :controller

  alias Aion.Question
  alias Aion.Answer
  alias Aion.Subject

  @answer_separator ","

  def index(conn, _params) do
    questions = Repo.all(Question)
    render(conn, "index.json", questions: questions)
  end

  def create(conn, %{"question" => question_params, "answers" => answers_content, "subject" => subject_id}) do
    question_subject = Repo.get(Subject, subject_id)

    transaction_result = Repo.transaction(fn ->
      question_changeset = Question.changeset(%Question{}, Map.put(question_params, "belongs_to", question_subject))
      case Repo.insert(question_changeset) do
        {:ok, question} ->
          insert_asnwers =
            answers_content
            |> String.split(@answer_separator)
            |> Enum.map(fn answer_content -> Answer.changeset(%Answer{}, %{"content" => answer_content, "belongs_to" => question}) end)
            |> Enum.map(fn answer_changeset -> Repo.insert(answer_changeset) end)

          if Enum.all?(insert_asnwers, fn {insert_result, _} -> insert_result == :ok end) do
            question #TODO: change to return also answers and subject to a client?
          else
            Repo.rollback(:error)
          end
        {:error, error_question_changeset} ->
          Repo.rollback(error_question_changeset)
      end
    end)

    case transaction_result do
      {:ok, question} ->
        conn
          |> put_status(:created)
          |> put_resp_header("location", question_path(conn, :show, question))
          |> render("show.json", question: question)
      {:error, changeset} ->
        conn
          |> put_status(:unprocessable_entity)
          |> render(Aion.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    question = Repo.get!(Question, id)
    render(conn, "show.json", question: question)
  end

  def update(conn, %{"id" => id, "question" => question_params}) do
    question = Repo.get!(Question, id)
    changeset = Question.changeset(question, question_params)

    case Repo.update(changeset) do
      {:ok, question} ->
        render(conn, "show.json", question: question)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(Aion.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    question = Repo.get!(Question, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(question)

    send_resp(conn, :no_content, "")
  end
end
