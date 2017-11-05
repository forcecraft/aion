defmodule Aion.MonitorTest do
  use Aion.ModelCase
  alias Aion.RoomChannel.{Monitor, QuestionSet}
  alias Aion.Question

  @room_id "1"
  @invalid_room_id "0"
  @question1 %Question{content: "Where dem boyz at?"}
  @question2 %Question{content: "Is this attack on titan?"}

  @questions %QuestionSet{
    questions: [@question1, @question2]
  }

  setup do
    Monitor.create(@room_id, questions: @questions)
    :ok
  end

  test "create new room" do
    assert Monitor.exists?(@room_id)
  end

  test "room does not exist" do
    assert not Monitor.exists?(@invalid_room_id)
  end

  test "room already exists" do
    assert Monitor.create(@room_id) == {:error, :room_already_exists}
  end

end
