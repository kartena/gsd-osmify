/* Drop previously created road labels and replace with road labels from
   Fastighetskartan. */
DELETE FROM lmv_bright.road_label;

ALTER TABLE lmv_bright.road_label ALTER COLUMN name TYPE varchar(100);

INSERT INTO lmv_bright.road_label (gid, the_geom, name, oneway, type, priority)
    SELECT ogc_fid, ST_MULTI(the_geom),
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
    FROM fastighk_vl
    WHERE detaljtyp != 'FÄRJELED' AND (vagnr1 != '' OR namn1 != '');
