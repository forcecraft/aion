import psycopg2
from tqdm import tqdm

from config import dbname, user, password
from queries.answers import insert_answers
from queries.subjects import get_or_insert_subject
from queries.questions import get_or_insert_question


def load_questions(questions):
    conn = psycopg2.connect("dbname={} user={} password={}".format(dbname, user, password))

    for question in tqdm(questions, desc="Loading questions into the database"):
        get_or_insert_subject(question['subject'], conn)
        get_or_insert_question(question, conn)
        insert_answers(question, conn)
