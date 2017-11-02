defmodule Aion.UserSocket do
  use Phoenix.Socket
  import Guardian.Phoenix.Socket

  @type t :: %Phoenix.Socket{}

  alias Aion.RoomChannel

  channel "rooms:*", RoomChannel

  transport :websocket, Phoenix.Transports.WebSocket

  def connect(%{"token" => token}, socket) do
    case sign_in(socket, token) do
      {:ok, auth_socket, _guardian_params} ->
        {:ok, auth_socket}
      _ ->
        {:ok, socket}
    end
  end

  def connect(_params, socket) do
    {:ok, socket}
  end

  def id(_socket), do: nil

  def get_room_id(socket) do
    "rooms:" <> room_id = socket.topic
    room_id
  end

  def get_user(socket) do
    {:ok, user} = GuardianSerializer.from_token(socket.assigns.guardian_default_claims["aud"])
    user
  end

  def get_user_name(socket) do
    get_user(socket).name
  end

  def get_user_id(socket) do
    get_user(socket).id
  end
end
