defmodule Aion.RoomSubject do
  @moduledoc """
    Join table between Room and Subject
  """
  use Aion.Web, :model

  schema "room_subjects" do
    belongs_to :room, Aion.Room
    belongs_to :subject, Aion.Category

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
