defmodule Aion.PageControllerTest do
  use Aion.ConnCase

  test "GET /", %{conn: conn} do
    conn = get conn, "/"
    assert conn.resp_body =~ "Hello Aion!"
  end
end
