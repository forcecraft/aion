use Mix.Config

config :aion, Aion.Endpoint,
  http: [port: {:system, "PORT"}],
  url: [scheme: "https", host: "aion-agh.herokuapp.com", port: 443],
  force_ssl: [rewrite_on: [:x_forwarded_proto]],
  cache_static_manifest: "priv/static/manifest.json",
  secret_key_base: Map.fetch!(System.get_env(), "SECRET_KEY_BASE"),
  hostname: "aion-agh.herokuapps.com"

config :aion, Aion.Repo,
  adapter: Ecto.Adapters.Postgres,
  url: System.get_env("DATABASE_URL"),
  pool_size: String.to_integer(System.get_env("POOL_SIZE") || "10"),
  ssl: true

config :phoenix, :serve_endpoints, true

# Do not print debug messages in production
config :logger, level: :info
