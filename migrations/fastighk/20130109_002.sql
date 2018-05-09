create table lmv_bright.place (
    gid int primary key,
    kkod int,
    name varchar(40),
    src_name varchar(40),
    type varchar(16),
    size varchar(8),
    priority integer
);

select AddGeometryColumn('lmv_bright', 'place', 'the_geom', 3006, 'POINT', 2);

-- INSERT INTO lmv_bright.place
--     SELECT gid, kkod, text as name, text as src_name,
--     CASE
--     /* Larger places selected from oversikt_mb */
--     WHEN kkod IN (4, 3, 2) THEN 'hamlet'
--     WHEN kkod IN (1) THEN 'locality'
--     WHEN kkod IN (11, 12, 13) THEN 'suburb' /* Tätortsdel */
--     ELSE 'other' END AS type,
--     'other' AS size,
--     kkod as priority,
--     ST_SetSRID(the_geom, 3006) /* Should not be necessary if vagk_tx has SRID properly set */
--     FROM vagk_tx
--     WHERE kkod IN (1, 2, 3, 4, 11, 12, 13);


/* Idea: instead of choosing arbitrary limits for what constitutes a major city, 
   what constitutes a city, etc., build a table and sort by population.
   Let the first three be major cities, the next 15-20 be cities, and so on. 
   Easier to adjust to a suitable density of cities, towns, etc. */

-- INSERT INTO lmv_bright.place
--     SELECT gid+1000000, kkod, namn as name, src_name,
--     CASE
--     WHEN bef>40000 THEN 'city'
--     WHEN bef>8000 THEN 'town'
--     WHEN bef>2000 THEN 'village'
--     ELSE 'hamlet' END AS type,
--     CASE
--     WHEN bef>200000 THEN 'major'
--     ELSE 'other' END AS size,
--     bef/500 AS priority, 
--     ST_SetSRID(ST_Centroid(the_geom), 3006) /* Should not be necessary if oversikt_mb has SRID properly set */
--     FROM (
--         SELECT MIN(gid) gid, ST_Union(the_geom) the_geom, MIN(kkod) kkod, 
--         CASE
--         WHEN namn2 IS NULL OR namn2='' THEN namn1
--         ELSE namn1 || E'\n(' || namn2 || ')' END AS namn, 
--         namn1 as src_name,
--         max(bef) bef
--         FROM oversikt_mb
--         WHERE namn1 != 'Rolfhamre och Måga' /* filter error in Lanmäteriet's data (2013) */
--         GROUP BY tatnr, namn1, namn2) AS tatort_union;

create index on lmv_bright.place (type, size);
create index on lmv_bright.place using gist (the_geom);

/* Filter out places with the same name that are less than 10 km
   from each other, since they're most likely duplicates. */
-- delete from lmv_bright.place where gid in (
--     select p2.gid
--     from lmv_bright.place p1
--     inner join lmv_bright.place p2 
--         on p1.gid!=p2.gid /* don't do < or other smart things, has to be by priority */
--         and p1.src_name=p2.src_name
--         and p1.priority>=p2.priority
--     where st_distance(p1.the_geom, p2.the_geom) < 10000);

alter table lmv_bright.place drop column src_name;
