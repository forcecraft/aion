defmodule Aion.QuestionChronicleTest do
  use ExUnit.Case, async: false

  alias Aion.QuestionChronicle
  @current_time 12345
  @room_id 1

  test "should_change is false when the time hasn't passed yet" do
    assert QuestionChronicle.list_entries == %{}
    QuestionChronicle.update_last_change(@room_id, fn -> @current_time end)

    assert QuestionChronicle.list_entries == %{@room_id => {@current_time, :question}}

    time_called = @current_time + QuestionChronicle.question_timeout_micro - 1000
    assert not QuestionChronicle.should_change?(@room_id, fn -> time_called end)

    time_called = @current_time + QuestionChronicle.question_timeout_micro
    assert QuestionChronicle.should_change?(@room_id, fn -> time_called end)
  end
end
