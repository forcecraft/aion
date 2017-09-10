def get_room_categories_record(room_id, category_id, conn):
    with conn.cursor() as cur:
        cur.execute(
            """SELECT id FROM room_categories WHERE room_id = '{}' and category_id = '{}'""".format(room_id, category_id)
        )
        room_to_category_record = cur.fetchone()

    return room_to_category_record[0] if room_to_category_record is not None else None


def get_or_insert_rooms_to_categories(room_id, category_id, conn):
    with conn.cursor() as cur:
        if get_room_categories_record(room_id, category_id, conn) is None:
            cur.execute(
                """INSERT INTO room_categories (room_id, category_id, inserted_at, updated_at)
                   VALUES ('{}', '{}', now(), now());""".format(room_id, category_id)
            )
        conn.commit()

    return get_room_categories_record(room_id, category_id, conn)
