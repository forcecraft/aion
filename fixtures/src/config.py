import os

dbname = 'aion'
user = 'postgres'
password = 'postgres'
host = os.environ.get('AION_DB_HOSTNAME', 'localhost')
