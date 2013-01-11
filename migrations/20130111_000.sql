create table lmv_bright.landuse_terrang (
    gid int primary key,
    the_geom geometry,
    type varchar(16)
);

create table lmv_bright.landuse_oversikt (
    gid int primary key,
    the_geom geometry,
    type varchar(16)
);

INSERT INTO lmv_bright.landuse_terrang
    SELECT
    gid,
    the_geom,
    CASE
        WHEN kategori='Industriområde' THEN 'industrial'
        WHEN kategori IN ('Låg bebyggelse', 'Sluten bebyggelse', 'Hög bebyggelse') THEN 'residential'
        WHEN kategori IN ('Skog, barr- och blandskog', 'Fjällbjörkskog', 'Lövskog') THEN 'wooded'
        WHEN kategori IN ('Vattenyta', 'Vattenyta med diffus strandlinje') THEN 'water'
        ELSE 'other' END as type
    FROM terrang_my;

INSERT INTO lmv_bright.landuse_oversikt
    SELECT
    gid,
    the_geom,
    CASE
        WHEN kategori IN ('Annan koncentrerad bebyggelse', 'Tätort') THEN 'residential'
        WHEN kategori IN ('Skogsmark') THEN 'wooded'
        WHEN kategori IN ('Vattenyta', 'Hav, territorialt vatten') THEN 'water'
        /* TODO: kalfjäll, glaciär, alvarmark */
        ELSE 'other' END as type
    FROM oversikt_my;

create index on lmv_bright.landuse_terrang (type);
create index on lmv_bright.landuse_terrang using gist (the_geom);

create index on lmv_bright.landuse_oversikt (type);
create index on lmv_bright.landuse_oversikt using gist (the_geom);
