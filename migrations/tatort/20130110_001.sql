create table lmv_bright.road_label (
    gid int primary key,
    the_geom geometry,
    name varchar(40),
    oneway boolean,
    type varchar(16),
    priority integer
);

INSERT INTO lmv_bright.road_label
    SELECT  gid, the_geom,
    CASE
        WHEN kkod IN (5011, 5016, 5036, 5811, 5816, 5836, 5012, 5017, 5021, 5024, 5028, 5033, 5812, 5817, 5821, 5824, 5828, 5833) THEN (
    CASE
    WHEN vagnr4 IS NOT NULL THEN vagnr1 || ' / ' || vagnr2 || ' / ' || vagnr3 || ' / ' || vagnr4
    WHEN vagnr3 IS NOT NULL THEN vagnr1 || ' / ' || vagnr2 || ' / ' || vagnr3
    WHEN vagnr2 IS NOT NULL THEN vagnr1 || ' / ' || vagnr2
    ELSE vagnr1 END)
        ELSE null END AS name,
    FALSE as oneway,
    CASE
        WHEN kkod IN (5011, 5016, 5036, 5811, 5816, 5836) THEN 'motorway'
        WHEN kkod IN (5012, 5017, 5021, 5024, 5028, 5033, 5812, 5817, 5821, 5824, 5828, 5833) THEN 'trunk'
        WHEN kkod IN (5022,5822) THEN 'primary'
        WHEN kkod IN (5025, 5825) THEN 'secondary'
        ELSE 'other' END AS type,
    0 as priority
    FROM vagk_vl_joined
    WHERE kkod IN (5022, 5025, 5033, 5036, 5822, 5825, 5833, 5836);

INSERT INTO lmv_bright.road_label
    SELECT gid+1000000, the_geom, namn1 AS name, FALSE as oneway,
    CASE
        WHEN kod IN (30) THEN 'trunk'
        WHEN kod IN (31) THEN 'primary'
        WHEN kod IN (33) THEN 'secondary'
        ELSE 'other' END AS type,
    1 as priority
    FROM tatort_vl;

create index on lmv_bright.road_label (type, priority);
create index on lmv_bright.road_label using gist (the_geom);
