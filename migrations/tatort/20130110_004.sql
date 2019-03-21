create table lmv_bright.roads_tatort (
    gid int primary key,
    the_geom geometry,
    type varchar(32),
    stylegroup varchar(32),
    bridge smallint,
    tunnel smallint,
    underpass smallint,
    zindex integer,
    access varchar(4)
);

INSERT INTO lmv_bright.roads_tatort (gid, the_geom, type, stylegroup, bridge, tunnel, underpass, zindex, access)
SELECT ogc_fid,
    the_geom,
    CASE
        WHEN detaljtyp IN ('VÄGMO.D', 'VÄGMOU.D') THEN 'motorway' /* Tätort KOD 34 */
        WHEN detaljtyp IN ('VÄGA1.M', 'VÄGA1U.M', 'VÄGA2.M', 'VÄGA2U.M') THEN 'trunk' /* Tätort KOD 30 */
        WHEN detaljtyp IN ('VÄGA2.M', 'VÄGA2U.M', 'VÄGAS.D', 'VÄGASU.D') THEN 'primary' /* Tätort KOD 31 */
        WHEN detaljtyp IN ('VÄGGG.M', 'VÄGGG.D', 'VÄGGGU.M') THEN 'secondary' /* Tätort KOD 33 */
        WHEN detaljtyp IN ('VÄGBN.M', 'VÄGBNU.M') THEN 'tertiary' /* Tätort KOD 32, previously also included KOD 39, seems to be missing from fastighk */
        WHEN detaljtyp IN ('VÄGBS.M', 'VÄGBSU.M', 'VÄGA3.M', 'VÄGA3U.M') THEN 'unclassified' /* Tätort KOD 36 */
        ELSE 'other' END AS type,
    CASE
        WHEN detaljtyp IN ('VÄGMO.D', 'VÄGMOU.D') THEN 'motorway'
        WHEN detaljtyp IN ('VÄGA1.M', 'VÄGA1U.M', 'VÄGA2.M', 'VÄGA2U.M', 'VÄGGG.M', 'VÄGGG.D', 'VÄGGGU.M') THEN 'mainroad'
        WHEN detaljtyp IN ('VÄGA2.M', 'VÄGA2U.M', 'VÄGAS.D', 'VÄGASU.D', 'VÄGBN.M', 'VÄGBNU.M', 'VÄGBS.M', 'VÄGBSU.M', 'VÄGA3.M', 'VÄGA3U.M') THEN 'minorroad'
        ELSE 'other' END AS stylegroup,
    0 as bridge,
    CASE
        WHEN niva = 3 THEN 1
        ELSE 0 END AS tunnel,
    CASE WHEN niva=2 THEN 1 ELSE 0 END as underpass,
    CASE
        WHEN detaljtyp IN ('VÄGMO.D', 'VÄGMOU.D') THEN 4
        WHEN detaljtyp IN ('VÄGA1.M', 'VÄGA1U.M', 'VÄGA2.M', 'VÄGA2U.M') THEN 3
        WHEN detaljtyp IN ('VÄGA2.M', 'VÄGA2U.M', 'VÄGAS.D', 'VÄGASU.D') THEN 2
        WHEN detaljtyp IN ('VÄGGG.M', 'VÄGGG.D', 'VÄGGGU.M') THEN 1
        WHEN detaljtyp IN ('VÄGBN.M', 'VÄGBNU.M') THEN 0
        ELSE -1 END AS zindex,
    'yes' as access
  FROM tatort_vl
  WHERE detaljtyp NOT IN ('VÄGA0BY.M', 'FÄRJELED'); /* Ignore "Vägar under byggnation", perhaps draw them in the future? */

create index on lmv_bright.roads_tatort (type, stylegroup);
create index on lmv_bright.roads_tatort using gist (the_geom);
