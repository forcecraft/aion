defmodule Aion.ChannelMonitor do
  @moduledoc """
  ChannelMonitor is deprecated and is going to be replaced by other modules pretty soon. Its tasks for now is holding
  the state of all the rooms.
  """
  use GenServer
  alias Aion.{Repo, Question, Answer, UserRecord}
  alias Simetric.Jaro.Winkler, as: JaroWinkler
  import Ecto.Query, only: [from: 2]
  require Logger

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

  def new_answer(room_id, answer, username) do
    GenServer.call(__MODULE__, {:new_answer, room_id, answer, username})
  end

  def get_room_state(room_id) do
    GenServer.call(__MODULE__, {:get_room_state, room_id})
  end

  # GenServer implementation

  def handle_call({:user_joined, room_id, username}, _from, state) do
    new_user_record = %UserRecord{name: username, score: 0}
    new_state =
      case Map.get(state, room_id) do
        nil ->
          %{question: question, answers: answers} = get_new_question_with_answers(room_id)
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
                 |> Map.merge(get_new_question_with_answers(room_id))
    state = Map.put(state, room_id, room_state)
    {:reply, state, state}
  end

  def handle_call({:new_answer, room_id, answer, username}, _from, state) do
    evaluation = state
                 |> Map.get(room_id)
                 |> Map.get(:answers)
                 |> Enum.map(fn x -> Map.get(x, :content) end)
                 |> Enum.map(fn correct_answer -> compare_answers(correct_answer, answer) end)
                 |> Enum.max

    if evaluation == 1.0 do
      new_state = update_in(state, [room_id, :users, username], &increment_score/1)
      {:reply, evaluation, new_state}
    else
      {:reply, evaluation, state}
    end
  end

  def handle_call({:get_room_state, room_id}, _from, state) do
    {:reply, state[room_id], state}
  end
end
