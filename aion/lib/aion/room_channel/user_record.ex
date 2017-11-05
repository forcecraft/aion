defmodule Aion.RoomChannel.UserRecord do
  @moduledoc """
  This struct represents a player's game state in certain room.
  """
  @type t :: %__MODULE__{
    username: String.t,
    score: integer,
    questions_asked: integer,
  }

  @enforce_keys [:username]
  defstruct username: "anonymous",
    score: 0,
    questions_asked: 0

  @spec update_score(__MODULE__.t, integer) :: __MODULE__.t
  def update_score(user_record, amount \\ 1) do
    Map.update!(user_record, :score, &(&1 + amount))
  end

  @spec bump_questions_asked(__MODULE__.t) :: __MODULE__.t
  def bump_questions_asked(user_record) do
    Map.update!(user_record, :questions_asked, &(&1 + 1))
  end
end
