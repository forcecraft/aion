from src.queries.room_categories import get_or_insert_rooms_to_categories
from src.queries.rooms import get_or_insert_room
from src.queries.categories import get_category_dict


def populate_one_category_rooms(conn):
    category_dict = get_category_dict(conn)

    for category_id, category_name in category_dict.items():
        room_id = get_or_insert_room(category_name, category_name, conn)
        get_or_insert_rooms_to_categories(room_id, category_id, conn)


def populate_all_categories_rooms(conn):
    categories_id_list = list(get_category_dict(conn).keys())
    rooms_number = 5

    for i in range(rooms_number):
        room_id = get_or_insert_room("general {}".format(i), "room with all categories", conn)
        for category_id in categories_id_list:
            get_or_insert_rooms_to_categories(room_id, category_id, conn)
