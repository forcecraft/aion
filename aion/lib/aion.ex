defmodule Aion do
  @moduledoc """
  Main application module. Define all supervisors and workers here.
  """
  use Application
  alias Aion.{Repo, Endpoint}

  def start(_type, _args) do
    import Supervisor.Spec

    # Define workers and child supervisors to be supervised
    children = [
      supervisor(Repo, []),
      supervisor(Endpoint, []),
      supervisor(Aion.RoomChannel.Supervisor, []),
      supervisor(Aion.Presence, []),
    ]

    opts = [strategy: :one_for_one, name: Aion.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    Endpoint.config_change(changed, removed)
    :ok
  end
end
