defmodule Aion.PageControllerTest do
  use Aion.ConnCase

  test "GET /", %{conn: conn} do
    conn = get conn, "/"
    main_page_html = "<html><body>You are being <a href=\"/login\">redirected</a>.</body></html>"
    assert conn.resp_body == main_page_html
  end
end
