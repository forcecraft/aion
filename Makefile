##  ~> GENERAL <~  ##
#####################

elm-package=$(shell pwd)/aion/node_modules/elm/binwrappers/elm-package

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
	cd aion && mix test

lint: ## Run elixir linter
	cd aion && mix credo --strict

reinstall-elm: ## Remove and reinstall elm dependencies
	cd aion/web/elm && rm -rf elm-stuff && $(elm-package) install -y

#######################
## ~> DOCKER PART <~ ##
#######################

docker-build: ## Build docker image
	@docker-compose down
	@docker-compose up --build -d
	@docker-compose run aion mix ecto.create
	@docker-compose run aion mix ecto.migrate

docker-start: ## Run docker container
	@docker-compose up

docker-stop: ## Stop docker container
	@docker-compose down

##################################
## ~> LOCAL DEVELOPMENT PART <~ ##
##################################

development: local-deps local-db start-dev
development: ## Setup and run the whole project

start-dev: ## Start the phoenix server
	cd aion && iex -S mix phoenix.server

local-db: ## Create and migrate db locally
	cd aion && mix ecto.create && mix ecto.migrate

local-deps: ## Download all needed dependencies
	cd aion && mix deps.get && npm install && cd web/elm && $(elm-package) install -y


##################################
## ~> DATABASE SEEDING PART <~  ##
##################################

populate-database: ## Seed database with fixtures prepared in fixtures/jpks/
populate-database:
	cd fixtures && python3 main.py

populate-rooms: ## Create a set of rooms aggregating all the questions present in the database
populate-rooms:
	cd fixtures && python3 main.py --rooms

##################################
##    ~> DEPLOYMENT PART <~     ##
##################################

deploy-stop:
	cd aion && sudo rel/aion/bin/aion stop

deploy-start:
	cd aion && sudo rel/aion/bin/aion start

deploy-restart:
	cd aion && sudo rel/aion/bin/aion restart

deploy: ## Create a release and run the production server
	cd aion && \
	MIX_ENV=prod mix do deps.get, compile && \
	npm install && \
	brunch build --production && \
	MIX_ENV=prod mix phoenix.digest

	# Try to shutdown running server, continue regardless
	@-sudo ./aion/rel/aion/bin/aion stop && \
	([ $$? -eq 0 ] && echo "Successfully stopped running server") || \
	echo "Couldn't shut down the server, apparently it was not running"

	cd aion && MIX_ENV=prod mix release
	sudo ./aion/rel/aion/bin/aion start
