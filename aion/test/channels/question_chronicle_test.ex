defmodule Aion.QuestionChronicleTest do
  use ExUnit.Case, async: true

  alias Aion.QuestionChronicle
  @current_time 12345
  @room_id 1

  setup do
    QuestionChronicle.update_last_change(@room_id, fn -> @current_time end)
    assert QuestionChronicle.list_entries == %{@room_id => @current_time}
    :ok
  end

  test "should_change is false when the time hasn't passed yet" do
    time_called = @current_time + QuestionChronicle.question_timeout_micro - 1000
    assert not QuestionChronicle.should_change?(@room_id, fn -> time_called end)
  end

  test "should_change is false when the time has passed" do
    time_called = @current_time + QuestionChronicle.question_timeout_micro
    assert QuestionChronicle.should_change?(@room_id, fn -> time_called end)
  end

end
