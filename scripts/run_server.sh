sleep 4
mix deps.get
mix ecto.migrate
mix phoenix.server
