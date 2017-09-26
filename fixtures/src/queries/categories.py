def get_category_id(category, conn):
    with conn.cursor() as cur:
        cur.execute("""SELECT id FROM categories WHERE name = '{}'""".format(category))
        category_id = cur.fetchone()

    return category_id[0] if category_id is not None else None


def get_or_insert_category(category, conn):
    with conn.cursor() as cur:
        if get_category_id(category, conn) is None:
            cur.execute(
                """INSERT INTO categories (name, inserted_at, updated_at) VALUES ('{}', now(), now());""".format(category)
            )
        conn.commit()

    return get_category_id(category, conn)


def get_category_dict(conn):
    category_dict = {}
    with conn.cursor() as cur:
        cur.execute("""SELECT * FROM categories""")
        for record in cur:
            category_dict[record[0]] = record[1]  # mapping ids to category names

    return category_dict
