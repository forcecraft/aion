defmodule Aion.RoomSubjectController do
  use Aion.Web, :controller

  alias Aion.RoomSubject

  def index(conn, _params) do
    room_subjects = Repo.all(RoomSubject)
    render(conn, "index.json", room_subjects: room_subjects)
  end

  def create(conn, %{"room_subject" => room_subject_params}) do
    changeset = RoomSubject.changeset(%RoomSubject{}, room_subject_params)

    case Repo.insert(changeset) do
      {:ok, room_subject} ->
        conn
        |> put_status(:created)
        |> put_resp_header("location", room_subject_path(conn, :show, room_subject))
        |> render("show.json", room_subject: room_subject)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(Aion.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    room_subject = Repo.get!(RoomSubject, id)
    render(conn, "show.json", room_subject: room_subject)
  end

  def update(conn, %{"id" => id, "room_subject" => room_subject_params}) do
    room_subject = Repo.get!(RoomSubject, id)
    changeset = RoomSubject.changeset(room_subject, room_subject_params)

    case Repo.update(changeset) do
      {:ok, room_subject} ->
        render(conn, "show.json", room_subject: room_subject)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(Aion.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    room_subject = Repo.get!(RoomSubject, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(room_subject)

    send_resp(conn, :no_content, "")
  end
end
