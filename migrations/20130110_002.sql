create table lmv_bright.motorway_label (
    gid int primary key,
    the_geom geometry,
    name varchar(40),
    ref varchar(40),
    reflen integer,
    oneway boolean,
    type varchar(16),
    euro_road boolean
);

INSERT INTO lmv_bright.motorway_label
    SELECT gid, the_geom, vagnr1 AS name, CASE
        WHEN vagnr4 IS NOT NULL THEN vagnr1 || ' / ' || vagnr2 || ' / ' || vagnr3 || ' / ' || vagnr4
        WHEN vagnr3 IS NOT NULL THEN vagnr1 || ' / ' || vagnr2 || ' / ' || vagnr3
        WHEN vagnr2 IS NOT NULL THEN vagnr1 || ' / ' || vagnr2
        ELSE vagnr1 END as ref,
    CHAR_LENGTH(CASE
        WHEN vagnr4 IS NOT NULL THEN vagnr1 || ' / ' || vagnr2 || ' / ' || vagnr3 || ' / ' || vagnr4
        WHEN vagnr3 IS NOT NULL THEN vagnr1 || ' / ' || vagnr2 || ' / ' || vagnr3
        WHEN vagnr2 IS NOT NULL THEN vagnr1 || ' / ' || vagnr2
    ELSE vagnr1 END) as reflen,
    FALSE as oneway,
    CASE
        WHEN kkod IN (5011, 5016, 5811, 5816) THEN 'motorway'
        WHEN kkod IN (5012, 5017, 5021, 5024, 5028, 5812, 5817, 5821, 5824, 5828) THEN 'trunk' ELSE 'other' END AS type,
    vagnr1 IS NOT NULL AND left(vagnr1, 1) = 'E' AS euro_road
    FROM vagk_vl
    WHERE kkod IN (5011, 5012, 5016, 5017, 5021, 5024, 5028, 5811, 5812, 5816, 5817, 5821, 5824, 5828);

create index on lmv_bright.motorway_label (type, euro_road);
create index on lmv_bright.motorway_label using gist (the_geom);
