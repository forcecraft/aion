import psycopg2
from tqdm import tqdm

from src.config import dbname, user, password, host
from src.queries.answers import insert_answers
from src.queries.subjects import get_or_insert_subject
from src.queries.questions import get_or_insert_question


def load_questions(questions):
    conn = psycopg2.connect("dbname={} user={} password={} host={}".format(dbname, user, password, host))

    for question in tqdm(questions, desc="Loading questions into the database"):
        get_or_insert_subject(question['subject'], conn)
        get_or_insert_question(question, conn)
        insert_answers(question, conn)
