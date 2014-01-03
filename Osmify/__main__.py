import os
import config
import psycopg2
from sys import argv
from Godwit import MigratePostgres

from Osmify import Oversiktskartan, Terrangkartan, Vagkartan, Tatortskartan
from Osmify.shp2pgsql import shape_to_pgsql, vacuum_analyze, \
    IMPORT_MODE_CREATE, IMPORT_MODE_APPEND, \
    IMPORT_MODE_STRUCTURE, IMPORT_MODE_DATA, IMPORT_MODE_SPATIAL_INDEX

if config.log_file is not None:
    log_file = open(config.log_file, 'w')
else:
    log_file = open(os.devnull, 'w')

conn = psycopg2.connect("host=%s dbname=%s user=%s password=%s" % \
    (config.db['host'], config.db['name'], config.db['user'], config.db['password']))

scope = argv[1]
maps = [x for x in ['oversikt', 'terrang', 'vagk', 'tatort'] if scope == 'all' or x == scope]

for m in maps:
    if m == 'oversikt':
        gsd_map = Oversiktskartan(config.gsd['path'])
    elif m == 'terrang':
        gsd_map = Terrangkartan(config.gsd['path'])
    elif m == 'vagk':
        gsd_map = Vagkartan(config.gsd['path'])
    elif m == 'tatort':
        gsd_map = Tatortskartan(config.gsd['path'])

    print "Creating structure for %s" % m

    if 'srid' in config.gsd:
        srid = config.gsd['srid']
    else:
        srid = -1

    proto_files = gsd_map.prototype_files()
    if len(proto_files) == 0:
        print "Warning: no structure prototype files found for %s in %s" % (m, config.gsd['path'])

    for f in proto_files:
        filename = os.path.splitext(os.path.split(f)[1])[0]
        table = '%s_%s' % (m, filename.split('_')[0])
        shape_to_pgsql(config, conn, f, table, \
            IMPORT_MODE_CREATE + IMPORT_MODE_STRUCTURE + IMPORT_MODE_SPATIAL_INDEX, \
            srid, log_file)

    for f in gsd_map.data_files():
        filename = os.path.splitext(os.path.split(f)[1])[0]
        table = '%s_%s' % (m, filename.split('_')[0])
        print "Importing %s to %s" % (f, table)
        shape_to_pgsql(config, conn, f, table, \
            IMPORT_MODE_APPEND + IMPORT_MODE_DATA + IMPORT_MODE_SPATIAL_INDEX, \
            srid,
            log_file)

        cursor = conn.cursor()
        try:
            for col in gsd_map.index_columns():
                cursor.execute('create index on %s (%s);' % (table, col))
            conn.commit()
        except:
            conn.rollback()
        finally:
            cursor.close()

        vacuum_analyze(conn, table)

    MigratePostgres(conn, 'migrations', True).migrate()
