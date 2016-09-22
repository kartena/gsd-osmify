CREATE TEMP TABLE list (
    gid int,
    name varchar(45),
    type varchar(26),
    the_geom geometry,
    municipality varchar(4)
);
SELECT SP_CreateLmPoi();
