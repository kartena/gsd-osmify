create table lmv_bright.buildings (
    gid int primary key,
    the_geom geometry
);

INSERT INTO lmv_bright.buildings
    SELECT gid, the_geom FROM tatort_by
    UNION
    SELECT gid+10000000, the_geom FROM tatort_bf;

create index on lmv_bright.buildings using gist (the_geom);
