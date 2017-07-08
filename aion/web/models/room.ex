defmodule Aion.Room do
  use Aion.Web, :model

  schema "rooms" do
    field :name, :string
    field :description, :string
    belongs_to :owner, Aion.Owner

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
