import argparse
from src.loader import load_questions
from src.questionparser import get_questions

if __name__ == '__main__':
    parser = argparse.ArgumentParser(description='Dump questions in postgresql database.')
    parser.add_argument('-path', type=str, nargs='*',
                        help="Provide path to file/folder containing questions in a proper format")
    args = parser.parse_args()
    paths = args.path
    if paths is None:
        paths = ['jpks/']

    for path in paths:
        questions = get_questions(path)
    load_questions(questions)
