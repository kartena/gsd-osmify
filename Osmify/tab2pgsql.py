#!/usr/bin/python

"""
This is mostly a Python wrapper for the ogr2ogr with the PGDump driver.

You can probably turn this into a general ogr2ogr importer with minor adjustments, not
much TAB specific in here.
"""

import subprocess
import util
import os.path
from importer_modes import *

def tab_to_pgsql(config, conn, tab_path, table, mode, srid=-1, log_file=None, batch_size=1000):
    # ogr2ogr --config GEOMETRY_NAME the_geom
    #         --config PG_USE_COPY YES
    #         --config PGCLIENTENCODING LATIN1
    #         -lco DROP_TABLE=NO
    #         -lco GEOMETRY_NAME=the_geom
    #         -lco SRID=3006
    #         -lco CREATE_TABLE=OFF
    #         -f PGDump ~/Documents/geo-data/af_0114.sql af_0114.tab

    args = [
        config.ogr2ogr,
        '--config', 'GEOMETRY_NAME', 'the_geom',
#        '--config', 'PG_USE_COPY', 'YES',
        '--config', 'PGCLIENTENCODING', 'LATIN1',
        '-lco', 'SRID=%d' % srid,
        '-lco', 'DROP_TABLE=NO',
        '-f', 'PGDump',
    ]

    ogr_table_name = os.path.splitext(os.path.split(tab_path)[1])[0]

    if not (IMPORT_MODE_CREATE & mode):
        args.extend(['-lco', 'CREATE_TABLE=NO'])

    args.extend([
        '/vsistdout/',
        tab_path
        ])

    if not (IMPORT_MODE_DATA & mode):
        filter_fn = lambda c: not 'INSERT' in c
    else:
        filter_fn = lambda c: True

    p = subprocess.Popen(args, stdout=subprocess.PIPE, stderr=log_file)

    cursor = conn.cursor()
    try:
        with p.stdout as stdout:
            for commands in util.groupsgen(util.read_until(stdout, ';\n'), batch_size):
                command = ''.join(filter(filter_fn, commands)).strip()
                if len(command) > 0:
                    command = command.decode('iso-8859-1').replace(ogr_table_name, table)
                    cursor.execute(command.encode('utf-8'))
    except:
        conn.rollback()
        raise
    finally:
        cursor.close()

def vacuum_analyze(conn, table):
    isolation_level = conn.isolation_level
    conn.set_isolation_level(0)
    cursor = conn.cursor()
    try:
        cursor.execute('vacuum analyze %s;' % table)
    finally:
        cursor.close()
        conn.set_isolation_level(isolation_level)

if __name__ == '__main__':
    import config
    import psycopg2
    import os.path
    from sys import argv

    conn = psycopg2.connect("host=%s dbname=%s user=%s password=%s" % \
        (config.db['host'], config.db['name'], config.db['user'], config.db['password']))

    for shape_file in argv[1:len(argv)]:
        table = os.path.splitext(os.path.split(shape_file)[1])[0]
        shape_to_pgsql(conn, shape_file, table, IMPORT_MODE_CREATE + IMPORT_MODE_DATA + IMPORT_MODE_SPATIAL_INDEX)
        vacuum_analyze(conn, table)
