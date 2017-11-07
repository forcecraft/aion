defmodule Aion.Timeout do
  @moduledoc """
    This module takes care of importing timeouts from configs
    and providing a convenient API for other modules
    (making it possible to ask for timeouts in specific units).
  """
  @micro 1_000_000
  @milli 1_000

  def get_env(key) do
    :aion
    |> Application.get_env(__MODULE__)
    |> Keyword.get(key)
  end

  @doc """
  Returns the timeout after which the question should be changed
  """
  def question_timeout(_unit \\ :second)
  def question_timeout(:second), do: get_env(:question_timeout)
  def question_timeout(:millisecond), do: question_timeout() * @milli
  def question_timeout(:microsecond), do: question_timeout() * @micro

  @doc """
  Returns the timeout after which the question break should end
  """
  def question_break_timeout(_unit \\ :second)
  def question_break_timeout(:second), do: get_env(:question_break_timeout)
  def question_break_timeout(:millisecond), do: question_break_timeout() * @milli
  def question_break_timeout(:microsecond), do: question_break_timeout() * @micro
end
