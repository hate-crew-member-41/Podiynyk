from os import listdir
import re

import firebase_admin as firebase
from firebase_admin import credentials, firestore


PATH = 'C:/Users/hp/Desktop/Programming/projects/Podiynyk/firebase'

# ---------------------------------------------------------------------------------------------- department abbreviating

DEPARTMENT_NAMING_PATTERN = re.compile(r' ІМ\. [^"]+')
DEPARTMENT_QUOTED_PATTERN = re.compile(r'".+"')


def abbreviated_department(department: str) -> str:
    department = department.upper().replace('-', ' ').replace('ІМЕНІ', 'ІМ.')

    namings = re.findall(DEPARTMENT_NAMING_PATTERN, department)
    for naming in namings:
        department = department.replace(naming, '')

    quotes = re.findall(DEPARTMENT_QUOTED_PATTERN, department)

    if not quotes:
        return abbreviated(department)

    nodes = [0] if department.index(quotes[0]) != 0 else []
    for quote in quotes:
        start = department.index(quote)
        nodes.extend((start, start + len(quote) + 1))
    if (end_node := len(department) + 1) not in nodes:
        nodes.append(end_node)
    
    parts: list[str] = []
    for ni in range(len(nodes) - 1):  # ni stands for node index
        start, end = nodes[ni : ni + 2]
        parts.append(department[start : end])
    
    return ' '.join([abbreviated(part) for part in parts])


def abbreviated(string: str) -> str:
    is_quoted = string[0] == '"'
    if is_quoted:
        string = string[1:-1]

    words = string.split()
    abbreviated = words[0].title() if len(words) == 1 else ''.join([
        w[0] for w in words if w not in ('ТА', 'І', 'Й', 'ДО', 'ЗА')
    ])

    return abbreviated if not is_quoted else f'"{abbreviated}"'


def certified_departments(departments: dict[int, str], hei_id: int) -> dict[str, str]:
    abbreviations = [d[1] for d in departments.values()]
    overlapping_abbreviations = {a for a in abbreviations if abbreviations.count(a) != 1}

    for abbreviation in overlapping_abbreviations:
        overlapping_departments = [d for d in departments.items() if d[1][1] == abbreviation]
        replacements = input(
            f"\nConflict in {hei_id}:  {' | '.join([od[1][0] for od in overlapping_departments])}\n"
            "Replacements:  "
        )

        for department, replacement in zip(overlapping_departments, replacements.split()):
            departments[department[0]] = (department[1][0], replacement)

    return {d[0]: d[1][1] for d in departments.items()}


# ---------------------------------------------------------------------------------------------------------- HEI writing

HEI_PATH = f'{PATH}/HEIs'


def write_HEI(id: str) -> None:
    with open(f'{HEI_PATH}/{id}.txt', 'r', encoding='utf8') as hei_file:
        lines = iter(hei_file)

        name = next(lines).removesuffix('\n')
        CLOUD.document('HEIs/index').update({id: name})

        departments = certified_departments({
            str(d_id): (d.removesuffix('\n'), abbreviated_department(d.removesuffix('\n')))
            for d_id, d in enumerate(lines)
        }, id)
        CLOUD.document(f'HEIs/{id}').set({
            'departments': departments
        })

    size = hei_size_bytes(id, name, departments)
    print(f'\n{id} is {size} B ({size/1024:.3} KB)')


def hei_size_bytes(id: str, name: str, departments: dict[str, str]) -> int:
    def string(string: str) -> int:
        return len(string) + 1

    index_size = string(id) + string(name)

    document_id_size = string(f'HEIs/{id}') + 16
    document_fields_size = string('departments') + sum([
        string(d_id) + string(d) for d_id, d in departments.items()
    ])
    document_size = document_id_size + document_fields_size + 32

    return index_size + document_size


# -------------------------------------------------------------------------------------------------------------- actions

CREDENTIALS = credentials.Certificate(PATH + '/firebase_podiynyk_key.json')
firebase.initialize_app(CREDENTIALS)
CLOUD = firestore.client()

# write_HEI('2')

# for hei_id in listdir(HEI_PATH):
#     write_HEI(hei_id[:-4])
