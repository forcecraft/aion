defmodule Aion.Room do
  @moduledoc """
    Represents a game room with different categories of questions
  """
  use Aion.Web, :model
  alias Aion.{Subject, RoomSubject}

  schema "rooms" do
    field :name, :string
    field :description, :string
    many_to_many :subjects, Subject,
      join_through: RoomSubject

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:name, :description])
    |> validate_required([:name, :description])
    |> unique_constraint(:name)
  end
end
