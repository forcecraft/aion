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
	import Plug.Conn
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

      # The default endpoint for testing
      @endpoint Aion.Endpoint
    end
  end

  setup tags do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(Aion.Repo)

    unless tags[:async] do
      Ecto.Adapters.SQL.Sandbox.mode(Aion.Repo, {:shared, self()})
    end

    {:ok, conn: Phoenix.ConnTest.build_conn()}
  end
  def user do
    user_attrs =%{
      name: "Basil Pupkin",
      email: "basil@mailinator.com",
      encrypted_password: "whatever"
    }
    user = Repo.get_by(Publisher.User, user_attrs)
    if is_nil(user) do
      struct(Publisher.User, user_attrs)
      |> Repo.insert!
    else
      user
    end
  end

  def logged_in(conn) do
    conn
    |> assign(:current_user, user)
  end
end
