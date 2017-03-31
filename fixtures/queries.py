def get_subject_id(subject, conn):
    cur = conn.cursor()
    cur.execute("""SELECT id FROM subjects WHERE name = '{}'""".format(subject))
    return cur.fetchone()


def get_or_insert_subject(subject, conn):
    cur = conn.cursor()
    if get_subject_id(subject, conn) is None:
        cur.execute(
            """INSERT INTO subjects (name, inserted_at, updated_at) VALUES ('{}', now(), now());""".format(subject)
        )
    conn.commit()
    cur.close()
    return get_subject_id(subject, conn)
