defmodule Aion.User do
  @moduledoc """
  User model, necessary for authentication.
  """
  @type t :: %__MODULE__{name: String.t, email: String.t, encrypted_password: String.t}
  use Aion.Web, :model

  schema "users" do
    field :name, :string
    field :email, :string
    field :encrypted_password, :string

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:name, :email, :encrypted_password])
    |> validate_required([:name, :email, :encrypted_password])
  end
end
