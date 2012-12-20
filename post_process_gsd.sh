#!/bin/sh

DB=lmv

# Make sure we have the correct projection settings for RT90
# (Not currently essential since we don't render to RT90, but why not.)
psql $DB -c <<EOF
update SPATIAL_REF_SYS set srtext='PROJCS["RT90.RT90_2,5_gon_V",GEOGCS["Latitude/Longitude.OpenGIS.Rikets_koordinatsystem\
_1990",DATUM["Rikets_koordinatsystem_1990",SPHEROID["Bessel 1841",6377397.155,299.152812800003],TOWGS84[414.1, 41.3, 603.\
1, -0.855, 2.141, -7.023, 0.0]],PRIMEM["Greenwich",0],UNIT["degrees",0.0174532925199433]],PROJECTION["Transverse_Mercator\
"],PARAMETER["Central_Meridian",15.8082777778],PARAMETER["False_Easting",1500000],PARAMETER["False_Northing",0],PARAMETER\
["Latitude_of_Origin",0],PARAMETER["Scale_Factor",1],UNIT["m",1]]', proj4text='+lon_0=15.808277777799999 +lat_0=0.0 +k=1.\
0 +x_0=1500000.0 +y_0=0.0 +proj=tmerc +ellps=bessel +units=m +towgs84=414.1,41.3,603.1,-0.855,2.141,-7.023,0 +no_defs' wh\
ere srid=2400;
EOF

# Create indices for Terrängkartan and Vägkartan.
# These use "kkod" as the category type column.
TABLES=`psql -q -c "select table_name from information_schema.tables where table_schema='public' order by table_name;" $D\
B | egrep "(terrang|vagk)"`

for T in $TABLES; do
    echo $T
    psql $DB <<EOF
        create index on $T using gist (the_geom);
        create index on $T (kkod);
        create index on $T (kategori);
        vacuum analyze $T (the_geom);
EOF
done

# Create indices for Tätortskartan.
# It uses "kod" as the category type column.
TABLES=`psql -q -c "select table_name from information_schema.tables where table_schema='public' order by table_name;" $D\
B | egrep "tatort"`

for T in $TABLES; do
    echo $T
    psql $DB <<EOF
       create index on $T using gist (the_geom);
       create index on $T (kod);
       create index on $T (objekt);
       vacuum analyze $T (the_geom);
EOF
done
