import psycopg2
from tqdm import tqdm

from config import dbname, user, password
from queries import get_or_insert_subject


def load_questions(questions):
    conn = psycopg2.connect("dbname={} user={} password={}".format(dbname, user, password))

    for question in tqdm(questions, desc="Loading subjects into database"):
        get_or_insert_subject(question['subject'], conn)
