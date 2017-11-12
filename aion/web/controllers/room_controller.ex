defmodule Aion.RoomController do
  use Aion.Web, :controller

  alias Aion.Room
  alias Aion.RoomChannel.Monitor

  plug(Guardian.Plug.EnsureAuthenticated, handler: __MODULE__)

  def index(conn, params) do
    rooms = Repo.all(Room)

    case params do
      %{"with_counts" => "true"} -> index_with_counts(conn, rooms)
      %{} -> render(conn, "index.json", rooms: rooms)
    end
  end

  def index_with_counts(conn, rooms) do
    counts = Monitor.get_player_counts()

    rooms_with_counts =
      rooms
      |> Enum.map(&Map.from_struct/1)
      |> Enum.map(&extend_with_counts(&1, counts))
      |> Enum.map(&Map.drop(&1, [:categories, :inserted_at, :updated_at, :__meta__]))

    render(conn, "index_with_counts.json", rooms: rooms_with_counts)
  end

  defp extend_with_counts(room, counts) do
    room_id = Integer.to_string(room.id)
    player_count = Map.get(counts, room_id, 0)

    Map.put(room, :player_count, player_count)
  end

  def create(conn, %{"room" => room_params}) do
    changeset = Room.changeset(%Room{}, room_params)

    case Repo.insert(changeset) do
      {:ok, room} ->
        conn
        |> put_status(:created)
        |> put_resp_header("location", room_path(conn, :show, room))
        |> render("show.json", room: room)

      {:error, changeset} ->
        Errors.unprocessable_entity(conn, changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    room = Repo.get!(Room, id)
    render(conn, "show.json", room: room)
  end

  def update(conn, %{"id" => id, "room" => room_params}) do
    room = Repo.get!(Room, id)
    changeset = Room.changeset(room, room_params)

    case Repo.update(changeset) do
      {:ok, room} ->
        render(conn, "show.json", room: room)

      {:error, changeset} ->
        Errors.unprocessable_entity(conn, changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    room = Repo.get!(Room, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(room)

    send_resp(conn, :no_content, "")
  end

  def unauthenticated(conn, _params) do
    Errors.unauthenticated(conn)
  end
end
