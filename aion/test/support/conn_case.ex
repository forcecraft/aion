defmodule Aion.ConnCase do
  @moduledoc """
  This module defines the test case to be used by
  tests that require setting up a connection.

  Such tests rely on `Phoenix.ConnTest` and also
  import other functionality to make it easier
  to build and query models.

  Finally, if the test case interacts with the database,
  it cannot be async. For this reason, every test runs
  inside a transaction which is reset at the beginning
  of the test unless the test case is marked as async.
  """
  use ExUnit.CaseTemplate

  using do
    quote do
      # Import conveniences for testing with connections
      use Phoenix.ConnTest

      alias Aion.Repo
      import Ecto
      import Ecto.Changeset
      import Ecto.Query

      import Aion.Router.Helpers
      import Guardian
      import Aion.User
      # The default endpoint for testing
      @endpoint Aion.Endpoint
    end
  end

  setup tags do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(Aion.Repo)

    unless tags[:async] do
      Ecto.Adapters.SQL.Sandbox.mode(Aion.Repo, {:shared, self()})
    end

    user = %Aion.User{email: "test@example.com", name: "something", password: "2131231", id: 1}
    {:ok, jwt, _} = Guardian.encode_and_sign(user)
    conn =
      Phoenix.ConnTest.build_conn()
      |> Plug.Conn.put_req_header("authorization", "Bearer #{jwt}")
      |> Plug.Conn.put_req_header("accept", "application/json")
    {:ok, conn: conn}
  end
end
