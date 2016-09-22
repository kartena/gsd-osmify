create table lmv_bright.road_label (
    gid int primary key,
    the_geom geometry,
    name varchar(40),
    oneway boolean,
    type varchar(16),
    priority integer
);

INSERT INTO lmv_bright.road_label
    SELECT  gid, the_geom,
    CASE
        WHEN kkod IN (5011, 5016, 5036, 5811, 5816, 5836, 5012, 5017, 5021, 5024, 5028, 5033, 5812, 5817, 5821, 5824, 5828, 5833) THEN (
    CASE
    WHEN vagnr4 IS NOT NULL THEN vagnr1 || ' / ' || vagnr2 || ' / ' || vagnr3 || ' / ' || vagnr4
    WHEN vagnr3 IS NOT NULL THEN vagnr1 || ' / ' || vagnr2 || ' / ' || vagnr3
    WHEN vagnr2 IS NOT NULL THEN vagnr1 || ' / ' || vagnr2
    ELSE vagnr1 END)
        ELSE null END AS name,
    FALSE as oneway,
    CASE
        WHEN kkod IN (5011, 5016, 5036, 5811, 5816, 5836) THEN 'motorway'
        WHEN kkod IN (5012, 5017, 5021, 5024, 5028, 5033, 5812, 5817, 5821, 5824, 5828, 5833) THEN 'trunk'
        WHEN kkod IN (5022,5822) THEN 'primary'
        WHEN kkod IN (5025, 5825) THEN 'secondary'
        ELSE 'other' END AS type,
    0 as priority
    FROM vagk_vl_joined
    WHERE kkod IN (5022, 5025, 5033, 5036, 5822, 5825, 5833, 5836);

INSERT INTO lmv_bright.road_label (gid, the_geom, name, oneway, type, priority)
    SELECT ogc_fid+1000000, ST_MULTI(the_geom),
    CASE
        WHEN namn1 IS NOT NULL THEN namn1
        WHEN vagnr3 IS NOT NULL THEN vagnr1 || ' / ' || vagnr2 || ' / ' || vagnr3
        WHEN vagnr2 IS NOT NULL THEN vagnr1 || ' / ' || vagnr2
        ELSE vagnr1 END as name,
    FALSE as oneway,
    CASE
        WHEN detaljtyp IN ('VÄGMO.D', 'VÄGMOU.D') THEN 'motorway' /* Tätort KOD 34 */
        WHEN detaljtyp IN ('VÄGA1.M', 'VÄGA1U.M', 'VÄGA2.M', 'VÄGA2U.M') THEN 'trunk' /* Tätort KOD 30 */
        WHEN detaljtyp IN ('VÄGA2.M', 'VÄGA2U.M', 'VÄGAS.D', 'VÄGASU.D') THEN 'primary' /* Tätort KOD 31 */
        WHEN detaljtyp IN ('VÄGGG.M', 'VÄGGG.D', 'VÄGGGU.M') THEN 'secondary' /* Tätort KOD 33 */
        WHEN detaljtyp IN ('VÄGBN.M', 'VÄGBNU.M') THEN 'tertiary' /* Tätort KOD 32, previously also included KOD 39, seems to be missing from fastighk */
        WHEN detaljtyp IN ('VÄGBS.M', 'VÄGBSU.M', 'VÄGA3.M', 'VÄGA3U.M') THEN 'unclassified' /* Tätort KOD 36 */
        ELSE 'other' END AS type,
    CASE
        WHEN detaljtyp IN ('VÄGMO.D', 'VÄGMOU.D') THEN 4 /* Tätort KOD 34 */
        WHEN detaljtyp IN ('VÄGA1.M', 'VÄGA1U.M', 'VÄGA2.M', 'VÄGA2U.M') THEN 3 /* Tätort KOD 30 */
        WHEN detaljtyp IN ('VÄGA2.M', 'VÄGA2U.M', 'VÄGAS.D', 'VÄGASU.D') THEN 2 /* Tätort KOD 31 */
        WHEN detaljtyp IN ('VÄGGG.M', 'VÄGGG.D', 'VÄGGGU.M') THEN 1 /* Tätort KOD 33 */
        ELSE 0 END as priority
    FROM tatort_vl
    WHERE detaljtyp != 'FÄRJELED' AND (vagnr1 != '' OR namn1 != '');

create index on lmv_bright.road_label (type, priority);
create index on lmv_bright.road_label using gist (the_geom);
