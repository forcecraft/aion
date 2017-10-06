import os, re

from src.codingfix import fix_coding


def parse_file(path):
    question_pattern = r'P\n' \
                       '%(?P<category>.*?)%\n' \
                       '(\$(?P<image>([^\$]|\n)*?)\$\n)?' \
                       '@(?P<question>([^@]|\n)*?)@\n' \
                       '@(?P<answers>([^@]|\n)*?)@\s*?'

    questions = list()
    with open(path, 'r') as f:
        matches = re.finditer(re.compile(question_pattern), f.read())
        for match in matches:
            group_names = ('category', 'question', 'answers', 'image')
            question = {group_name: match.group(group_name) for group_name in group_names if match.group(group_name)}
            question = fix_coding(question)
            questions.append(question)
            assert 'answers' in question and 'category' in question and 'question' in question
    return questions


def explore_directory(path):
    def gather_questions():
        for elem in os.listdir(path):
            elem_path = os.path.join(path, elem)
            if os.path.isfile(elem_path):
                yield parse_file(elem_path)

    questions = [question for questions in list(gather_questions()) for question in questions]
    return questions

def get_questions(path):
    if os.path.isdir(path):
        results = explore_directory(path)
    elif os.path.isfile(path):
        results = parse_file(path)
    else:
        raise FileNotFoundError("The specified path doesn't lead to any directory or file")
    return results
