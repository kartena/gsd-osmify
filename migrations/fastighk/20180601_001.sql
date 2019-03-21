
create table lmv_bright.landuse_border (
    gid int primary key,
    the_geom geometry(LineString,3006),
    type varchar(16)
);


INSERT INTO lmv_bright.landuse_border
    SELECT
    ogc_fid AS gid,
    the_geom,
    CASE
     WHEN detaljtyp IN ('STRAND', 'STRANDOTY') THEN 'water'
    END
    FROM fastighk_ml;

create index on lmv_bright.landuse_border (type);
create index on lmv_bright.landuse_border using gist (the_geom);
