defmodule Aion.RoomCategoryTest do
  use Aion.ModelCase

  alias Aion.RoomCategory

  @valid_attrs %{}

  test "changeset with valid attributes" do
    changeset = RoomCategory.changeset(%RoomCategory{}, @valid_attrs)
    assert changeset.valid?
  end
end
