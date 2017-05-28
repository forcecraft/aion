defmodule Aion.ChannelMonitor do
  use GenServer

  def start_link(initial_state) do
    GenServer.start_link(__MODULE__, initial_state, name: __MODULE__)
  end

  # GenServer interface

  def user_joined(channel, user) do
    GenServer.call(__MODULE__, {:user_joined, channel, user})
  end

  def user_left(channel, user) do
    GenServer.call(__MODULE__, {:user_left, channel, user})
  end

  def list_users(channel) do
    GenServer.call(__MODULE__, {:list_users, channel})
  end

  # GenServer implementation

  def handle_call({:user_joined, channel, user}, _from, state) do
    new_state =
      case Map.get(state, channel) do
        nil ->
          Map.put(state, channel, [user])
        users ->
          Map.put(state, channel, [user | users])
      end
    IO.puts "NEW STATE"
    IO.inspect new_state
    {:reply, new_state, new_state}
  end

  def handle_call({:user_left, channel, user}, _from, state) do
    {:reply, state, state}
  end

  def handle_call({:list_users, channel}, _from, state) do
    {:reply, Map.get(state, channel), state}
  end
end