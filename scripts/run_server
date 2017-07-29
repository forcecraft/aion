sleep 2
cp config/docker_dev.exs config/dev.exs
cp fixtures/src/docker_config.py fixtures/src/config.py
mix deps.get
mix ecto.migrate
mix phoenix.server
