defmodule Aion.ChannelMonitor do
  use GenServer
  alias Aion.Repo
  alias Aion.Question
  alias Aion.Answer
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

  def new_answer(room_id, answer, username) do
    GenServer.call(__MODULE__, {:new_answer, room_id, answer, username})
  end

  # GenServer implementation

  def handle_call({:user_joined, room_id, username}, _from, state) do
    new_user_record = %UserRecord{name: username, score: 0}
    new_state =
      case Map.get(state, room_id) do
        nil ->
          %{question: question, answers: answers} = get_new_question_with_answers(room_id)
          Map.put(state, room_id, %{users: %{username => new_user_record}, question: question, answers: answers})
        %{ users: currentUsers } ->
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
    {:reply, get_new_question_with_answers(room_id), state}
  end

  def handle_call({:new_answer, room_id, answer, username}, _from, state) do
    evaluation = Map.get(state, room_id)
                 |> Map.get(:answers)
                 |> Enum.map(fn x -> Map.get(x, :content) end)
                 |> Enum.member?(answer)

    IO.inspect evaluation, label: "Answer evaluation"
    if evaluation do
        room_state = Map.get(state, room_id)
        users_in_room = Map.get(room_state, :users)
        %UserRecord{name: ^username, score: score} = Map.get(users_in_room, username)
        new_user_record = %UserRecord{name: username, score: score+1}
        updated_score_list = Map.put(users_in_room, username, new_user_record)

        new_room_state = Map.put(room_state, :users, updated_score_list)
        new_state = Map.put(state, room_id, new_room_state)
        {:reply, evaluation, new_state}
    else
        {:reply, evaluation, state}
    end
  end

  defp get_new_question_with_answers(category_id) do
    IO.puts "GETTING A NEW QUESTION"

    question = Repo.all(from q in Question, where: q.subject_id == ^category_id) |> Enum.random

    question_id = Map.get(question, :id)
    answers = Repo.all(from a in Answer, where: a.question_id == ^question_id)
    IO.inspect question
    IO.inspect answers
    %{question: question, answers: answers}
  end
end
