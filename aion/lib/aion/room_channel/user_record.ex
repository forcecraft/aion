defmodule Aion.RoomChannel.UserRecord do
  @moduledoc """
  This struct represents a player's game state in certain room.
  """

  @enforce_keys [:username]
  defstruct username: "anonymous",
            score: 0

  def update_score(player_record, amount) do
    Map.update!(player_record, :score, &(&1 + 1))
  end
end
