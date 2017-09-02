import psycopg2
from src.config import dbname, user, password, host


def connect_to_db():
    return psycopg2.connect("dbname={} user={} password={} host={}".format(dbname, user, password, host))
