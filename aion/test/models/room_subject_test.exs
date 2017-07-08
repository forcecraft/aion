defmodule Aion.RoomSubjectTest do
  use Aion.ModelCase

  alias Aion.RoomSubject

  @valid_attrs %{}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = RoomSubject.changeset(%RoomSubject{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = RoomSubject.changeset(%RoomSubject{}, @invalid_attrs)
    refute changeset.valid?
  end
end
