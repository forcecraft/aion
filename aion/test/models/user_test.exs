defmodule Aion.UserTest do
  use Aion.ModelCase

  alias Aion.User

  @valid_attrs %{name: "John Wink", email: "test@example.com", encrypted_password: "test123"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = User.changeset(%User{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = User.changeset(%User{}, @invalid_attrs)
    refute changeset.valid?
  end
end
