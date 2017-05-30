defmodule Aion.ChannelMonitor do
  use GenServer
  alias Aion.Repo
  alias Aion.Question
  alias Aion.UserRecord
  import Ecto.Query, only: [from: 2]


  def start_link(initial_state) do
    GenServer.start_link(__MODULE__, initial_state, name: __MODULE__)
  end

  # GenServer interface

  def user_joined(room_id, user) do
    GenServer.call(__MODULE__, {:user_joined, room_id, user})
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

  # GenServer implementation

  def handle_call({:user_joined, room_id, username}, _from, state) do
    new_state =
      case Map.get(state, room_id) do
        nil ->
          Map.put(state, room_id, %{users: [%UserRecord{name: username, score: 0}], question: nil})
        %{ users: currentUsers } ->
          room_state = Map.put(state[room_id], :users , [%UserRecord{name: username, score: 0} | currentUsers])
          Map.put(state, room_id, room_state)
      end
      IO.puts "NEW STATE"
      IO.inspect new_state
    {:reply, new_state, new_state}
  end

  def handle_call({:user_left, room_id, user}, _from, state) do
    {:reply, state, state}
  end

  def handle_call({:list_users, room_id}, _from, state) do
    {:reply, Map.get(state, room_id), state}
  end

  def handle_call({:new_question, room_id}, _from, state) do
    questions = Repo.all(from q in Question, where: q.subject_id == ^room_id)
    #IO.puts "NEW_QUESTION"
    #IO.inspect questions
    {:reply, state, state}
  end
end
