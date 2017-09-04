def get_room_subjects_record(room_id, subject_id, conn):
    with conn.cursor() as cur:
        cur.execute(
            """SELECT id FROM room_subjects WHERE room_id = '{}' and subject_id = '{}'""".format(room_id, subject_id)
        )
        room_to_subject_record = cur.fetchone()

    return room_to_subject_record[0] if room_to_subject_record is not None else None


def get_or_insert_rooms_to_subjects(room_id, subject_id, conn):
    with conn.cursor() as cur:
        if get_room_subjects_record(room_id, subject_id, conn) is None:
            cur.execute(
                """INSERT INTO room_subjects (room_id, subject_id, inserted_at, updated_at)
                   VALUES ('{}', '{}', now(), now());""".format(room_id, subject_id)
            )
        conn.commit()

    return get_room_subjects_record(room_id, subject_id, conn)
