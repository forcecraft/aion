def get_question_id(subject_id, content, image, conn):
    with conn.cursor() as cur:
        query = """SELECT id FROM questions WHERE content = '{}' AND image_name = {} AND subject_id = '{}'""".format(
            content, image, subject_id)
        cur.execute(query)
        question_id = cur.fetchone()

    return question_id


def get_or_insert_question(question, conn):
    subject_id = get_subject_id(question['subject'], conn)
    content = escape_string(question['question'])
    image = question.get('image', None)
    if image is None:
        image = "NULL"
    else:
        image = "'" + escape_string(image) + "'"

    with conn.cursor() as cur:
        if get_question_id(subject_id, content, image, conn) is None:
            query = """INSERT INTO questions (subject_id, content, image_name, inserted_at, updated_at) VALUES ({}, '{}', {}, now(), now());""".format(
                subject_id, content, image)
            cur.execute(query)
            conn.commit()
        else:
            print(question, content, image, subject_id)

    return get_question_id(subject_id, content, image, conn)
