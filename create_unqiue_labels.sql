# A lot of texts in terrang_tx occurs more than one time, some of them
# a silly amount of times (for example "Östersjön").
#
# This script attempts to improve the situation by building a new table
# where duplicates have been removed.
#
# At the same time, we osmify the data by introducing the type column and
# a size column, that attempts to emulate what OSM Bright uses the area_labels's
# area attribute for, i.e. classifying features by size/importance to be able
# to choose the right zoom level.

create table terrang_tx_unique (
    gid int, the_geom geometry,
    kkod int,
    name varchar(40),
    type varchar(16),
    size int
);

INSERT INTO terrang_tx_unique
WITH summary AS (
    SELECT gid, the_geom, kkod, text AS name,
        CASE
            WHEN text LIKE '%yrkogård%' THEN 'cemetery'
            WHEN kkod IN (24, 25) THEN 'airport'
            WHEN kkod IN (42, 43, 44, 45, 46, 47, 48, 49) THEN 'park'
            WHEN kkod IN (51, 52, 53, 54, 55, 56, 57, 58, 59) THEN 'park'
            WHEN kkod IN (82, 83, 84, 85, 86, 87, 88, 89, 182, 183, 184, 185, 186, 187, 188, 189, 192, 193, 194, 195, 196, 197, 198, 199) THEN 'water'
            ELSE 'other' END AS type,
        CASE
            WHEN kkod=24 THEN 5
            WHEN kkod=25 THEN 5
            WHEN kkod IN (42, 43, 44, 45, 46, 47, 48, 49) THEN kkod - 40
            WHEN kkod IN (51, 52, 53, 54, 55, 56, 57, 58, 59) THEN kkod - 49
            WHEN kkod IN(82, 83, 84, 85, 86, 87, 88, 89) THEN kkod - 80
            WHEN kkod IN(182, 183, 184, 185, 186, 187, 188, 189) THEN kkod - 180
            WHEN kkod IN(192, 193, 194, 195, 196, 197, 198, 199) THEN kkod - 190
            ELSE 0 END AS size,
        ROW_NUMBER() OVER(PARTITION BY text,kkod) AS rk
    FROM terrang_tx)
SELECT s.gid, s.the_geom, s.kkod, s.name, s.type, s.size FROM summary s WHERE rk=1;

create index on terrang_tx_unique USING GIST (the_geom);

vacuum analyze terrang_tx_unique;