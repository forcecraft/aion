defmodule Aion.Endpoint do
  use Phoenix.Endpoint, otp_app: :aion

  socket "/socket", Aion.UserSocket

  plug Plug.Static,
    at: "/", from: :aion, gzip: false,
    only: ~w(css fonts images svg js favicon.ico robots.txt)

  if code_reloading? do
    socket "/phoenix/live_reload/socket", Phoenix.LiveReloader.Socket
    plug Phoenix.LiveReloader
    plug Phoenix.CodeReloader
  end

  plug Plug.RequestId
  plug Plug.Logger

  plug Plug.Parsers,
    parsers: [:urlencoded, :multipart, :json],
    pass: ["*/*"],
    json_decoder: Poison

  plug Plug.MethodOverride
  plug Plug.Head

  plug Plug.Session,
    store: :cookie,
    key: "_aion_key",
    signing_salt: "TmQ7OBY/"

  plug Aion.Router
end
