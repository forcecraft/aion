defmodule Aion.AuthTest do
  use Aion.ConnCase
  alias Aion.User

  @user %User{name: "name", email: "email", password: "password", id: 5}

  test "login should set current_user, add user_id to session and set plug_session_info to :renew", %{conn: conn} do
    conn = conn
     |> Plug.Test.init_test_session(foo: "bar")
     |> Aion.Auth.login(@user)

    assert conn.assigns.current_user == @user
    assert conn.private.plug_session["user_id"] == @user.id
    assert conn.private.plug_session_info == :renew
  end

  test "login_by_username_and_pass should return :ok when passwords match", %{conn: conn} do
    conn = Plug.Test.init_test_session(conn, foo: "bar")
    user = User.registration_changeset(%User{}, Map.from_struct(@user))
    Aion.Repo.insert(user)

    login_result = Aion.Auth.login_by_username_and_pass(conn, @user.email, @user.password, repo: Aion.Repo)

    assert tuple_size(login_result) == 2
    assert elem(login_result, 0) == :ok
  end

  test "login_by_username_and_pass should return :unauthorized when passwords do not match", %{conn: conn} do
    conn = Plug.Test.init_test_session(conn, foo: "bar")
    user = User.registration_changeset(%User{}, Map.from_struct(@user))
    Aion.Repo.insert(user)

    login_result = Aion.Auth.login_by_username_and_pass(conn, @user.email, "I do not match!", repo: Aion.Repo)

    assert login_result == {:error, :unauthorized, conn}
  end

  test "login_by_username_and_pass should return :not_found user cannot be identified", %{conn: conn} do
    conn = Plug.Test.init_test_session(conn, foo: "bar")

    login_result = Aion.Auth.login_by_username_and_pass(conn, "Wrong email", "Wrong password", repo: Aion.Repo)

    assert login_result == {:error, :not_found, conn}
  end
end
