defmodule Aion do
  @moduledoc """
  Main application module. Define all supervisors and workers here.
  """
  use Application

  alias Aion.{Repo, Endpoint, ChannelMonitor}
  # See http://elixir-lang.org/docs/stable/elixir/Application.html
  # for more information on OTP Applications
  def start(_type, _args) do
    import Supervisor.Spec

    # Define workers and child supervisors to be supervised
    children = [
      # Start the Ecto repository
      supervisor(Repo, []),
      # Start the endpoint when the application starts
      supervisor(Endpoint, []),
      # Start your own worker by calling: Aion.Worker.start_link(arg1, arg2, arg3)
      # worker(Aion.Worker, [arg1, arg2, arg3]),
      worker(ChannelMonitor, [%{}])
    ]

    # See http://elixir-lang.org/docs/stable/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Aion.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    Endpoint.config_change(changed, removed)
    :ok
  end
  
  def trigger_pronto() do
    %Aion.Question{}
    # comment it
    # again
    #
    x = "test"
        |> IO.inspect
  end
end
