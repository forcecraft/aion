defmodule Aion.RoomChannel do
  @moduledoc """
  This module is responsible for providing a commucation between Elixir and Elm. It describes how the backend part
  should react to new messages or events.
  """

  use Phoenix.Channel, log_join: false, log_handle_in: :info
  alias Aion.{
    Presence,
    RoomChannel.Monitor,
    QuestionChronicle,
    UserSocket,
  }
  require Logger

  @current_question_topic "current_question"
  @display_question_topic "display_question"
  @question_break_topic "question_break"

  @spec join(String.t, %{}, UserSocket.t) :: {:ok, UserSocket.t}
  def join("rooms:" <> room_id, _params, socket) do
    username = UserSocket.get_user_name(socket)
    # NOTE: this is a temporary solution.
    # In the future, this function should return an error if a user wants to join a room that does not exist.
    if not Monitor.exists?(room_id) do
        Monitor.create(room_id)

        # NOTE: this is ineeded to start the room_state_timeout cycle
        {:ok, timeout} = QuestionChronicle.initialize_room_state(room_id)
        :timer.send_after(timeout, :room_state_timeout)
    end

    Monitor.user_joined(room_id, username)
    Logger.info("[channel] #{username} joined room #{room_id}")

    Presence.track(socket, username, %{
          online_at: inspect(System.system_time(:seconds))
    })

    send self(), :after_join
    {:ok, socket}
  end

  def terminate(msg, socket) do
    username = UserSocket.get_user_name(socket)
    room_id = UserSocket.get_room_id(socket)

    Monitor.user_left(room_id, username)
    Presence.untrack(socket, username)
    Logger.info("[channel] #{username} left: " <> Kernel.inspect(msg))

    if Monitor.get_scores(room_id) == [] do
        Monitor.shutdown(room_id)
        QuestionChronicle.remove_room_state(room_id)
    end
  end

  def handle_in("new:msg", %{"body" => body}, socket) do
    broadcast! socket, "new:msg", %{body: body}
    {:noreply, socket}
  end

  def handle_in("new:answer", %{"room_id" => room_id, "answer" => answer}, socket) do
    username = UserSocket.get_user_name(socket)
    user_id = UserSocket.get_user_id(socket)
    evaluation = Monitor.new_answer(room_id, answer, username, user_id)
    send_feedback socket, evaluation

    if evaluation == 1.0 do
      send_scores(socket)
      change_question(socket)
      send_current_question(socket)
      QuestionChronicle.change_room_state(room_id)
    end

    {:noreply, socket}
  end

  def handle_info(:after_join, socket) do
    send_scores(socket)
    send_current_question(socket)
    send_display_question(socket)
    {:noreply, socket}
  end

  def handle_info(:room_state_timeout, socket) do
    room_id = UserSocket.get_room_id(socket)
    {_timestamp, old_state} = QuestionChronicle.get_agent_entry(room_id)

    if QuestionChronicle.should_change?(room_id) do
      Logger.info("[channel] Question timed out in room: #{room_id}. Fetching a new one...")

      case old_state do
        :question -> send_question_break(socket)
        :break -> send_display_question(socket)
      end

      {:ok, {timeout, state}} = QuestionChronicle.change_room_state(room_id)
      Logger.debug(fn -> "[channel] Current state is now #{state} with timeout #{timeout}" end)

      :timer.send_after(timeout, :room_state_timeout)
    else
      Logger.error(fn -> "[channel] Timer went off in room: #{room_id}. Too early, though." end)
    end

    {:noreply, socket}
  end

  def handle_info(:next_question_timeout, socket) do
    send_current_question(socket)
    {:noreply, socket}
  end

  intercept ["presence_diff"]

  def handle_out("presence_diff", %{joins: _, leaves: _}, socket) do
      # NOTE: This function currently sends scores.
      # 1. We may update it later to only send the presence diff and handle it
      # properly on the frontend side
      # 2. The send scores here is called only when there are > 1 people in
      # the room. If you're the first person joining the room, you're going
      # to receive the scores from :after_join.
      send_scores(socket)

      {:noreply, socket}
  end

  defp send_scores(socket) do
    room_id = UserSocket.get_room_id(socket)

    scores = Monitor.get_scores(room_id)
    broadcast! socket, "user:list", %{users: scores}
  end

  defp change_question(socket) do
    room_id = UserSocket.get_room_id(socket)
    Monitor.new_question(room_id)
  end

  defp send_display_question(socket) do
    broadcast! socket, @display_question_topic, %{}
  end

  defp send_question_break(socket) do
    broadcast! socket, @question_break_topic, %{}
    change_question(socket)
    :timer.send_after(1000, :next_question_timeout)
  end

  defp send_current_question(socket) do
    room_id = UserSocket.get_room_id(socket)
    # NOTE: This function is called every time a user joins room / the question changes
    question = Monitor.get_current_question(room_id)
    image_name = if question.image_name == nil, do: "", else: question.image_name

    broadcast! socket, @current_question_topic, %{content: question.content, image_name: image_name}
  end

  defp send_feedback(socket, evaluation) do
    feedback = cond do
      evaluation == 1.0 -> :correct
      evaluation > 0.8 -> :close
      true -> :incorrect
    end

    push socket, "answer:feedback", %{"feedback" => feedback}
  end
end
