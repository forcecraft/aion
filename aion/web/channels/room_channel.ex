defmodule Aion.RoomChannel do
  @moduledoc """
  This module is responsible for providing a commucation between Elixir and Elm. It describes how the backend part
  should react to new messages or events.
  """

  use Phoenix.Channel
  alias Aion.RoomChannel.Monitor
  alias Aion.Presence

  def join("rooms:" <> room_id, _params, socket) do
    current_user = get_user(socket)

    # Note: this is a temporary solution.
    # In the future, this function should return an error if a user wants to join a room that does not exist.
    if not Monitor.exists?(room_id) do
        Monitor.create(room_id)
    end

    send self(), {:after_join, room_id, current_user}
    {:ok, socket}
  end

  def handle_in("user:left", %{}, socket) do
    "rooms:" <> room_id = socket.topic
    current_user = get_user(socket)

    IO.puts "USER LEFT"
    # Note: the following user_left function is used when player joins another room
    # As for now, we only allow player to be present in one room at a time
    Monitor.user_left(room_id, current_user)
    Presence.untrack(socket, current_user)
    {:noreply, socket}
  end

  def handle_in("new:msg", %{"body" => body}, socket) do
    broadcast! socket, "new:msg", %{body: body}
    {:noreply, socket}
  end

  def handle_in("new:answer", %{"room_id" => room_id, "answer" => answer}, socket) do
    username = get_user(socket)
    evaluation = Monitor.new_answer(room_id, answer, username)
    send_feedback socket, evaluation

    if evaluation == 1.0 do
      send_scores(socket, room_id)
      send_new_question(socket, room_id)
    end

    {:noreply, socket}
  end

  def handle_info({:after_join, room_id, current_user}, socket) do
    Presence.track(socket, current_user, %{
          online_at: inspect(System.system_time(:seconds))
    })

    send_current_question(socket, room_id)
    {:noreply, socket}
  end

  intercept ["presence_diff"]

  def handle_out("presence_diff", %{joins: joins, leaves: leaves}, socket) do
      room_id = get_room_id(socket)

      handle_joins(joins, room_id)
      handle_leaves(leaves, room_id)
      send_scores(socket, room_id)

      {:noreply, socket}
  end

  defp handle_joins(joins, _) when joins == %{}, do: nil
  defp handle_joins(joins, room_id) do
    [user] = Map.keys(joins)
    Monitor.user_joined(room_id, user)
  end

  defp handle_leaves(leaves, _) when leaves == %{}, do: nil
  defp handle_leaves(leaves, room_id) do
    [user] = Map.keys(leaves)
    Monitor.user_left(room_id, user)
  end

  defp send_scores(socket, room_id) do
    scores = Monitor.get_scores(room_id)
    broadcast! socket, "user:list", %{users: scores}
  end

  defp send_new_question(socket, room_id) do
    Monitor.new_question(room_id)
    send_current_question(socket, room_id)
  end

  defp send_current_question(socket, room_id) do
    question = Monitor.get_current_question(room_id)
    image_name = if question.image_name == nil, do: "", else: question.image_name
    broadcast! socket, "new:question", %{content: question.content, image_name: image_name}
  end

  defp send_feedback(socket, evaluation) do
    feedback = cond do
      evaluation == 1.0 -> :correct
      evaluation > 0.8 -> :close
      true -> :incorrect
    end

    push socket, "answer:feedback", %{"feedback" => feedback}
  end

  defp get_room_id(socket) do
    "rooms:" <> room_id = socket.topic
    room_id
  end

  defp get_user(socket) do
    socket.assigns.current_user.name
  end
end
