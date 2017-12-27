use Mix.Config

config :aion, Aion.Endpoint,
  http: [port: 8888],
  url: [host: "aion.mrapacz.pl", port: 8888],
  cache_static_manifest: "priv/static/manifest.json"

config :phoenix, :serve_endpoints, true

# Do not print debug messages in production
config :logger, level: :info
