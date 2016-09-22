create table lmv_bright.roads (
    gid int primary key,
    the_geom geometry,
    type varchar(16),
    stylegroup varchar(16),
    zindex integer,
    bridge smallint,
    tunnel smallint,
    underpass smallint,
    access varchar(4)
);

INSERT INTO lmv_bright.roads
SELECT gid,
    the_geom,
    CASE
        WHEN kkod IN (5011, 5016, 5036, 5811, 5816, 5836) THEN 'motorway'
        WHEN kkod IN (5012, 5017, 5021, 5024, 5028, 5033, 5812, 5817, 5821, 5824, 5828, 5833) THEN 'trunk'
        WHEN kkod IN (5022, 5822) THEN 'primary'
        WHEN kkod IN (5025, 5825) THEN 'secondary'
        WHEN kkod IN (5029, 5060, 5061, 5070, 5071, 5082, 5829, 5860, 5861, 5870, 5871, 5882) THEN 'tertiary'
        WHEN kkod IN (5040, 5045, 5840, 5845) THEN 'residential'
        WHEN kkod IN (5091, 5891) THEN 'service'
        ELSE 'other' END AS type,
    CASE
        WHEN kkod IN (5011, 5016, 5012, 5017, 5021, 5024, 5028, 5036, 5811, 5816, 5812, 5817, 5821, 5824, 5828, 5836) THEN 'motorway'
        WHEN kkod IN (5022, 5025, 5033, 5822, 5825, 5833) THEN 'mainroad'
        WHEN kkod IN (5029, 5060, 5061, 5040, 5045, 5091, 5070, 5071, 5082, 5829, 5860, 5861, 5840, 5845, 5891, 5870, 5871, 5882) THEN 'minorroad'
        ELSE 'other' END AS stylegroup,
    CASE
        WHEN kkod IN (5011, 5016, 5036, 5811, 5816, 5836) THEN 7
        WHEN kkod IN (5012, 5017, 5021, 5024, 5028, 5033, 5812, 5817, 5821, 5824, 5828, 5833) THEN 6
        WHEN kkod IN (5022, 5822) THEN 5
        WHEN kkod IN (5025, 5825) THEN 4
        WHEN kkod IN (5029, 5060, 5061, 5071, 5082, 5829, 5860, 5861, 5871, 5882) THEN 3
        WHEN kkod IN (5040, 5045, 5840, 5845) THEN 2
        WHEN kkod IN (5091, 5891) THEN 1
        ELSE 0 END AS zindex,
    0 as bridge, 0 as tunnel,
    CASE
        WHEN kkod >= 5800 THEN 1
        ELSE 0 END AS underpass,
    'yes' as access
  FROM vagk_vl_joined
  WHERE kkod IN (5011, 5012, 5016, 5017, 5060, 5021, 5022, 5061, 5024, 5025,
    5028, 5029, 5033, 5036, 5040, 5045, 5070, 5071, 5082, 5091,
    5811, 5812, 5816, 5817, 5860, 5821, 5822, 5861, 5824, 5825,
    5828, 5829, 5833, 5836, 5840, 5845, 5870, 5871, 5882, 5891);

create index on lmv_bright.roads (type);
create index on lmv_bright.roads using gist (the_geom);
