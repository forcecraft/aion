from src.queries import escape_string
from src.queries.questions import get_question_id
from src.queries.categories import get_category_id


def get_answer_id(question_id, answer_content, conn):
    with conn.cursor() as cur:
        query = """SELECT id FROM answers WHERE question_id = {} AND content = '{}'""".format(question_id,
                                                                                              answer_content)
        cur.execute(query)
        answer_id = cur.fetchone()

    return answer_id


def get_or_insert_answer(question, answer, conn):
    category = escape_string(question['category'])
    question_content = escape_string(question['question'])
    image = "'" + escape_string(question['image']) + "'" if 'image' in question else 'NULL'

    category_id = get_category_id(category, conn)
    question_id = get_question_id(category_id, question_content, image, conn)
    answer = escape_string(answer)

    with conn.cursor() as cur:
        if get_answer_id(question_id, answer, conn) is None:
            query = """INSERT INTO answers (content, question_id, inserted_at, updated_at) VALUES ('{}', {}, now(), now())""".format(
                answer, question_id)
            cur.execute(query)
        conn.commit()

    return get_answer_id(question_id, answer, conn)


def insert_answers(question, conn):
    answers = question['answers'].split(';')
    for answer in answers:
        get_or_insert_answer(question, answer, conn)
