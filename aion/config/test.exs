use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :aion, Aion.Endpoint,
  http: [port: 4001],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

# Configure your database
config :aion, Aion.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "root",
  password: "password",
  database: "aion",
  hostname: "db",
  pool: Ecto.Adapters.SQL.Sandbox
