sleep 4
mix ecto.migrate
python3 /fixtures/main.py -path /fixtures/jpks/
mix phoenix.server
