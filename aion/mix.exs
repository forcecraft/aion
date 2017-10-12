defmodule Aion.Mixfile do
  use Mix.Project

  def project do
    [app: :aion,
     version: "0.0.1",
     elixir: "~> 1.4",
     elixirc_paths: elixirc_paths(Mix.env),
     compilers: [:phoenix, :gettext] ++ Mix.compilers,
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     aliases: aliases(),
     deps: deps(),
     dialyzer: [
       ignore_warnings: "dialyzer.ignore_warnings",
     ],
   ]
  end

  def application do
    [mod: {Aion, []},
     applications: [:phoenix, :phoenix_pubsub, :phoenix_html, :cowboy, :logger, :gettext,
                    :phoenix_ecto, :postgrex, :simetric]]
  end

  defp elixirc_paths(:test), do: ["lib", "web", "test/support"]
  defp elixirc_paths(_),     do: ["lib", "web"]

  defp deps do
    [{:credo, "~> 0.8", only: [:dev, :test], runtime: false},
     {:comeonin, "~>2.4"},
     {:cowboy, "~> 1.0"},
     {:dialyxir, "~>0.5", only: [:dev], runtime: false},
     {:gettext, "~> 0.11"},
     {:guardian, "~>0.14.5"},
     {:phoenix, "~> 1.2.1"},
     {:phoenix_ecto, "~> 3.0"},
     {:phoenix_html, "~> 2.6"},
     {:phoenix_live_reload, "~> 1.0", only: :dev},
     {:phoenix_pubsub, "~> 1.0"},
     {:plug, "~>1.3.5", override: true},
     {:postgrex, ">= 0.0.0"},
     {:simetric, "~> 0.1.0"},
     {:exrm, "~> 1.0.8"},]
  end

  defp aliases do
    ["ecto.setup": ["ecto.create", "ecto.migrate", "run priv/repo/seeds.exs"],
     "ecto.reset": ["ecto.drop", "ecto.setup"],
     "test": ["ecto.create --quiet", "ecto.migrate", "test"]]
  end
end
