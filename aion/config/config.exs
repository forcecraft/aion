# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :aion, ecto_repos: [Aion.Repo]

# Configures the endpoint
config :aion, Aion.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "qILNWNsZ5dyZijpvocG45VG5ElYCLYSfSOAWVEiz+cloUiX177Dla1kbz3ZGrfbX",
  render_errors: [view: Aion.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Aion.PubSub, adapter: Phoenix.PubSub.PG2],
  hostname: "localhost"

config :aion, Aion.Timeout,
  question_timeout: 10,
  question_break_timeout: 5,
  next_question_delay: 1

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Configures Guardian
config :guardian, Guardian,
  allowed_algos: ["HS512"],
  secret_key: System.get_env("SECRET_KEY") || "test",
  issuer: "Aion",
  ttl: {30, :days},
  serializer: Aion.GuardianSerializer

config :cipher,
  keyphrase: System.get_env("CIPHER_KEYPHRASE") || "testiekeyphraseforcipher",
  ivphrase: System.get_env("CIPHER_IVPHRASE") || "testieivphraseforcipher",
  magic_token: System.get_env("CIPHER_MAGIC_TOKEN") || "magictoken"

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
