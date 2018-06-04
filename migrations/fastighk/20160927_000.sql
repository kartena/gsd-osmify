
insert into lmv_bright.poi (gid, the_geom, type)
    select row_number() over()+100000000,
        the_geom,
        CASE
        WHEN kategori in ('Gästhamn') THEN 'port'
        WHEN kategori in ('Badplats') THEN 'swimming'
        END as type
    from terrang_bs where kategori in ('Gästhamn', 'Badplats');


CREATE TABLE "lmv_bright"."altitude" (
    gid int primary key,
    type varchar(16),
    equidistance int,
    the_geom geometry(MultiLineString, 3006)
);

CREATE INDEX ON lmv_bright.altitude USING GIST (the_geom);

insert into lmv_bright.altitude
    select row_number() over(),
        CASE
        WHEN kategori in ('Höjdkurva') THEN 'altitude'
        WHEN kategori in ('Gropkurva') THEN 'depth'
        WHEN kategori in ('Skärning') THEN 'cut'
        END as type,
        10,
        the_geom
    from vagk_oh;


insert into lmv_bright.altitude
    select row_number() over()+10000000,
        CASE
        WHEN kategori like 'Höjdkurva%' THEN 'altitude'
        WHEN kategori like 'Sänka%' THEN 'depth'
        WHEN kategori in ('Skärning') THEN 'cut'
        END as type,
        5,
        the_geom
    from terrang_oh;

CREATE TABLE "lmv_bright"."roads_other" (
    gid int primary key,
    type varchar(16),
    the_geom geometry(MultiLineString, 3006)
);

CREATE INDEX ON lmv_bright.roads_other USING GIST (the_geom);

insert into lmv_bright.roads_other
    select row_number() over(),
        CASE
        WHEN kategori in ('Traktorväg') THEN 'tractor'
        WHEN kategori in ('Cykelväg') THEN 'bicycle'
        END as type,
        the_geom
    from terrang_vo;

CREATE TABLE "lmv_bright"."archaeology" (
    gid int primary key,
    the_geom geometry(Point, 3006)
);

CREATE INDEX ON lmv_bright.archaeology USING GIST (the_geom);

insert into lmv_bright.archaeology
    select row_number() over(),
        the_geom
    from terrang_fs;

CREATE TABLE "lmv_bright"."railway_stations" (
    gid int primary key,
    type varchar(16),
    name varchar(45),
    the_geom geometry(Point, 3006)
);

CREATE INDEX ON lmv_bright.railway_stations USING GIST (the_geom);

insert into lmv_bright.railway_stations
    select row_number() over(),
        CASE 
        WHEN spartyp = 1 then 'tram'
        WHEN spartyp = 2 then 'subway'
        WHEN spartyp = 3 then 'railway'
        END AS type,
        namn as name,
        the_geom
    from fastighk_js;


