create table lmv_bright.railway (
    gid int primary key,
    the_geom geometry,
    type varchar(32),
    stylegroup varchar(32),
    bridge boolean,
    tunnel boolean
);

create table lmv_bright.railway_tatort (
    gid int primary key,
    the_geom geometry,
    type varchar(32),
    stylegroup varchar(32),
    bridge boolean,
    tunnel boolean
);
/*
INSERT INTO lmv_bright.railway_tatort
    SELECT gid, the_geom,
    CASE
    WHEN kod=50 THEN 'railway'
    WHEN kod=51 THEN 'subway'
    WHEN kod=52 THEN 'tram'
    WHEN kod=53 THEN 'subway'
    END AS type,
    'railway' AS stylegroup, FALSE AS bridge, FALSE AS tunnel FROM tatort_jl
    WHERE kod IN (50, 51, 52, 53);

INSERT INTO lmv_bright.railway
    SELECT gid, the_geom, 'railway' AS type, 'railway' AS stylegroup, FALSE AS bridge, FALSE AS tunnel
    FROM vagk_jl;
    */

create index on lmv_bright.railway (type, stylegroup);
create index on lmv_bright.railway using gist (the_geom);
create index on lmv_bright.railway_tatort (type, stylegroup);
create index on lmv_bright.railway_tatort using gist (the_geom);
