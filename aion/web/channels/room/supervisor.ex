defmodule Aion.Channels.Room.Supervisor do
  @moduledoc """
  This module is responsible for supervising game rooms
  """
  use Supervisor

  def start_link do
    Supervisor.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  def init(:ok) do
    children = [
      supervisor(Aion.Channels.Room.Presence, []),
      worker(Aion.Channels.Room.QuestionChronicle, [], [])
    ]

    supervise(children, strategy: :one_for_one)
  end
end
