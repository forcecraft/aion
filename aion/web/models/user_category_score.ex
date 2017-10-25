defmodule Aion.UserCategoryScore do
  @moduledoc """
    Join table between User and Category
  """
  use Aion.Web, :model

  schema "user_category_scores" do
    field :score, :integer
    belongs_to :user, Aion.User
    belongs_to :category, Aion.Category

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:score])
    |> validate_required([])
    |> validate_number(:score, greater_than_or_equal_to: 0)
  end
end
