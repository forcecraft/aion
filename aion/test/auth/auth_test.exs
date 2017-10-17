defmodule Aion.AuthTest do
  use Aion.ConnCase
  alias Aion.User

  @user %User{name: "name", email: "email", password: "password", id: 5}

  test "login should set current_user", %{conn: conn} do
    conn = conn
     |> Plug.Test.init_test_session(foo: "bar")
     |> Aion.Auth.login(@user)

    assert conn.assigns.current_user == @user
  end

  test "login should put user_id to session key", %{conn: conn} do
    conn = conn
     |> Plug.Test.init_test_session(foo: "bar")
     |> Aion.Auth.login(@user)

    IO.inspect conn
    assert conn.private.plug_session["user_id"] == @user.id
  end

  test "login should configure session to renew", %{conn: conn} do
    conn = conn
     |> Plug.Test.init_test_session(foo: "bar")
     |> Aion.Auth.login(@user)

    assert conn.private.plug_session_info == :renew
  end
end
