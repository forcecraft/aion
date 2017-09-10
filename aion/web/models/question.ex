defmodule Aion.Question do
  @moduledoc """
  This model represents a single question that user may have to answer.
  """
  @type t :: %__MODULE__{content: String.t, image_name: String.t}

  use Aion.Web, :model
  alias Aion.Repo
  alias Aion.{Question, Category}

  schema "questions" do
    field :content, :string
    field :image_name, :string
    belongs_to :category, Category

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
      |> Repo.preload(:category)
      |> cast(params, [:content, :image_name])
      |> validate_required([:content])
      |> put_assoc(:category, params["belongs_to"])
  end

  #######
  # API #
  #######

  @spec get_question(integer) :: Question.t
  def get_question(question_id) do
    Repo.get(Question, question_id)
  end

  @spec get_random_question(integer) :: Question.t
  def get_random_question(room_id) do
    query = Repo.query("
      SELECT content, image_name, q.id FROM questions AS q
      JOIN room_categories AS rc ON rc.category_id = q.category_id
      JOIN rooms AS r ON r.id = rc.room_id
      WHERE room_id = $1::integer
      ORDER BY RANDOM()
      LIMIT 1;
    ", [String.to_integer(room_id)])

    case query do
      {:ok, result} ->
        case result.rows do
          [[content, image_name, id]] ->
            %Question{content: content, image_name: image_name, id: id}
          _ ->
            %Question{}
        end
      {:error, _} ->
        %Question{}
    end
  end
end
