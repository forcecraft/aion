defmodule Aion.Category do
  @moduledoc """
  This model represents a category of questions.
  """
  use Aion.Web, :model
  alias Aion.{Room, RoomCategory, User, UserCategoryScore}

  schema "categories" do
    field :name, :string
    many_to_many :rooms, Room,
      join_through: RoomCategory,
      on_delete: :delete_all
    many_to_many :users, User,
      join_through: UserCategoryScore,
      on_delete: :delete_all

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
