defmodule Aion.RoomChannel.UserRecord do
  @moduledoc """
  This struct represents a player's game state in certain room.
  """
  @enforce_keys [:username]
  defstruct username: "anonymous",
            score: 0

  alias Aion.Types

  @spec update_score(user_record :: Types.user_record, amount :: integer) :: Types.user_record
  def update_score(user_record, amount \\ 1) do
    Map.update!(user_record, :score, &(&1 + amount))
  end
end
