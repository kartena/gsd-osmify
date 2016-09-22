create table lmv_bright.landuse_tatort (
    gid int primary key,
    the_geom geometry,
    type varchar(16)
);

INSERT INTO lmv_bright.landuse_tatort
    SELECT gid, the_geom,
    CASE
        WHEN objekt IN ('Vatten') THEN 'water'
        WHEN objekt IN ('Öppen mark', 'Ospecificerad', 'Övrig mark') THEN 'land'
        WHEN objekt IN ('Torg') THEN 'pedestrian'
        WHEN objekt IN ('Industriområde') THEN 'industrial'
        WHEN objekt IN ('Låg bebyggelse', 'Sluten bebyggelse', 'Hög bebyggelse') THEN 'residential'
        WHEN objekt IN ('Skog') THEN 'wooded'
        WHEN objekt IN ('Sankmark') THEN 'wetland'
        ELSE 'other' END AS type
    FROM tatort_my;

create index on lmv_bright.landuse_tatort (type);
create index on lmv_bright.landuse_tatort using gist (the_geom);
