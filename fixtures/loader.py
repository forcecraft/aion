import psycopg2
from tqdm import tqdm

from config import dbname, user, password
from queries import get_or_insert_subject, get_or_insert_question


def load_questions(questions):
    conn = psycopg2.connect("dbname={} user={} password={}".format(dbname, user, password))

    # load subjects
    for question in tqdm(questions, desc="Loading subjects into database"):
        get_or_insert_subject(question['subject'], conn)
        get_or_insert_question(question, conn)

        # # load questions
        # for question in tqdm(questions, desc="Loading subjects into database"):
        #     get_or_insert_question(question['subject'], conn)
