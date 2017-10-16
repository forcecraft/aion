defmodule Aion.UserSocket do
  use Phoenix.Socket
  import Guardian.Phoenix.Socket

  @type t :: %Phoenix.Socket{}

  alias Aion.{RoomChannel, Repo, User}
  alias Phoenix.Token

  channel "rooms:*", RoomChannel

  transport :websocket, Phoenix.Transports.WebSocket

  def connect(%{"token" => token}, socket) do
    case sign_in(socket, token) do
      {:ok, auth_socket, guardian_params} ->
        {:ok, auth_socket}
      _ ->
        {:ok, socket}
    end
  end

  def connect(_params, socket) do
    {:ok, socket}
  end

  def id(_socket), do: nil
end
