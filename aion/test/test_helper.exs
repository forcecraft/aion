ExUnit.start

Ecto.Adapters.SQL.Sandbox.mode(Aion.Repo, :manual)

defmodule Aion.TestHelpers do
  import Guardian
  alias Aion.User
  use Aion.ConnCase

  def setup do
    user = %User{email: "test@example.com", name: "something", password: "2131231", id: 1}
    {:ok, jwt, _} = Guardian.encode_and_sign(user)
    conn =
      build_conn()
      |> put_req_header("authorization", "Bearer #{jwt}")
      |> put_req_header("accept", "application/json")
    {:ok, %{conn: conn}}
  end
end
