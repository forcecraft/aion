from src.queries import escape_string
from src.queries.categories import get_category_id


def get_question_id(category_id, content, image, conn):
    with conn.cursor() as cur:
        if image == 'NULL':
            query = """SELECT id FROM questions WHERE content = '{}' AND image_name IS NULL AND category_id = '{}'""".format(
                content, category_id)
        else:
            query = """SELECT id FROM questions WHERE content = '{}' AND image_name = {} AND category_id = '{}'""".format(
                content, image, category_id)
        cur.execute(query)
        question_id = cur.fetchone()
    return question_id[0] if question_id is not None else None


def get_or_insert_question(question, conn):
    category_id = get_category_id(question['category'], conn)
    content = escape_string(question['question'])
    image = question.get('image', None)
    if image is None:
        image = "NULL"
    else:
        image = "'" + escape_string(image) + "'"

    with conn.cursor() as cur:
        if get_question_id(category_id, content, image, conn) is None:
            query = """INSERT INTO questions (category_id, content, image_name, inserted_at, updated_at) VALUES ({}, '{}', {}, now(), now());""".format(
                category_id, content, image)
            cur.execute(query)
            conn.commit()
        else:
            print("Question already in the database: {}".format(question))

    return get_question_id(category_id, content, image, conn)
