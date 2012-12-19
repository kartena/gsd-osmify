# Imports all GSD shape data to a database.
# NOTE: If the db exists, it is *dropped* before importing any data

DB=lmv
GSD_PATH=/media/local/MapData/lmv-shape
SQL_LOG=/dev/null
ERROR_LOG=gsd_import.log

# Create a clean slate
rm $SQL_LOG
rm $ERROR_LOG
dropdb $DB

createdb -T template_postgis $DB

# Create tables for Terrängkartan before actually inserting to them
echo Creating structure for Terrängkartan
for F in $GSD_PATH/terrang/south/*.shp; do
    TABLE_NAME=terrang_`basename $F .shp | cut -d_ -f1`
    /usr/lib/postgresql/9.1/bin/shp2pgsql -p -W latin1 -I $F $TABLE_NAME 2>>$ERROR_LOG | tee -a $SQL_LOG | psql -d $DB 1>/dev/null 2>>$ERROR_LOG
done

# Actually import Terrängkartan, using text labels from gistext directory
FILES="`find $GSD_PATH/terrang/ -maxdepth 2 -name "*.shp" -not \( -name "tx_*.shp" -or -name "tl_*.shp" \)` `find $GSD_PATH/terrang/ -mindepth 3 \( -name "tx_*.shp" -or -name "tl_*.shp" \)`"
for F in $FILES; do
    TABLE_NAME=terrang_`basename $F .shp | cut -d_ -f1`
    echo Importing $F into $TABLE_NAME
    /usr/lib/postgresql/9.1/bin/shp2pgsql -a -W latin1 $F $TABLE_NAME 2>>$ERROR_LOG | tee -a $SQL_LOG | psql -d $DB 1>/dev/null 2>>$ERROR_LOG
done

# Create tables for Tätortskartan before actually inserting to them
echo Creating structure for Tätortskartan
for F in $GSD_PATH/tatort/0336/*.shp; do
    TABLE_NAME=tatort_`basename $F .shp | cut -d_ -f1`
    /usr/lib/postgresql/9.1/bin/shp2pgsql -p -W latin1 -I $F $TABLE_NAME 2>>$ERROR_LOG | tee -a $SQL_LOG | psql -d $DB 1>/dev/null 2>>$ERROR_LOG
done

# Actually import Tätortskartan
for F in `find $GSD_PATH/tatort/0336/ -name "*.shp"`; do
    TABLE_NAME=tatort_`basename $F .shp | cut -d_ -f1`
    echo Importing $F into $TABLE_NAME
    /usr/lib/postgresql/9.1/bin/shp2pgsql -a -W latin1 $F $TABLE_NAME 2>>$ERROR_LOG | tee -a $SQL_LOG | psql -d $DB 1>/dev/null 2>>$ERROR_LOG
done

# Create tables for Vägkartan before actually inserting to them
echo Creating structure for Vägkartan
for F in $GSD_PATH/vagk/south/*.shp; do
    TABLE_NAME=vagk_`basename $F .shp | cut -d_ -f1`
    /usr/lib/postgresql/9.1/bin/shp2pgsql -p -W latin1 -I $F $TABLE_NAME 2>>$ERROR_LOG | tee -a $SQL_LOG | psql -d $DB 1>/dev/null 2>>$ERROR_LOG
done

# Actually import Vägkartan
FILES="`find $GSD_PATH/vagk/ -maxdepth 2 -name "*.shp" -not \( -name "tx_*.shp" -or -name "tl_*.shp" \)` `find $GSD_PATH/vagk/ -mindepth 3 \( -name "tx_*.shp" -or -name "tl_*.shp" \)`"
for F in $FILES; do
    TABLE_NAME=vagk_`basename $F .shp | cut -d_ -f1`
    echo Importing $F into $TABLE_NAME
    /usr/lib/postgresql/9.1/bin/shp2pgsql -a -W latin1 $F $TABLE_NAME 2>>$ERROR_LOG | tee -a $SQL_LOG | psql -d $DB 1>/dev/null 2>>$ERROR_LOG
done