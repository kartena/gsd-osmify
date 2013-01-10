import re
from sys import argv

"""
Given a set of SQL scripts, extracts the added GIST indices and
generates "VACUUM ANALYZE" sql statements for these tables.
The statements are output to stdout, and can be piped to psql for example.
"""

gist_pattern = re.compile("""create\sindex\son\s([A-Z0-9a-z\._]+)\susing\sgist""", re.IGNORECASE)

tables = set()
for path in argv[1:len(argv)]:
    with open(path, 'r') as f:
        tables.update(gist_pattern.findall(f.read()))

print "\n".join(['vacuum analyze %s;' % t for t in tables])


