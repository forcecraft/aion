###############
# docker part #
###############

docker_build_base:
	docker build -t aion:latest -f Dockerfile.base .

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
	cd aion && mix phoenix.server

local_db:
	cd aion && mix ecto.create && mix ecto.migrate

local_deps:
	cd aion && mix deps.get && npm install

local_config:
	cp aion/config/local_dev.exs aion/config/dev.exs

populate_database:
	scripts/populate_database

##########
# common #
##########

install-hooks:
	cp scripts/hooks/* .git/hooks/

clean:
	rm -rf aion/deps
	rm -rf aion/web/elm/elm-stuff
	rm -rf aion/node_modules

