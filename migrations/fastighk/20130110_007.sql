create table lmv_bright.landuse_tatort (
    gid int primary key,
    the_geom geometry,
    type varchar(16)
);

INSERT INTO lmv_bright.landuse_tatort
    SELECT ogc_fid, the_geom,
    CASE
        WHEN detaljtyp IN ('VATTEN') THEN 'water'
        WHEN detaljtyp IN ('ÖPMARK', 'OSPEC', 'MRKÖVR') THEN 'land'
        WHEN detaljtyp IN ('ÖPTORG') THEN 'pedestrian'
        WHEN detaljtyp IN ('BEBIND') THEN 'industrial'
        WHEN detaljtyp IN ('BEBLÅG', 'BEBSLUT', 'BEBHÖG') THEN 'residential'
        WHEN detaljtyp IN ('SKOGBARR', 'SKOGLÖV', 'SKOGFBJ') THEN 'wooded'
        ELSE 'other' END AS type
    FROM tatort_my;

create index on lmv_bright.landuse_tatort (type);
create index on lmv_bright.landuse_tatort using gist (the_geom);
