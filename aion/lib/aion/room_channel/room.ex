defmodule Room do
  @moduledoc """
  This module represents one game room
  """


  def compare_answers(first, second) do
      JaroWinkler.compare (String.capitalize first), (String.capitalize second)
  end
end