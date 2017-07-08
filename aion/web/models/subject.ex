defmodule Aion.Subject do
  @moduledoc """
  This model represents a category of questions.
  """
  use Aion.Web, :model
  alias Aion.{Room, RoomSubject}
  schema "subjects" do
    field :name, :string
    many_to_many :rooms, Room, join_through: RoomSubject
    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:name])
    |> validate_required([:name])
  end
end
