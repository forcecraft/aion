use Mix.Config

config :aion, Aion.Endpoint,
  https: [
    port: 4000,
    otp_app: :aion,
    keyfile: "priv/keys/localhost.key",
    certfile: "priv/keys/localhost.cert"
  ],
  debug_errors: true,
  code_reloader: true,
  check_origin: false,
  watchers: [
    node: ["node_modules/brunch/bin/brunch", "watch", "--stdin", cd: Path.expand("../", __DIR__)]
  ]

config :aion, Aion.Endpoint,
  live_reload: [
    patterns: [
      ~r{priv/static/.*(js|css|png|jpeg|jpg|gif|svg)$},
      ~r{priv/gettext/.*(po)$},
      ~r{web/views/.*(ex)$},
      ~r{web/templates/.*(eex)$}
    ]
  ]

config :phoenix, :stacktrace_depth, 20
