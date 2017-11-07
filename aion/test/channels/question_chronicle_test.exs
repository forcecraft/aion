defmodule Aion.QuestionChronicleTest do
  use ExUnit.Case, async: false

  alias Aion.QuestionChronicle
  @current_time 12345
  @room_id 1

  setup do
    QuestionChronicle.initialize_room_state(@room_id, fn -> @current_time end)

    on_exit(fn -> QuestionChronicle.remove_room_state(@room_id) end)
  end

  test "should_change? equals false when the time has not exceeded timeout" do
    time_called = @current_time + QuestionChronicle.question_timeout_micro() - 1000
    assert not QuestionChronicle.should_change?(@room_id, fn -> time_called end)
  end

  test "should_change? equals true when the time has exceeded the timeout" do
    time_called = @current_time + QuestionChronicle.question_timeout_micro()
    assert QuestionChronicle.should_change?(@room_id, fn -> time_called end)
  end

  test "state should initialize with :question" do
    assert QuestionChronicle.list_entries() == %{@room_id => {@current_time, :question}}
  end

  test "state should switch from :question to :break when change_room_state is called" do
    %{@room_id => {_, :question}} = QuestionChronicle.list_entries()

    after_timeout = @current_time + QuestionChronicle.question_timeout_micro()
    QuestionChronicle.change_room_state(@room_id, fn -> after_timeout end)

    %{@room_id => {_, :break}} = QuestionChronicle.list_entries()
  end

  test "state should switch back to :question from break" do
    question_timeout = QuestionChronicle.question_timeout_micro()
    break_timeout = QuestionChronicle.question_break_timeout_micro()

    QuestionChronicle.change_room_state(@room_id, fn -> @current_time + question_timeout end)

    QuestionChronicle.change_room_state(@room_id, fn ->
      @current_time + question_timeout + break_timeout
    end)

    %{@room_id => {_, :question}} = QuestionChronicle.list_entries()
  end
end
