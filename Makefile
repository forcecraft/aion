build:
	@docker-compose down
	@docker-compose up --build -d
	@docker-compose run aion mix ecto.create
	@docker-compose run aion mix ecto.migrate

start:
	@docker-compose up

clean:
	@docker-compose down
