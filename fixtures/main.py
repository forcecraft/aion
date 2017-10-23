import argparse
from src.loader import load_questions
from src.questionparser import get_questions
from src.populate_rooms import populate_one_category_rooms, populate_all_categories_rooms
from src.connect_to_db import connect_to_db


questions_threshold = 30


def create_rooms(conn):
    populate_one_category_rooms(conn, questions_threshold)
    populate_all_categories_rooms(conn)


def seed_database(conn, paths):
    if paths is None:
        paths = ['example/']

    for path in paths:
        questions = get_questions(path)

    load_questions(questions, conn)


if __name__ == '__main__':
    parser = argparse.ArgumentParser(description='Load questions into postgresql database.')
    parser.add_argument('-path', type=str, nargs='*',
                        help="Provide path to file/folder containing questions in a proper format")
    parser.add_argument('--rooms', action='store_true')
    args = parser.parse_args()

    conn = connect_to_db()

    if args.rooms:
        create_rooms(conn)
    else:
        seed_database(conn, args.path)
