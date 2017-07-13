use Mix.Config

config :aion, Aion.Endpoint,
  http: [port: 4001],
  server: false

config :logger, level: :warn

config :aion, Aion.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "postgres",
  password: "",
  database: "aion_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox