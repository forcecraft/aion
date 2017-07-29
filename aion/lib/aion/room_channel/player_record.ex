defmodule Aion.RoomChannel.PlayerRecord do
  @moduledoc """
  This struct represents a player's game state in certain room.
  """

  defstruct name: "anonymous", score: 0

  def update_score(player_record, amount) do
    Map.update!(player_record, :score, &(&1 + 1))
  end
end
