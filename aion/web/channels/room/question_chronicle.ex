defmodule Aion.Channels.Room.QuestionChronicle do
  @moduledoc """
    This module saves the time when questions were
    changed in specific rooms. Thanks to that when a timer
    fires, it's easy to check if the question should be changed
    to a new one.
  """
  @type t :: %{binary => {integer, atom}}

  alias Aion.Timeout
  defdelegate question_timeout(unit), to: Timeout
  defdelegate question_break_timeout(unit), to: Timeout

  def start_link(name \\ __MODULE__) do
    Agent.start_link(fn -> %{} end, name: name)
  end

  @doc "Lists all question change entries stored by the Agent"
  @spec list_entries :: __MODULE__.t()
  def list_entries, do: Agent.get(__MODULE__, & &1)

  @doc "Checks if a question should be changed due to a timeout using the default time function"
  @spec should_change?(binary) :: boolean
  def should_change?(room_id), do: should_change?(room_id, &get_current_time/0)

  @doc "Checks if a question should be changed due to a timeout"
  @spec should_change?(binary, function) :: boolean
  def should_change?(room_id, time) do
    {last_changed, current_state} = get_agent_entry(room_id)

    timeout =
      case current_state do
        :question -> question_timeout(:microsecond)
        :break -> question_break_timeout(:microsecond)
      end

    time.() >= last_changed + timeout
  end

  def initialize_room_state(room_id, current_time \\ &get_current_time/0) do
    entry = {current_time.(), :question}
    Agent.update(__MODULE__, &Map.put(&1, room_id, entry))

    {:ok, question_timeout(:millisecond)}
  end

  def remove_room_state(room_id) do
    Agent.update(__MODULE__, &Map.delete(&1, room_id))
  end

  @doc "Changes room's state in the chronicle"
  @spec change_room_state(binary, (() -> integer())) :: {:ok, {integer, atom}}
  def change_room_state(room_id, time \\ &get_current_time/0) do
    {_timeout, state} = get_agent_entry(room_id)
    {_timeout, state} = entry = {time.(), get_next_state(state)}

    Agent.update(__MODULE__, &Map.put(&1, room_id, entry))

    {:ok, {get_timeout_for_state(state), state}}
  end

  @spec get_agent_entry(binary) :: {integer, atom}
  def get_agent_entry(room_id), do: Agent.get(__MODULE__, &Map.get(&1, room_id))

  @spec get_current_time :: integer
  defp get_current_time, do: System.system_time(:microsecond)

  defp get_next_state(:question), do: :break
  defp get_next_state(:break), do: :question

  defp get_timeout_for_state(:question), do: question_timeout(:millisecond)
  defp get_timeout_for_state(:break), do: question_break_timeout(:millisecond)
end
