defmodule Aion.RoomSubjectTest do
  use Aion.ModelCase

  alias Aion.RoomSubject

  @valid_attrs %{}

  test "changeset with valid attributes" do
    changeset = RoomSubject.changeset(%RoomSubject{}, @valid_attrs)
    assert changeset.valid?
  end
end
