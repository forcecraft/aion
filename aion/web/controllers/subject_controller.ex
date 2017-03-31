defmodule Aion.SubjectController do
  use Aion.Web, :controller

  alias Aion.Subject

  def index(conn, _params) do
    subjects = Repo.all(Subject)
    render(conn, "index.json", subjects: subjects)
  end

  def create(conn, %{"subject" => subject_params}) do
    changeset = Subject.changeset(%Subject{}, subject_params)

    case Repo.insert(changeset) do
      {:ok, subject} ->
        conn
        |> put_status(:created)
        |> put_resp_header("location", subject_path(conn, :show, subject))
        |> render("show.json", subject: subject)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(Aion.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    subject = Repo.get!(Subject, id)
    render(conn, "show.json", subject: subject)
  end

  def update(conn, %{"id" => id, "subject" => subject_params}) do
    subject = Repo.get!(Subject, id)
    changeset = Subject.changeset(subject, subject_params)

    case Repo.update(changeset) do
      {:ok, subject} ->
        render(conn, "show.json", subject: subject)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(Aion.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    subject = Repo.get!(Subject, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(subject)

    send_resp(conn, :no_content, "")
  end
end
