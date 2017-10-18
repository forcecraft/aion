defmodule Aion.User do
  @moduledoc """
  User model, necessary for authentication.
  """
  @type t :: %__MODULE__{name: String.t, email: String.t, password: String.t, encrypted_password: String.t}
  use Aion.Web, :model
  alias Comeonin.Bcrypt

  schema "users" do
    field :name, :string
    field :email, :string
    field :password, :string, virtual: true
    field :encrypted_password, :string

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:name, :email, :password])
    |> validate_required([:name, :email, :password])
    |> validate_length(:email, min: 3, max: 30)
    |> validate_length(:name, min: 3, max: 30)
  end

  def registration_changeset(model, params) do
    model
    |> changeset(params)
    |> cast(params, [:password])
    |> validate_length(:password, min: 6, max: 30)
    |> put_pass_hash()
  end

  defp put_pass_hash(changeset) do
    case changeset do
      %Ecto.Changeset{valid?: true, changes: %{password: pass}} ->
          put_change(changeset, :encrypted_password, Bcrypt.hashpwsalt(pass))
      _ ->
          changeset
    end
  end
end
