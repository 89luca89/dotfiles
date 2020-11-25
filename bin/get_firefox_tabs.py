#! /usr/bin/env python3
"""
List all Firefox tabs with title and URL

Supported input: json or jsonlz4 recovery files
Default output: title (URL)
Output format can be specified as argument

pip3 install lz4
"""

import json
import os
import pathlib
import sys

import lz4.block

if os.name == 'nt':
    path = pathlib.Path(os.environ['APPDATA']
                       ).joinpath('Mozilla\\Firefox\\Profiles')
else:
    path = pathlib.Path.home().joinpath('.mozilla/firefox')
files = path.glob('*default*/sessionstore-backups/recovery.js*')

try:
    template = sys.argv[1]
except IndexError:
    template = '%s'

for f in files:
    b = f.read_bytes()
    if b[:8] == b'mozLz40\0':
        b = lz4.block.decompress(b[8:])
    j = json.loads(b)
    for w in j['windows']:
        for t in w['tabs']:
            i = t['index'] - 1
            print(template % (t['entries'][i]['url']))
