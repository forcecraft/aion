defmodule Aion.Question do
  @moduledoc """
  This model represents a single question that user may have to answer.
  """
  @type t :: %__MODULE__{content: String.t, image_name: String.t}

  use Aion.Web, :model
  alias Aion.Repo
  alias Aion.{Question, Subject}

  schema "questions" do
    field :content, :string
    field :image_name, :string
    belongs_to :subject, Subject

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

  @spec get_question(integer) :: Question.t
  def get_question(question_id) do
    Repo.get(Question, question_id)
  end

  @spec get_random_question(integer) :: Question.t
  def get_random_question(category_id) do
    query = from q in Question, where: q.subject_id == ^category_id
    query
    |> Repo.all()
    |> Enum.random()
  end
end
