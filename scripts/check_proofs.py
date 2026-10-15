"""Reject proof holes and declarations of unproved facts in project sources."""
from pathlib import Path
import re
import sys

violations = []
root = Path(__file__).resolve().parents[1]
for path in sorted(root.rglob('*.lean')):
    if '.lake' in path.parts:
        continue
    for number, line in enumerate(path.read_text().splitlines(), 1):
        if re.search(r'\b(sorry|admit|axiom)\b', line):
            violations.append(f'{path}:{number}: forbidden proof placeholder')
if violations:
    print('\n'.join(violations), file=sys.stderr)
    sys.exit(1)
print('Project sources contain no proof placeholders.')
