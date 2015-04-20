#!/usr/bin/python

"""
This is mostly a Python wrapper for the shp2pgsql command line utility.
"""

import subprocess
import util
from importer_modes import *

def shape_to_pgsql(config, conn, shape_path, table, mode, srid=-1, log_file=None, batch_size=1000):
    modeflags = {
        str(IMPORT_MODE_CREATE): "c",
        str(IMPORT_MODE_APPEND): "a",
        str(IMPORT_MODE_STRUCTURE): "p",
        str(IMPORT_MODE_DATA): "",
        str(IMPORT_MODE_SPATIAL_INDEX): ""
    }

    args = [
        config.shp2pgsql,
        "-%s" % ''.join([modeflags[f] for f in modeflags.keys() if int(f) & mode]),
        "-W", "latin1",
        "-s", str(srid),
        shape_path,
        table]
    p = subprocess.Popen(args, stdout=subprocess.PIPE, stderr=log_file)

    cursor = conn.cursor()
    try:
        with p.stdout as stdout:
            for commands in util.groupsgen(util.read_until(stdout, ';'), batch_size):
                command = ''.join(commands).strip()
                if len(command) > 0:
                    cursor.execute(command)
        conn.commit()
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
