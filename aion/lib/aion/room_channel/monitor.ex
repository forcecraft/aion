defmodule Aion.RoomChannel.Monitor do
  use GenServer
  alias Aion.RoomChannel.PlayerRecord
  alias Aion.RoomChannel.Room


  #####################
  # general interface #
  #####################

  def start_link(room_id) do
    GenServer.start_link(__MODULE__, Room.new(), name: ref(room_id))
  end

  def create(room_id) do
    case GenServer.whereis(ref(room_id)) do
      nil ->
        Supervisor.start_child(Aion.RoomChannel.Supervisor, [room_id])
      _board ->
        {:error, :room_already_exists}
    end
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

  def exists?(room_id) do
    @doc "Checks if a given room exists"
    GenServer.whereis(ref(room_id)) != nil
  end

  ###########################
  # game specific interface #
  ###########################

  def user_joined(room_id, user) do
    try_call(room_id, {:user_joined, room_id, user})
  end

  def user_left(room_id, user) do
    try_call(room_id, {:user_left, room_id, user})
  end

  def list_users(room_id) do
    try_call(room_id, {:list_users, room_id})
  end

  def new_question(room_id) do
    try_call(room_id, {:new_question, room_id})
  end

  def new_answer(room_id, answer, username) do
    try_call(room_id, {:new_answer, room_id, answer, username})
  end

  def get_room_state(room_id) do
    try_call(room_id, {:get_room_state, room_id})
  end

  #########################
  #     implementation    #
  #########################

  def handle_call({:user_joined, room_id, username}, _from, state) do
    new_player = %PlayerRecord{name: username}
    new_state = Room.add_player(state, new_player)

    {:reply, new_state, new_state}
  end

  def handle_call({:user_left, room_id, user}, _from, state) do
    {:reply, state, state}
  end

  def handle_call({:list_users, room_id}, _from, state) do
    {:reply, Map.values(state.users), state}
  end

  def handle_call({:new_question, room_id}, _from, state) do
    new_state =
      state
      |> Map.merge(Room.get_new_question_with_answers(room_id))

    {:reply, new_state, new_state}
  end

  def handle_call({:new_answer, room_id, answer, username}, _from, state) do
    evaluation = Room.evaluate_answer(state, answer)

    if evaluation == 1.0 do
      {:reply, evaluation, Room.award_player(state, username)}
    else
      {:reply, evaluation, state}
    end
  end

  def handle_call({:get_room_state, room_id}, _from, state) do
    {:reply, state, state}
  end
end