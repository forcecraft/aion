defmodule Aion.Timeout do
  @moduledoc """
    This module takes care of importing timeouts from configs
    and providing a convenient API for other modules
    (making it possible to ask for timeouts in specific units).
  """
  defp from_seconds(value, unit) do
    case unit do
      :second -> value
      :millisecond -> value * 1_000
      :microsecond -> value * 1_000_000
    end
  end

  defp get_env(key) do
    :aion
    |> Application.get_env(__MODULE__)
    |> Keyword.get(key)
  end

  defp get_and_convert(key, unit) do
    key
    |> get_env
    |> from_seconds(unit)
  end

  @doc """
  Returns the timeout after which the question should be changed
  """
  def question_timeout(unit \\ :second), do: get_and_convert(:question_timeout, unit)

  @doc """
  Returns the timeout after which the question break should end
  """
  def question_break_timeout(unit \\ :second), do: get_and_convert(:question_break_timeout, unit)

  @doc """
  The next question shall be sent next_question_delay units of time after introducing
  question_break state.
  """
  def next_question_delay(unit \\ :second), do: get_and_convert(:next_question_delay, unit)
end
