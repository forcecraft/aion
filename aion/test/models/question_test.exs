defmodule Aion.QuestionTest do
  use Aion.ModelCase

  alias Aion.{Question, RoomCategory, Room, Category}

  @valid_attrs %{content: "some content", image_name: "some content"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Question.changeset(%Question{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Question.changeset(%Question{}, @invalid_attrs)
    refute changeset.valid?
  end

  test "get_questions_by_room_id" do
    room1 = Repo.insert! %Room{}
    room2 = Repo.insert! %Room{}

    question_1 = Repo.insert! %Question{category: (Repo.insert! %Category{})}
    question_2 = Repo.insert! %Question{category: (Repo.insert! %Category{})}
    question_3 = Repo.insert! %Question{category: (Repo.insert! %Category{})}

    room_category1 = Repo.insert! %RoomCategory{room_id: room1.id, category_id: question_1.category_id}
    room_category2 = Repo.insert! %RoomCategory{room_id: room1.id, category_id: question_2.category_id}
    room_category2 = Repo.insert! %RoomCategory{room_id: room2.id, category_id: question_3.category_id}

    result = Question.get_questions_by_room_id(room1.id)
    assert length(result) == 2
  end

  def get_question(question_id) do
    Repo.get(Question, question_id)
  end

  def get_random_question(category_id) do
    query = from q in Question, where: q.category_id == ^category_id
    question =
      query
      |> Repo.all()
      |> Enum.random()
  end

end
