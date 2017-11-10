defmodule Aion.User do
  @moduledoc """
  User model, necessary for authentication.
  """
  @type t :: %__MODULE__{name: String.t, email: String.t, password: String.t, encrypted_password: String.t}
  use Aion.Web, :model
  alias Comeonin.Bcrypt
  alias Aion.{Repo, Category, UserCategoryScore}

  schema "users" do
    field :name, :string
    field :email, :string
    field :password, :string, virtual: true
    field :encrypted_password, :string
    many_to_many :categories, Category,
      join_through: UserCategoryScore,
      on_delete: :delete_all

    timestamps()
  end

  def score(user_id, category_id, amount) do
    user_category_score = get_user_category_score(user_id, category_id)
    changeset = change(user_category_score, score: user_category_score.score + amount)
    Repo.insert_or_update(changeset)
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

  defp get_user_category_score(user_id, category_id) do
    Repo.get_by(UserCategoryScore, user_id: user_id, category_id: category_id)
    || %UserCategoryScore{user_id: user_id, category_id: category_id, score: 0}
  end
end
