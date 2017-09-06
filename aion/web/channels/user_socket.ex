defmodule Aion.UserSocket do
  use Phoenix.Socket

  @type t :: %Phoenix.Socket{}

  alias Aion.{RoomChannel, Repo, User}
  alias Phoenix.Token

  channel "rooms:*", RoomChannel

  transport :websocket, Phoenix.Transports.WebSocket, timeout: 30_000

  def connect(%{"token" => token}, socket) do
    case Token.verify(socket, "user", token, max_age: 86_400) do
      {:ok, user_id} ->
        socket = assign(socket, :current_user, Repo.get!(User, user_id))
        {:ok, socket}
      {:error, _} ->
        :error
    end
  end

  def id(_socket), do: nil
end
