create table lmv_bright.landuse(
    gid int primary key,
    the_geom geometry(Polygon,3006),
    type varchar(16)
);


INSERT INTO lmv_bright.landuse
    SELECT
    ogc_fid,
    the_geom,
    CASE
     WHEN detaljtyp IN ('SKOGFBJ', 'SKOGLÖV', 'SKOGBARR') THEN 'wooded'
     WHEN detaljtyp IN ('BEBLÅG', 'BEBHÖG', 'BEBSLUT', 'BEBYGG') THEN 'residential'
     WHEN detaljtyp = 'BEBIND' THEN 'industrial'
     WHEN detaljtyp = 'ÖPGLAC' THEN 'glacier'
     WHEN detaljtyp = 'VATTEN' THEN 'water'
     WHEN detaljtyp = 'ÖPKFJÄLL' THEN 'fell'
    ELSE 'other' END as type
    FROM fastighk_my;

create index on lmv_bright.landuse (type);
create index on lmv_bright.landuse using gist (the_geom);

