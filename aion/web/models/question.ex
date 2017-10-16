defmodule Aion.Question do
  @moduledoc """
  This model represents a single question that user may have to answer.
  """
  @type t :: %__MODULE__{content: String.t, image_name: String.t}

  use Aion.Web, :model
  alias Aion.Repo
  alias Aion.{Question, Category, RoomCategory, Room}

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

  @spec get_questions_by_room_id(integer) :: Question.t
  def get_questions_by_room_id(room_id) do
    Repo.all(
      from q in Question,
      join: rc in RoomCategory, on: rc.category_id == q.category_id,
      join: r in Room, on: r.id == rc.room_id,
      where: r.id == ^room_id
    )
  end

  @spec get_random_question(integer) :: Question.t
  def get_random_question(room_id) do
    query = Repo.query("
      SELECT content, image_name, q.id
      FROM questions AS q
      INNER JOIN room_categories AS rc
      ON rc.category_id = q.category_id
      INNER JOIN rooms AS r
      ON r.id = rc.room_id
      WHERE room_id = $1::integer
      ORDER BY RANDOM()
      LIMIT 1;
    ", [String.to_integer(room_id)])

    case query do
      {:ok, %{rows: [[content, image_name, id]]} = result} ->
        %Question{content: content, image_name: image_name, id: id}
      {:error, _} ->
        %Question{}
    end
  end
end
