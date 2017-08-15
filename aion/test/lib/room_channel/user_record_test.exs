defmodule UserRecordTest do
  use Aion.ModelCase
  alias Aion.RoomChannel.UserRecord

  @user_record %UserRecord{username: "Jack"}

  test "update score" do
    assert @user_record.score == 0
    assert UserRecord.update_score(@user_record) == %UserRecord{@user_record | score: 1}
    assert UserRecord.update_score(@user_record, 10) == %UserRecord{@user_record | score: 10}
  end
end
