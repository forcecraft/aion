defmodule Aion.RoomChannel.Monitor do
  @moduledoc """
  This module represents a GenServer that holds current game state in certain Room.
  """
  use GenServer
  alias Aion.RoomChannel.UserRecord
  alias Aion.RoomChannel.Room
  require Logger

  #####################
  # General interface #
  #####################

  def start_link({:room_id, room_id}, state \\ []) do
    GenServer.start_link(__MODULE__, Room.new(room_id, state), name: ref(room_id))
  end

  def create(room_id, opts \\ []) do
    case GenServer.whereis(ref(room_id)) do
      nil ->
        {:ok, pid} = Supervisor.start_child(Aion.RoomChannel.Supervisor, [room_id: room_id] ++ opts)
        Logger.info("[monitor] Spawned room GenServer " <> Kernel.inspect(pid))
      _board ->
        {:error, :room_already_exists}
    end
  end

  @doc """
  This function is responsible for commanding certain room's GenServer to shut down
  """
  def shutdown(room_id) do
    try_call(room_id, :stop)
  end

  defp try_call(room_id, message) do
    case GenServer.whereis(ref(room_id)) do
      nil ->
        {:error, :room_does_not_exist}
      room ->
        GenServer.call(room, message)
    end
  end

  defp ref(room_id) do
    {:global, {:room, room_id}}
  end

  @doc """
    Checks if a given room exists
  """
  def exists?(room_id) do
    GenServer.whereis(ref(room_id)) != nil
  end

  ###########################
  # Game specific interface #
  ###########################

  def user_joined(room_id, user) do
    try_call(room_id, {:user_joined, user})
  end

  def user_left(room_id, user) do
    try_call(room_id, {:user_left, user})
  end

  def get_scores(room_id) do
    try_call(room_id, {:get_scores})
  end

  def new_question(room_id) do
    try_call(room_id, {:new_question, room_id})
  end

  def new_answer(room_id, answer, username) do
    try_call(room_id, {:new_answer, answer, username})
  end

  def get_current_question(room_id) do
    try_call(room_id, {:get_current_question})
  end

  #########################
  #     Implementation    #
  #########################

  def terminate(reason, _state) do
    Logger.info("[monitor] One of the room GenServers has been stopped with a following reason: #{reason}")
  end

  def handle_call(:stop, _from, state) do
    Logger.info("[monitor] Stopping GenServer " <> Kernel.inspect(self()))
    {:stop, :normal, :ok, state}
  end

  def handle_call({:user_joined, username}, _from, state) do
    new_user = %UserRecord{username: username}
    new_state = Room.add_user(state, new_user)
    {:reply, :ok, new_state}
  end

  def handle_call({:user_left, username}, _from, state) do
    new_state = Room.remove_user(state, username)
    {:reply, :ok, new_state}
  end

  def handle_call({:get_scores}, _from, state) do
    users = Room.get_scores(state)
    {:reply, users, state}
  end

  def handle_call({:new_question, room_id}, _from, state) do
    new_state = Room.change_question(state, room_id)
    {:reply, new_state, new_state}
  end

  def handle_call({:new_answer, answer, username}, _from, state) do
    evaluation = Room.evaluate_answer(state, answer)

    if evaluation == 1.0 do
      new_state = Room.award_user(state, username)
      {:reply, evaluation, new_state}
    else
      {:reply, evaluation, state}
    end
  end

  def handle_call({:get_current_question}, _from, state) do
    {:reply, Room.get_current_question(state), state}
  end
end
