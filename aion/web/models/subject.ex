defmodule Aion.Subject do
  @moduledoc """
  This model represents a category of questions.
  """
  use Aion.Web, :model

  schema "subjects" do
    field :name, :string

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
