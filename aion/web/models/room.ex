defmodule Aion.Room do
  @moduledoc """
    Represents a game room with different categories of questions
  """
  use Aion.Web, :model
  alias Aion.{Category, RoomCategory, Repo}

  schema "rooms" do
    field(:name, :string)
    field(:description, :string)

    many_to_many(
      :categories,
      Category,
      join_through: RoomCategory,
      on_delete: :delete_all
    )

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> Repo.preload(:categories)
    |> cast(params, [:name, :description])
    |> validate_required([:name, :description])
    |> unique_constraint(:name)
    |> put_assoc(:categories, parse_category_ids(params))
  end

  def parse_category_ids(params) do
    (params["category_ids"] || [])
    |> Enum.map(fn id -> Repo.get(Category, id) end)
  end
end
