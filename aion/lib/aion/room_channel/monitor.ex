defmodule Aion.RoomChannel.Monitor do
  use GenServer
  alias Aion.RoomChannel.PlayerRecord
  alias Aion.RoomChannel.Room

  def create(room_id) do
    case GenServer.whereis(ref(room_id)) do
      nil ->
        Supervisor.start_child(Aion.RoomChannel.Supervisor, [room_id])
      _board ->
        {:error, :room_already_exists}
    end
  end

  def start_link(room_id) do
    GenServer.start_link(__MODULE__, [], name: ref(room_id))
  end

  defp try_call(board_id, message) do
    case GenServer.whereis(ref(board_id)) do
      nil ->
        {:error, :room_does_not_exist}
      board ->
        GenServer.call(board, message)
    end
  end

  defp ref(room_id) do
    {:global, {:room, room_id}}
  end

  def exists(room_id) do
    GenServer.whereis(ref(room_id)) != nil
  end

  #####################

    # GenServer interface

  def user_joined(room_id, user) do
    try_call(room_id, {:user_joined, room_id, user})
  end

  def user_left(room_id, user) do
    GenServer.call(__MODULE__, {:user_left, room_id, user})
  end

  def list_users(room_id) do
    GenServer.call(__MODULE__, {:list_users, room_id})
  end

  def new_question(room_id) do
    GenServer.call(__MODULE__, {:new_question, room_id})
  end

  def new_answer(room_id, answer, username) do
    GenServer.call(__MODULE__, {:new_answer, room_id, answer, username})
  end

  def get_room_state(room_id) do
    GenServer.call(__MODULE__, {:get_room_state, room_id})
  end

  # GenServer implementation

  def handle_call({:user_joined, room_id, username}, _from, state) do
    new_user_record = %PlayerRecord{name: username, score: 0}
    new_state =
      case Map.get(state, room_id) do
        nil ->
          %{question: question, answers: answers} = Room.get_new_question_with_answers(room_id)
          Map.put(state, room_id, %{users: %{username => new_user_record}, question: question, answers: answers})
        %{users: currentUsers} ->
          room_state = Map.put(state[room_id], :users , Map.put(currentUsers, username , new_user_record))
          Map.put(state, room_id, room_state)
      end
    {:reply, new_state[room_id], new_state}
  end

  def handle_call({:user_left, room_id, user}, _from, state) do
    {:reply, state, state}
  end

  def handle_call({:list_users, room_id}, _from, state) do
    {:reply, Map.values(Map.get(state, room_id).users), state}
  end

  def handle_call({:new_question, room_id}, _from, state) do
    room_state = state
                 |> Map.get(room_id)
                 |> Map.merge(Room.get_new_question_with_answers(room_id))
    state = Map.put(state, room_id, room_state)
    {:reply, state, state}
  end

  def handle_call({:new_answer, room_id, answer, username}, _from, state) do
    evaluation = state
                 |> Map.get(room_id)
                 |> Map.get(:answers)
                 |> Enum.map(fn x -> Map.get(x, :content) end)
                 |> Enum.map(fn correct_answer -> Room.compare_answers(correct_answer, answer) end)
                 |> Enum.max

    if evaluation == 1.0 do
      new_state = update_in(state, [room_id, :users, username], &PlayerRecord.increment_score/1)
      {:reply, evaluation, new_state}
    else
      {:reply, evaluation, state}
    end
  end

  def handle_call({:get_room_state, room_id}, _from, state) do
    {:reply, state[room_id], state}
  end
end