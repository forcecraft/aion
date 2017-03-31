# !/usr/bin/env python
# -*- coding: utf-8 -*-


def fix_letters(text):
    fixes = {
        '%s': 'ś',
        '%z': 'ż',
        '%o': 'ó',
        '%l': 'ł',
        '%e': 'ę',
        '%a': 'ą',
        '%x': 'ź',
        '%c': 'ć',
        '%n': 'ń',
        '%S': 'Ś',
        '%Z': 'Ż',
        '%O': 'Ó',
        '%L': 'Ł',
        '%E': 'Ę',
        '%A': 'Ą',
        '%X': 'Ź',
        '%C': 'Ć',
        '%N': 'Ń',
    }
    for old, new in fixes.items():
        text = text.replace(old, new)
    return text


def fix_coding(question):
    for key, value in question.items():
        question[key] = fix_letters(value)

    return question
