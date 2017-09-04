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
      join_through: RoomSubject,
      on_delete: :delete_all

      timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> Aion.Repo.preload(:subjects)
    |> cast(params, [:name, :description])
    |> validate_required([:name, :description])
    |> unique_constraint(:name)
    |> put_assoc(:subjects, parse_subject_ids(params))
  end

  def parse_subject_ids(params) do
    (params["subject_ids"] || [])
    |> Enum.map(fn(id) -> Aion.Repo.get(Aion.Subject, id) end)
  end
end
