

-- what tables do we want? 
-- tatort_bi - idrottsanläggningar - landuse_overlays - from fastighk_ba
-- tatort_vl - vägar - road_label - from fastighk_vl
-- tatort_jl - järnväg - railway_tatort etc - from fastighk_jl
-- tatort_by - buildings - from fastighk_by
-- tatort_bf - public buildings, poi - from tatort_by
-- tatort_my - ground - landuse_tatort, waterway_tatort - fastighk_my

create table tatort_bi (
    ogc_fid integer primary key not null,
    the_geom geometry,
    detaljtyp varchar(10),
    adat varchar(16),
    xyfel float,
    namn varchar(45),
    funktion varchar(20),
);

create index on tatort_bi USING GIST (the_geom);

create table tatort_vl (
    ogc_fid integer primary key not null,
    the_geom geometry,
    detaljtyp varchar(10),
    adat varchar(16),
    xyfel float,
    namn1 varchar(100),
    namn2 varchar(100),
    vagnr1 varchar(10),
    vagnr2 varchar(10),
    vagnr3 varchar(10),
    niva float
);

create index on tatort_vl USING GIST (the_geom);

create table tatort_jl (
    ogc_fid integer primary key not null,
    the_geom geometry,
    detaljtyp varchar(10),
    adat varchar(16),
    xyfel float,
    spartyp float,
    niva float
);

create index on tatort_jl USING GIST (the_geom);

create table tatort_by (
    ogc_fid integer primary key not null,
    the_geom geometry,
    fnr_br varchar(14),
    detaljtyp varchar(10),
    adat varchar(16),
    objekt_id varchar(36),
    objekt_ver float,
    insam_lage varchar(30),
    xyfel float,
    namn1 varchar(45),
    namn2 varchar(45),
    namn3 varchar(45),
    huvudbyggn varchar(1),
    andamal_1 float,
    andamal_1t varchar(60),
    andamal_2 float,
    andamal_3 float,
    andamal_4 float,
    andamal_5 float,
    andamal_6 float,
    andamal_7 float,
    andamal_8 float,
    andamal_9 float,
    andamal_10 float
);

create index on tatort_by USING GIST (the_geom);


create table tatort_my (
    ogc_fid integer primary key not null,
    the_geom geometry,
    detaljtyp varchar(10),
    adat varchar(16)
);

create index on tatort_my USING GIST (the_geom);



-- Uses ST_Intersection for magic, mostly fetched from the country example.
-- http://postgis.net/docs/ST_Intersection.html
insert into tatort_bi
SELECT row_number() over () the_geom, *
FROM (SELECT (ST_Dump(ST_Intersection(fastighk_ag.the_geom, fastighk_ba.the_geom))).geom As clipped_geom, fastighk_ba.detaljtyp, fastighk_ba.adat, fastighk_ba.xyfel, fastighk_ba.namn, fastighk_ba.funktion
    FROM fastighk_ag
    INNER JOIN fastighk_ba
    ON ST_Intersects(fastighk_ag.the_geom, fastighk_ba.the_geom))  As clipped
WHERE ST_Dimension(clipped.clipped_geom) = 2; -- 1 is linestring, 0 point, 2 polygon

insert into tatort_vl
SELECT row_number() over () the_geom, *
FROM (SELECT (ST_Dump(ST_Intersection(fastighk_ag.the_geom, fastighk_vl.the_geom))).geom As clipped_geom, fastighk_vl.detaljtyp, fastighk_vl.adat, fastighk_vl.xyfel, fastighk_vl.namn1, fastighk_vl.namn2, fastighk_vl.vagnr1, fastighk_vl.vagnr2, fastighk_vl.vagnr3, fastighk_vl.niva
    FROM fastighk_ag
    INNER JOIN fastighk_vl
    ON ST_Intersects(fastighk_ag.the_geom, fastighk_vl.the_geom))  As clipped
WHERE ST_Dimension(clipped.clipped_geom) = 1 ; -- 1 is linestring, 0 point, 2 polygon

insert into tatort_jl
SELECT row_number() over () the_geom, *
FROM (SELECT (ST_Dump(ST_Intersection(fastighk_ag.the_geom, fastighk_jl.the_geom))).geom As clipped_geom, fastighk_jl.detaljtyp, fastighk_jl.adat, fastighk_jl.xyfel, fastighk_jl.spartyp, fastighk_jl.niva
    FROM fastighk_ag
    INNER JOIN fastighk_jl
    ON ST_Intersects(fastighk_ag.the_geom, fastighk_jl.the_geom))  As clipped
WHERE ST_Dimension(clipped.clipped_geom) = 1; -- 1 is linestring, 0 point, 2 polygon

insert into tatort_by
SELECT row_number() over () the_geom, *
FROM (SELECT (ST_Dump(ST_Intersection(fastighk_ag.the_geom, fastighk_by.the_geom))).geom As clipped_geom, fastighk_by.fnr_br, fastighk_by.detaljtyp, fastighk_by.adat, fastighk_by.objekt_id, fastighk_by.objekt_ver, fastighk_by.insam_lage, fastighk_by.xyfel, fastighk_by.namn1, fastighk_by.namn2, fastighk_by.namn3, fastighk_by.huvudbyggn, fastighk_by.andamal_1, fastighk_by.andamal_1t, fastighk_by.andamal_2, fastighk_by.andamal_3, fastighk_by.andamal_4, fastighk_by.andamal_5, fastighk_by.andamal_6, fastighk_by.andamal_7, fastighk_by.andamal_8, fastighk_by.andamal_9, fastighk_by.andamal_10
    FROM fastighk_ag
    INNER JOIN fastighk_by
    ON ST_Intersects(fastighk_ag.the_geom, fastighk_by.the_geom))  As clipped
WHERE ST_Dimension(clipped.clipped_geom) = 2; -- 1 is linestring, 0 point, 2 polygon

insert into tatort_my
SELECT row_number() over () the_geom, *
FROM (SELECT (ST_Dump(ST_Intersection(fastighk_ag.the_geom, fastighk_my.the_geom))).geom As clipped_geom, fastighk_my.detaljtyp, fastighk_my.adat
    FROM fastighk_ag
    INNER JOIN fastighk_my
    ON ST_Intersects(fastighk_ag.the_geom, fastighk_my.the_geom))  As clipped
WHERE ST_Dimension(clipped.clipped_geom) = 2; -- 1 is linestring, 0 point, 2 polygon
