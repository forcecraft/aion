defmodule Aion.UserSocket do
  use Phoenix.Socket

  channel "rooms:*", Aion.SubjectChannel

  transport :websocket, Phoenix.Transports.WebSocket

  def connect(%{"token" => token}, socket) do
    case Phoenix.Token.verify(socket, "user", token, max_age: 86400) do
      {:ok, user_id} ->
        socket = assign(socket, :current_user, Aion.Repo.get!(Aion.User, user_id))
        {:ok, socket}
      {:error, _} ->
        :error
    end
  end

  def id(_socket), do: nil
end
