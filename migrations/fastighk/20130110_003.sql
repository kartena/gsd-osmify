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

INSERT INTO lmv_bright.railway_tatort
    SELECT ogc_fid, the_geom,
    CASE
    WHEN spartyp in (3) THEN 'railway'
    WHEN spartyp in (1) THEN 'tram'
    WHEN spartyp in (2) THEN 'subway'
    END AS type,
    'railway' AS stylegroup,
    FALSE AS bridge,
    CASE
    WHEN niva = 2 THEN TRUE
    ELSE FALSE
    END AS tunnel FROM tatort_jl
    WHERE detaljtyp != 'JVGBY.M';

INSERT INTO lmv_bright.railway
    SELECT gid, the_geom, 'railway' AS type, 'railway' AS stylegroup, FALSE AS bridge, FALSE AS tunnel
    FROM vagk_jl;

create index on lmv_bright.railway (type, stylegroup);
create index on lmv_bright.railway using gist (the_geom);
create index on lmv_bright.railway_tatort (type, stylegroup);
create index on lmv_bright.railway_tatort using gist (the_geom);
