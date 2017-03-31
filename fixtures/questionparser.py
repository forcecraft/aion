import os, re

from codingfix import fix_coding


def explore_directory(path):
    questions = list()
    for elem in os.listdir(path):
        elem_path = os.path.join(path, elem)
        if os.path.isfile(elem_path):
            questions.extend(parse_file(elem_path))

    return questions


# P\n%(?P<subject>([^%]|\n)*?)%\n(\$(?P<image>([^$]|\n)*?)\$\n)?@(?P<question>([^@]|\n)*?)@\n@(?P<answers>.*)@\n

def parse_file(path):
    question_pattern = r'P\n' \
                       '%(?P<subject>([^%]|\n)*?)%\n' \
                       '(\$(?P<image>([^\$]|\n)*?)\$\n)?' \
                       '@(?P<question>([^@]|\n)*?)@\n' \
                       '@(?P<answers>([^@]|\n)*?)@\n'

    questions = list()
    with open(path, 'r') as f:
        matches = re.finditer(re.compile(question_pattern), f.read())
        for match in matches:
            group_names = ('subject', 'question', 'answers', 'image')
            question = {group_name: match.group(group_name) for group_name in group_names if match.group(group_name)}
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
