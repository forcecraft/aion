defmodule Aion.Answer do
  use Aion.Web, :model

  schema "answers" do
    field :content, :string
    belongs_to :question, Aion.Question

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:content])
    |> validate_required([:content])
  end
end
