defmodule Aion.RoomChannel.Monitor do
  use GenServer

  def create(room_id) do
    case GenServer.whereis(ref(room_id)) do
      nil ->
        Supervisor.start_child(PhoenixTrello.BoardChannel.Supervisor, [room_id])
      _board ->
        {:error, :room_already_exists}
    end
  end

  def start_link(room_id) do
    GenServer.start_link(__MODULE__, [], name: ref(room_id))
  end

  defp try_call(board_id, message) do
    case GenServer.whereis(ref(board_id)) do
      nil ->
        {:error, :invalid_board}
      board ->
        GenServer.call(board, message)
    end
  end

  defp ref(room_id) do
    {:global, {:room, room_id}}
  end
end