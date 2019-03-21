create table lmv_bright.buildings (
    gid int primary key,
    the_geom geometry
);

INSERT INTO lmv_bright.buildings
    SELECT ogc_fid, the_geom FROM tatort_by;

create index on lmv_bright.buildings using gist (the_geom);
