defmodule Aion.QuestionChronicle do
  @moduledoc """
    This module saves the time when questions were
    changed in specific rooms. Thanks to that when a timer
    fires, it's easy to check if the question should be changed
    to a new one.
  """
  @question_timeout_seconds 10
  @question_timeout_micro @question_timeout_seconds * 1_000_000

  def question_timeout_micro, do: @question_timeout_micro
  def question_timeout_milli, do: div @question_timeout_micro, 1000

  def start_link do
    Agent.start_link(fn -> %{} end, name: __MODULE__)
  end

  @doc "Lists all entries stored by the Agent"
  def list_entries, do: Agent.get(__MODULE__, &(&1))

  @doc "Checks if a question should be changed due to a timeout"
  def should_change?(room_id), do: should_change?(room_id, &get_current_time/0)
  def should_change?(room_id, time) do
    last_changed = Agent.get(__MODULE__, fn chronicle ->
      Map.get(chronicle, room_id)
    end)

    time.() >= last_changed + @question_timeout_micro
  end

  @doc "Updates question change's timestamp"
  def update_last_change(room_id), do: update_last_change(room_id, &get_current_time/0)
  def update_last_change(room_id, time) do
    Agent.update(__MODULE__, &Map.put(&1, room_id, time.()))
  end

  defp get_current_time do
    # "Returns current time in microseconds"
    :os.system_time(:micro_seconds)
  end

end
