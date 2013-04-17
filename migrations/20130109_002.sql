create table lmv_bright.place (
    gid int primary key,
    the_geom geometry,
    kkod int,
    name varchar(40),
    type varchar(16),
    size varchar(8),
    priority integer
);

INSERT INTO lmv_bright.place
    SELECT gid, the_geom, kkod, text as name,
    CASE
    /* Larger places (kkod 9-7) selected from oversikt_tx */
    WHEN kkod IN (6, 5) THEN 'village'
    WHEN kkod IN (4, 3) THEN 'hamlet'
    WHEN kkod IN (2) THEN 'locality'
    WHEN kkod IN (11, 12, 13) THEN 'suburb' /* Tätortsdel */
    ELSE 'other' END AS type,
    'other' AS size,
    kkod as priority
    FROM vagk_tx;

INSERT INTO lmv_bright.place
    SELECT gid+1000000, the_geom, kkod, text as name,
    CASE
    WHEN kkod IN (4, 9, 104, 109) THEN 'city'
    WHEN kkod IN (8, 7, 108, 107) THEN 'town'
    ELSE 'other' END AS type,
    CASE
    WHEN text IN ('Göteborg', 'Stockholm', 'Malmö') THEN 'major' /* Woho! */
    ELSE 'other' END AS size,
    7 as priority
    FROM oversikt_tx
    WHERE kkod IN (4, 9, 8, 7, 104, 109, 108, 107);

create index on lmv_bright.place (type, size);
create index on lmv_bright.place using gist (the_geom);

