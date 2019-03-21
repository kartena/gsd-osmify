DELETE FROM lmv_bright.roads;

INSERT INTO lmv_bright.roads
SELECT gid,
    the_geom,
    CASE
        WHEN kkod IN (5011, 5016, 5036, 5811, 5816, 5836) THEN 'motorway'
        WHEN kkod IN (5012, 5017, 5021, 5022, 5024, 5028, 5033, 5044, 5812, 5817, 5821, 5822, 5824, 5828, 5833, 5844) THEN 'trunk'
        WHEN kkod IN (5032, 5044, 5832, 5844) THEN 'primary'
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
  FROM lmv_bright.inre_norrland_roads
  WHERE kkod IN (5011, 5012, 5016, 5017, 5021, 5022, 5024, 5025,
    5028, 5029, 5032, 5033, 5036, 5040, 5044, 5045, 5060, 5061, 5070, 5071, 5082, 5091,
    5811, 5812, 5816, 5817, 5860, 5821, 5822, 5861, 5824, 5825,
    5828, 5829, 5833, 5836, 5840, 5845, 5870, 5871, 5882, 5891);

INSERT INTO lmv_bright.roads
SELECT gid+10000000,
    the_geom,
    CASE
        WHEN kkod IN (5011, 5016, 5811, 5816) THEN 'motorway'
        WHEN kkod IN (5012, 5017, 5021, 5022, 5024, 5028, 5032, 5812, 5817, 5821, 5822, 5824, 5828, 5832, 5834) THEN 'trunk'
        WHEN kkod IN (5044, 5844) THEN 'primary'
        WHEN kkod IN (5025, 5033, 5825, 5833) THEN 'secondary'
        WHEN kkod IN (5029, 5034, 5051, 5060, 5061, 5071, 5082, 5829, 5834, 5851, 5860, 5861, 5871, 5882) THEN 'tertiary'
        WHEN kkod IN (5056, 5058, 5840, 5858, 5856) THEN 'residential'
        WHEN kkod IN (5091, 5891) THEN 'service'
        ELSE 'other' END AS type,
    CASE
        WHEN kkod IN (5011, 5016, 5012, 5017, 5021, 5024, 5028, 5811, 5816, 5812, 5817, 5821, 5824, 5828) THEN 'motorway'
        WHEN kkod IN (5022, 5025, 5032, 5033, 5034, 5822, 5825, 5833, 5834) THEN 'mainroad'
        WHEN kkod IN (5029, 5051, 5058, 5060, 5061, 5056, 5044, 5091, 5071, 5082, 5829, 5851, 5856, 5858, 5860, 5861, 5840, 5844, 5891, 5844, 5871, 5882) THEN 'minorroad'
        ELSE 'other' END AS stylegroup,
    CASE
        WHEN kkod IN (5011, 5016, 5811, 5816, 5834) THEN 7
        WHEN kkod IN (5012, 5017, 5021, 5022, 5024, 5028, 5812, 5817, 5821, 5822, 5824, 5828, 5834) THEN 6
        WHEN kkod IN (5032, 5033, 5044, 5832, 5833, 5844) THEN 5
        WHEN kkod IN (5025, 5825) THEN 4
        WHEN kkod IN (5029, 5034, 5051, 5060, 5061, 5071, 5082, 5829, 5834, 5851, 5860, 5861, 5871, 5882) THEN 3
        WHEN kkod IN (5056, 5058, 5840, 5856, 5858) THEN 2
        WHEN kkod IN (5091, 5891) THEN 1
        ELSE 0 END AS zindex,
    0 as bridge, 0 as tunnel,
    CASE
        WHEN kkod >= 5800 THEN 1
        ELSE 0 END AS underpass,
    'yes' as access
  FROM terrang_vl
  WHERE kkod IN (5011, 5012, 5016, 5017, 5060, 5021, 5022, 5051, 5061, 5024, 5025,
    5028, 5029, 5032, 5033, 5034, 5044, 5056, 5058, 5071, 5082, 5091,
    5811, 5812, 5816, 5817, 5860, 5821, 5822, 5861, 5824, 5825,
    5828, 5829, 5832, 5833, 5834, 5834, 5840, 5844, 5851, 5856, 5858, 5871, 5882, 5891);

