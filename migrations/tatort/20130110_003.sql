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
    WHEN detaljtyp in ('JVGR1.M', 'JVGR2.M', 'JVGU.M') THEN 'railway'
    WHEN detaljtyp in ('JVGÖ.M', 'JVGÖU.M') THEN 'tram'
    END AS type,
    'railway' AS stylegroup, FALSE AS bridge, FALSE AS tunnel FROM tatort_jl
    WHERE detaljtyp != 'JVGBY.M';

INSERT INTO lmv_bright.railway
    SELECT gid, the_geom, 'railway' AS type, 'railway' AS stylegroup, FALSE AS bridge, FALSE AS tunnel
    FROM vagk_jl;

create index on lmv_bright.railway (type, stylegroup);
create index on lmv_bright.railway using gist (the_geom);
create index on lmv_bright.railway_tatort (type, stylegroup);
create index on lmv_bright.railway_tatort using gist (the_geom);
