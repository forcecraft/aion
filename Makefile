##  ~> GENERAL <~  ##
#####################

help: ## Print out this message
	@IFS=$$'\n' ; \
	help_lines=(`fgrep -h "##" $(MAKEFILE_LIST) | fgrep -v fgrep | sed -e 's/\\$$//'`); \
	for help_line in $${help_lines[@]}; do \
			IFS=$$'#' ; \
			help_split=($$help_line) ; \
			help_command=`echo $${help_split[0]} | sed -e 's/^ *//' -e 's/ *$$//'` ; \
			help_info=`echo $${help_split[2]} | sed -e 's/^ *//' -e 's/ *$$//'` ; \
			printf "%-30s %s\n" $$help_command $$help_info ; \
	done

install-hooks: ## Install git hooks
	cp scripts/hooks/* .git/hooks/

clean: ## Remove local files
	rm -rf aion/deps
	rm -rf aion/web/elm/elm-stuff
	rm -rf aion/node_modules

test: ## Run tests
	cp aion/config/local_test.exs aion/config/test.exs
	cd aion && mix test

lint: ## Run elixir linter
	cd aion && mix credo --strict

reinstall_elm: ## Remove and reinstall elm dependencies
	cd aion/web/elm && rm -rf elm-stuff && elm-package install -y

#######################
## ~> DOCKER PART <~ ##
#######################

docker_build: ## Build docker image
	@docker-compose down
	@docker-compose up --build -d
	@docker-compose run aion mix ecto.create
	@docker-compose run aion mix ecto.migrate

docker_start: ## Run docker container
	@docker-compose up

docker_stop: ## Stop docker container
	@docker-compose down

##################################
## ~> LOCAL DEVELOPMENT PART <~ ##
##################################

development: local_config local_deps local_db start_dev
development: ## Setup and run the whole project

start_dev: ## Start the phoenix server
	cd aion && iex -S mix phoenix.server

local_db: ## Create and migrate db locally
	cd aion && mix ecto.create && mix ecto.migrate

local_deps: ## Download all needed dependencies
	cd aion && mix deps.get && npm install && cd web/elm && elm-package install -y

local_config: ## Switch config file to
	ln -s aion/config/local_dev.exs aion/config/dev.exs

populate_database: ## Seed database with fixtures prepared in fixtures/jpks/
	ln -f -s fixtures/src/local_config.py fixtures/src/config.py
	scripts/populate_database
