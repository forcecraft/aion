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
