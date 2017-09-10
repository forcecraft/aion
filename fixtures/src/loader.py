from tqdm import tqdm
from .queries.answers import insert_answers
from .queries.categories import get_or_insert_category
from .queries.questions import get_or_insert_question


def load_questions(questions, conn):
    for question in tqdm(questions, desc="Loading questions into the database"):
        get_or_insert_category(question['category'], conn)
        get_or_insert_question(question, conn)
        insert_answers(question, conn)
