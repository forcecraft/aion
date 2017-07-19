sleep 2
cp config/docker_dev.exs config/dev.exs
mix deps.get
mix ecto.migrate
mix phoenix.server
