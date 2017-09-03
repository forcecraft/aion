defmodule Aion.RoomCategory do
  @moduledoc """
    Join table between Room and Category
  """
  use Aion.Web, :model

  schema "room_categories" do
    belongs_to :room, Aion.Room
    belongs_to :category, Aion.Category

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [])
    |> validate_required([])
  end
end
