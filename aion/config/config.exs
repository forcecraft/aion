# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :aion,
  ecto_repos: [Aion.Repo]

# Configures the endpoint
config :aion, Aion.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "qILNWNsZ5dyZijpvocG45VG5ElYCLYSfSOAWVEiz+cloUiX177Dla1kbz3ZGrfbX",
  render_errors: [view: Aion.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Aion.PubSub,
           adapter: Phoenix.PubSub.PG2],
  hostname: "localhost"

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"

config :addict,
  secret_key: "2432622431322443424641565a4939756e724773435a6d77774442692e",
  extra_validation: fn ({valid, errors}, user_params) -> {valid, errors} end, # define extra validation here
  user_schema: Aion.User,
  repo: Aion.Repo,
  from_email: "no-reply@example.com", # CHANGE THIS
mail_service: nil
