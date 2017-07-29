defmodule Aion.Question do
  @moduledoc """
  This model represents a single question that user may have to answer.
  """
  use Aion.Web, :model
  alias Aion.Repo
  alias Aion.Subject

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
      |> Repo.preload(:subject)
      |> cast(params, [:content, :image_name])
      |> validate_required([:content])
      |> put_assoc(:subject, params["belongs_to"])
  end
end
