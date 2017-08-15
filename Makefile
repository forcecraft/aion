###############
# docker part #
###############

docker_build:
	@docker-compose down
	@docker-compose up --build -d
	@docker-compose run aion mix ecto.create
	@docker-compose run aion mix ecto.migrate

docker_start:
	@docker-compose up

docker_stop:
	@docker-compose down

##########################
# local development part #
##########################

development: local_deps local_db local_config start_dev

start_dev:
	cd aion && iex -S mix phoenix.server

local_db:
	cd aion && mix ecto.create && mix ecto.migrate

local_deps:
	cd aion && mix deps.get && npm install && cd web/elm && elm-package install -y

local_config:
	cp aion/config/local_dev.exs aion/config/dev.exs

populate_database:
	cp fixtures/src/local_config.py fixtures/src/config.py
	scripts/populate_database

test:
	cp aion/config/local_test.exs aion/config/test.exs
	cd aion && mix test

lint:
	cd aion && mix credo --strict

##########
# common #
##########

install-hooks:
	cp scripts/hooks/* .git/hooks/

clean:
	rm -rf aion/deps
	rm -rf aion/web/elm/elm-stuff
	rm -rf aion/node_modules

