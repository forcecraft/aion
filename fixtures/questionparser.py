import os, re

from codingfix import fix_coding


def explore_directory(path):
    questions = list()
    for elem in os.listdir(path):
        elem_path = os.path.join(path, elem)
        if os.path.isfile(elem_path):
            questions.extend(parse_file(elem_path))

    return questions


def parse_file(path):
    question_pattern = r'P\n' \
                       '%(?P<subject>.*)%\n' \
                       '(\$(?P<image>.*)\$\n)?' \
                       '@(?P<question>.*)@\n' \
                       '@(?P<answers>.*)@\n'

    questions = list()
    with open(path, 'r') as f:
        matches = re.finditer(re.compile(question_pattern), f.read())
        for match in matches:

            group_dict = dict()
            if not match.group('image'):
                group_dict = {
                    'subject': 0,
                    'question': 3,
                    'answers': 4,
                }

            else:
                group_dict = {
                    'subject': 0,
                    'image': 2,
                    'question': 3,
                    'answers': 4,
                }
            question = {group_name: match.groups()[group_id] for group_name, group_id in group_dict.items()}
            question = fix_coding(question)
            questions.append(question)

    return questions


def get_questions(path):
    if os.path.isdir(path):
        results = explore_directory(path)
    elif os.path.isfile(path):
        results = parse_file(path)
    else:
        raise FileNotFoundError("The specified path doesn't lead to any directory or file")
    return results
