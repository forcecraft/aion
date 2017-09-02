def get_room_id(room_name, conn):
    with conn.cursor() as cur:
        cur.execute("""SELECT id FROM rooms WHERE name = '{}'""".format(room_name))
        room_id = cur.fetchone()

    return room_id[0] if room_id is not None else None


def get_or_insert_room(room_name, room_description, conn):
    with conn.cursor() as cur:
        if get_room_id(room_name, conn) is None:
            cur.execute(
                """INSERT INTO rooms (name, description, inserted_at, updated_at)
                   VALUES ('{}', '{}', now(), now());""".format(room_name, room_description)
            )
        conn.commit()

    return get_room_id(room_name, conn)
