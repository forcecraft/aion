from src.queries.room_subjects import get_or_insert_rooms_to_subjects
from src.queries.rooms import get_or_insert_room
from src.queries.subjects import get_subject_dict


def populate_one_subject_rooms(conn):
    subject_dict = get_subject_dict(conn)

    for subject_id, subject_name in subject_dict.items():
        room_id = get_or_insert_room(subject_name, subject_name, conn)
        get_or_insert_rooms_to_subjects(room_id, subject_id, conn)


def populate_all_subjects_rooms(conn):
    subjects_id_list = list(get_subject_dict(conn).keys())
    rooms_number = 5

    for i in range(rooms_number):
        room_id = get_or_insert_room("general {}".format(i), "room with all categories", conn)
        for subject_id in subjects_id_list:
            get_or_insert_rooms_to_subjects(room_id, subject_id, conn)
