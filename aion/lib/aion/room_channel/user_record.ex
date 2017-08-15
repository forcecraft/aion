defmodule Aion.RoomChannel.UserRecord do
  @moduledoc """
  This struct represents a player's game state in certain room.
  """
  @enforce_keys [:username]
  defstruct username: "anonymous",
            score: 0

  def update_score(user_record, amount \\ 1) do
    Map.update!(user_record, :score, &(&1 + amount))
  end
end
