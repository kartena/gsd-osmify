create table lmv_bright.motorway_label (
    gid int primary key,
    the_geom geometry,
    name varchar(40),
    ref varchar(40),
    reflen integer,
    oneway smallint,
    type varchar(16),
    euro_road smallint
);

/*
INSERT INTO lmv_bright.motorway_label
    SELECT gid, ST_CENTROID(the_geom), n AS name, n AS ref, CHAR_LENGTH(n) AS reflen,
        0 as oneway, 
        CASE
            WHEN kkod IN (5011, 5016, 5811, 5816) THEN 'motorway'
            WHEN kkod IN (5012, 5017, 5021, 5024, 5028, 5812, 5817, 5821, 5824, 5828) THEN 'trunk' ELSE 'other' END AS type,
        CASE 
            WHEN n IS NOT NULL AND left(n, 1) = 'E' THEN 1
            ELSE 0 END AS euro_road
    FROM (
        SELECT gid, the_geom,
            CASE
                WHEN vagnr4 IS NOT NULL AND rand > .87 THEN vagnr4
                WHEN vagnr3 IS NOT NULL AND rand > .67 THEN vagnr3
                WHEN vagnr2 IS NOT NULL AND rand > .33 THEN vagnr2
                ELSE vagnr1 END AS n,
            kkod, rand
        FROM (select vagk_vl.*, random() as rand from vagk_vl) AS vagk_vl_rand
        WHERE kkod IN (5011, 5012, 5016, 5017, 5021, 5024, 5028, 5811, 5812, 5816, 5817, 5821, 5824, 5828)
    ) AS road
    WHERE n IS NOT NULL AND CHAR_LENGTH(n) > 0;
*/

create index on lmv_bright.motorway_label (type, euro_road);
create index on lmv_bright.motorway_label using gist (the_geom);
