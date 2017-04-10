def escape_string(s):
    if s is None:
        return s

    replacements = {
        "'": "''",
        '"': '""',
    }
    for old, new in replacements.items():
        s = s.replace(old, new)
    return s
