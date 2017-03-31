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
                       '@(?P<question>.*)@\n' \
                       '@(?P<answers>.*)@\n'

    questions = list()
    with open(path, 'r') as f:
        matches = re.finditer(question_pattern, f.read())
        for match in matches:
            groups = match.groups()

            question = dict()
            question['subject'], question['question'], question['answers'] = groups[0], groups[1], groups[2]
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
