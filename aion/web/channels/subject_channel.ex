defmodule Aion.SubjectChannel do
  use Phoenix.Channel
  alias Aion.ChannelMonitor

  def join("rooms:" <> room_id, _params, socket) do
    current_user = socket.assigns.current_user.name
    %{users: users, question: question} = ChannelMonitor.user_joined(room_id, current_user)

    send self, {:after_join, users, question}
    {:ok, socket}
  end

  def handle_in("user_left", %{"room_id" => room_id}, socket) do
    current_user = socket.assigns.current_user.name
    users = ChannelMonitor.user_left({room_id, current_user})
    :ok
  end

  def handle_in("new:msg", %{"body" => body}, socket) do
    broadcast! socket, "new:msg", %{body: body}
    {:noreply, socket}
  end

   def handle_in("new:answer", %{"room_id" => room_id, "answer" => answer}, socket) do
     ChannelMonitor.new_answer(room_id)
     {:noreply, socket}
   end

  def handle_info({:after_join, users, question}, socket) do
    send_user_list(socket, users)
    send_question(socket, question)
    {:noreply, socket}
  end

  defp send_user_list(socket, users) do
    broadcast! socket, "user:list", %{users: users}
  end

  defp send_question(socket, question) do
    image_name = if question.image_name == nil, do: "", else: question.image_name
    broadcast! socket, "new:question", %{ content: question.content, image_name: image_name }
  end
end
