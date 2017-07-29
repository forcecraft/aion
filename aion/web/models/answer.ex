defmodule Aion.Answer do
  @moduledoc """
  This model represents one of the possible answers to certain question.
  """
  use Aion.Web, :model
  alias Aion.Repo

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
    |> Repo.preload(:question)
    |> cast(params, [:content])
    |> validate_required([:content])
    |> put_assoc(:question, params["belongs_to"])
  end
end
