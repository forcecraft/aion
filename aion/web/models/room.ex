defmodule Aion.Room do
  use Aion.Web, :model
  alias Aion.{Subject, RoomSubject, User}

  schema "rooms" do
    field :name, :string
    field :description, :string
    many_to_many :subjects, Subject, join_through: RoomSubject
    belongs_to :owner, Aion.User

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
