use Mix.Config

config :aion, Aion.Endpoint,
  http: [port: 80],
  url: [host: "aion.mrapacz.pl", port: 80],
  cache_static_manifest: "priv/static/manifest.json"

config :aion, Aion.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "postgres",
  password: "postgres",
  database: "aion",
  hostname: "localhost"

config :phoenix, :serve_endpoints, true

# Do not print debug messages in production
config :logger, level: :info
