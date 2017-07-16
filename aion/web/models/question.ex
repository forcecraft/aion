defmodule Aion.Question do
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
    if params["subject"] do
      subject = Repo.get(Subject, params["subject"])

      struct
        |> Map.put(:subject, subject)
        |> cast(params, [:content, :image_name])
        |> validate_required([:content, :subject])
    else
      struct
        |> cast(params, [:content, :image_name])
        |> validate_required([:content])
    end
  end
end
