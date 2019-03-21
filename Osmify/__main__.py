import os
import os.path
import config
import psycopg2
from sys import argv

from Osmify import Oversiktskartan, Terrangkartan, Vagkartan, Tatortskartan, Fastighetskartan
from Osmify.shp2pgsql import shape_to_pgsql, vacuum_analyze
from importer_modes import IMPORT_MODE_CREATE, IMPORT_MODE_APPEND, \
    IMPORT_MODE_STRUCTURE, IMPORT_MODE_DATA, IMPORT_MODE_SPATIAL_INDEX
from Osmify.tab2pgsql import tab_to_pgsql

from Godwit import MigratePostgres

def import_shape(maps):
    for m in maps:
        if m == 'oversikt':
            gsd_map = Oversiktskartan(config.gsd['path'])
        elif m == 'terrang':
            gsd_map = Terrangkartan(config.gsd['path'])
        elif m == 'vagk':
            gsd_map = Vagkartan(config.gsd['path'])
        elif m == 'tatort':
            gsd_map = Tatortskartan(config.gsd['path'])
        elif m == 'fastighk':
            gsd_map = Fastighetskartan(config.gsd['path'])

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

            import_fn = get_import_fn(f)
            import_fn(config, conn, f, table,
                IMPORT_MODE_CREATE + IMPORT_MODE_STRUCTURE + IMPORT_MODE_SPATIAL_INDEX,
                srid, log_file)

        tables = set()
        for f in gsd_map.data_files():
            filename = os.path.splitext(os.path.split(f)[1])[0]
            table = '%s_%s' % (m, filename.split('_')[0])
            tables.add(table)
            print "Importing %s to %s" % (f, table)

            import_fn = get_import_fn(f)
            import_fn(config, conn, f, table,
                IMPORT_MODE_APPEND + IMPORT_MODE_DATA + IMPORT_MODE_SPATIAL_INDEX,
                srid,
                log_file)

        for table in tables:
            cursor = conn.cursor()
            try:
                for col in gsd_map.index_columns():
                    print "Creating index for %s on %s" % (table, col)
                    cursor.execute('create index on %s (%s);' % (table, col))
                conn.commit()
            except:
                conn.rollback()
            finally:
                cursor.close()

            vacuum_analyze(conn, table)

def get_import_fn(filepath):
    file_type = os.path.splitext(filepath)[1]
    if file_type == '.shp':
        return shape_to_pgsql
    elif file_type == '.tab':
        return tab_to_pgsql
    else:
        raise Exception('Unknown file type %s' % file)

if config.log_file is not None:
    log_file = open(config.log_file, 'w')
else:
    log_file = open(os.devnull, 'w')

conn = psycopg2.connect("host=%s dbname=%s user=%s password=%s" %
    (config.db['host'], config.db['name'], config.db['user'], config.db['password']))

scope = argv[1]
maps = [x for x in ['oversikt', 'terrang', 'vagk', 'tatort', 'fastighk'] if scope == 'all' or x == scope]

migrations_dir = config.migrations_dir \
    if hasattr(config, 'migrations_dir') \
    else 'migrations'
migrate = MigratePostgres(conn, migrations_dir, True)

if not migrate.get_current_version():
    import_shape(maps)

#TODO: version
migrate.migrate()
