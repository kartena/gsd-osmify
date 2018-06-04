CREATE TABLE "lmv_bright"."wetlands" (
    gid int primary key,
    type varchar(16),
    the_geom geometry
);

CREATE INDEX ON lmv_bright.wetlands USING GIST (the_geom);

insert into lmv_bright.wetlands
    select gid,
        type,
        the_geom
    FROM lmv_bright.landuse_terrang
    WHERE type = 'swamp'
    UNION
    SELECT gid,
        type,
        the_geom
    FROM lmv_bright.landuse_inre_norrland
    WHERE type = 'swamp';
