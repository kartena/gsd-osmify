create table lmv_bright.landuse_overlays (
    gid int primary key,
    the_geom geometry,
    type varchar(16)
);

INSERT INTO lmv_bright.landuse_overlays
    SELECT ogc_fid, the_geom,
    CASE
        WHEN funktion IN ('Golfbana') THEN 'golf_course'
        WHEN funktion IN ('Övrigt') THEN 'other'
        ELSE 'pitch' END AS type
    FROM tatort_bi;

create index on lmv_bright.landuse_overlays (type);
create index on lmv_bright.landuse_overlays using gist (the_geom);
