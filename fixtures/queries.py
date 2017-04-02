def escape_string(s):
    if s is None:
        return s

    replacements = {
        "'": "''",
        '"': '""',
    }
    for old, new in replacements.items():
        s = s.replace(old, new)
    return s


def get_subject_id(subject, conn):
    with conn.cursor() as cur:
        cur.execute("""SELECT id FROM subjects WHERE name = '{}'""".format(subject))
        subject_id = cur.fetchone()

    return subject_id[0] if subject_id is not None else None


def get_or_insert_subject(subject, conn):
    with conn.cursor() as cur:
        if get_subject_id(subject, conn) is None:
            cur.execute(
                """INSERT INTO subjects (name, inserted_at, updated_at) VALUES ('{}', now(), now());""".format(subject)
            )
        conn.commit()

    return get_subject_id(subject, conn)


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
            print(content)
            query = """INSERT INTO questions (subject_id, content, image_name, inserted_at, updated_at) VALUES ({}, '{}', {}, now(), now());""".format(
                subject_id, content, image)
            cur.execute(query)
        conn.commit()
        cur.close()
    return get_question_id(subject_id, content, image, conn)
