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


  #######
  # API #
  #######

  def get_question(question_id) do
    Repo.get(Question, question_id)
  end

  def get_random_question(category_id) do
    query = from q in Question, where: q.subject_id == ^category_id
    question =
      query
      |> Repo.all()
      |> Enum.random()
  end

end
