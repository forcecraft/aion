defmodule Aion.Question do
  use Aion.Web, :model

  schema "questions" do
    field :content, :string
    field :image_name, :string
    belongs_to :subject, Aion.Subject

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:content, :image_name])
    |> validate_required([:content, :image_name])
  end
end
