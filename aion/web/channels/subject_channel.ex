defmodule Aion.SubjectChannel do
  use Phoenix.Channel
  alias Aion.ChannelMonitor

  def join("rooms:" <> room_id, _params, socket) do
    current_user = socket.assigns.current_user.name
    users = ChannelMonitor.user_joined(room_id, current_user)[room_id]

    send self, {:after_join, users}
    {:ok, socket}
  end

  def handle_in("user_left", %{"room_id" => room_id}, socket) do
    current_user = socket.assigns.current_user.name
    users = ChannelMonitor.user_left({room_id, current_user})[room_id]
    update_room(socket, users)
    :ok
  end

  def handle_in("new:msg", %{"body" => body}, socket) do
    broadcast! socket, "new:msg", %{body: body}
    {:noreply, socket}
  end

  def handle_info({:after_join, users}, socket) do
    update_room(socket, users)
    {:noreply, socket}
  end

  defp update_room(socket, users) do
    broadcast! socket, "room_update", %{users: users}
  end
end
