defmodule Aion.QuestionChronicleTest do
  use ExUnit.Case, async: false

  alias Aion.QuestionChronicle
  @current_time 12345
  @room_id 1

  test "question chronicle" do
    assert QuestionChronicle.list_entries() == %{}

    QuestionChronicle.initialize_room_state(@room_id, fn -> @current_time end)
    assert QuestionChronicle.list_entries() == %{@room_id => {@current_time, :question}}

    time_called = @current_time + QuestionChronicle.question_timeout_micro() - 1000
    assert not QuestionChronicle.should_change?(@room_id, fn -> time_called end)

    time_called = @current_time + QuestionChronicle.question_timeout_micro()
    assert QuestionChronicle.should_change?(@room_id, fn -> time_called end)

    QuestionChronicle.change_room_state(@room_id, fn -> @current_time end)
    assert QuestionChronicle.list_entries() == %{@room_id => {@current_time, :break}}
  end
end
