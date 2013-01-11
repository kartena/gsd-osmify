create table lmv_bright.roads_tatort (
    gid int primary key,
    the_geom geometry,
    type varchar(32),
    stylegroup varchar(32),
    bridge smallint,
    tunnel smallint,
    underpass smallint,
    zindex integer,
    access varchar(4)
);

INSERT INTO lmv_bright.roads_tatort
SELECT gid,
    the_geom,
    CASE
        WHEN kod IN (34) THEN 'motorway'
        WHEN kod IN (30) THEN 'trunk'
        WHEN kod IN (31) THEN 'primary'
        WHEN kod IN (33) THEN 'secondary'
        WHEN kod IN (32, 39) THEN 'tertiary'
        WHEN kod IN (36) THEN 'unclassified'
        WHEN kod IN (37, 38) THEN 'footway'
        ELSE 'other' END AS type,
    CASE
        WHEN kod IN (34) THEN 'motorway'
        WHEN kod IN (30, 33) THEN 'mainroad'
        WHEN kod IN (31, 32, 36, 39) THEN 'minorroad'
        WHEN kod IN (37, 38) THEN 'noauto'
        ELSE 'other' END AS stylegroup,
    0 as bridge,
    0 as tunnel,
    CASE WHEN niva=2 THEN 1 ELSE 0 END as underpass,
    CASE
        WHEN kod IN (34) THEN 4
        WHEN kod IN (30) THEN 3
        WHEN kod IN (31) THEN 2
        WHEN kod IN (33) THEN 1
        WHEN kod IN (32) THEN 0
        ELSE -1 END AS zindex,
    CASE
        WHEN kod=39 THEN 'no'
        ELSE 'yes' END as access
  FROM tatort_vl
  WHERE niva IN (1, 2) AND kod IN (34, 30, 31, 33, 32, 36, 37, 38, 39);

create index on lmv_bright.roads_tatort (type, stylegroup);
create index on lmv_bright.roads_tatort using gist (the_geom);
