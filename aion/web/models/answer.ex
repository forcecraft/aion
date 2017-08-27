defmodule Aion.Answer do
  @moduledoc """
  This model represents one of the possible answers to certain question.
  """
  @type t :: %__MODULE__{content: String.t}

  use Aion.Web, :model
  alias Aion.{Repo, Question, Answer}
  alias Simetric.Jaro.Winkler, as: JaroWinkler

  schema "answers" do
    field :content, :string
    belongs_to :question, Question

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

  #######
  # API #
  #######

  @spec get_answers(integer) :: list(__MODULE__.t)
  def get_answers(question_id) do
    Repo.all(from a in Answer, where: a.question_id == ^question_id)
  end

  @spec compare_answers(String.t, String.t) :: float
  def compare_answers(first, second) do
    JaroWinkler.compare (String.capitalize first), (String.capitalize second)
  end
end
