CREATE TABLE "lmv_bright"."waterway" (
    gid int primary key,
    type varchar(16),
    the_geom geometry(MultiLineString, 3006)
);

CREATE INDEX ON lmv_bright.waterway USING GIST (the_geom);

insert into lmv_bright.waterway
    select gid,
       case
       when kategori IN ('Vattendrag, kartografisk klass 3') THEN 'canal'
       when kategori IN ('Vattendrag, kartografisk klass 2') THEN 'stream'
       when kategori IN ('Vattendrag, kartografisk klass 1') THEN 'ditch'
       else 'other' end AS type,
       the_geom
    from terrang_hl;

CREATE TABLE "lmv_bright"."aeroway" (
    gid int primary key,
    type varchar(16),
    the_geom geometry(MultiPolygon, 3006)
);

CREATE INDEX ON lmv_bright.aeroway USING GIST (the_geom);

insert into lmv_bright.aeroway
    select gid,
        'runway',
        the_geom
    from terrang_hl where kategori = 'Flygbana, belagd';

CREATE TABLE "lmv_bright"."ferries" (
    gid int primary key,
    type varchar(16),
    the_geom geometry(MultiLineString, 3006)
);

CREATE INDEX ON lmv_bright.ferries USING GIST (the_geom);

insert into lmv_bright.ferries
    select gid,
        'ferries',
        the_geom
    from vagk_vo where kategori = 'Färjeled';

CREATE TABLE "lmv_bright"."admin" (
    gid int primary key,
    type varchar(16),
    the_geom geometry(MultiLineString, 3006)
);

CREATE INDEX ON lmv_bright.admin USING GIST (the_geom);

insert into lmv_bright.admin
    select gid,
        'country',
        the_geom
    from vagk_al where kategori = 'Riksgräns';


CREATE TABLE "lmv_bright"."building_points" (
    gid int primary key,
    type varchar(16),
    the_geom geometry(Point, 3006)
);

CREATE INDEX ON lmv_bright.building_points USING GIST (the_geom);

insert into lmv_bright.building_points
    select gid,
        CASE
        WHEN kategori in ('Gård') THEN 'farm'
        WHEN kategori in ('Herrgård') THEN 'mansion'
        WHEN kategori in ('Slott') THEN 'castle'
        WHEN kategori in ('Hus, storleksklass 1') THEN 'house1'
        WHEN kategori in ('Hus, storleksklass 2') THEN 'house2'
        WHEN kategori in ('Hus, storleksklass 3') THEN 'house3'
        WHEN kategori in ('Hus, storleksklass 4') THEN 'house4'
        END as type,
        the_geom
    from terrang_bs where kategori in ('Gård', 'Herrgård', 'Slott') or kategori like 'Hus,%';


