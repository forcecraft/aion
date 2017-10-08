import argparse
from src.loader import load_questions
from src.questionparser import get_questions
from src.populate_rooms import populate_one_category_rooms, populate_all_categories_rooms
from src.connect_to_db import connect_to_db


if __name__ == '__main__':
    parser = argparse.ArgumentParser(description='Dump questions in postgresql database.')
    parser.add_argument('-path', type=str, nargs='*',
                        help="Provide path to file/folder containing questions in a proper format")
    args = parser.parse_args()
    paths = args.path
    conn = connect_to_db()

    if paths is None:
        paths = ['example/']

    for path in paths:
        questions = get_questions(path)

    load_questions(questions, conn)
    # populate_one_category_rooms(conn)
    # populate_all_categories_rooms(conn)
