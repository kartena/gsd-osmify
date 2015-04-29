/* Drop previously created motorway labels and replace with labels from
   Fastighetskartan. */

DELETE FROM lmv_bright.motorway_label;

INSERT INTO lmv_bright.motorway_label
    SELECT ogc_fid, ST_PointN(the_geom, ST_NPoints(the_geom) / 2), n AS name, n AS ref, CHAR_LENGTH(n) AS reflen,
        0 as oneway, 
        CASE
            WHEN detaljtyp IN ('VÄGMO.D', 'VÄGMOU.D') THEN 'motorway'
            WHEN detaljtyp IN ('VÄGA1.M', 'VÄGA1U.M', 'VÄGA2.M', 'VÄGA2U.M') THEN 'trunk' 
            ELSE 'other' END AS type,
        CASE 
            WHEN n IS NOT NULL AND left(n, 1) = 'E' THEN 1
            ELSE 0 END AS euro_road
    FROM (
        SELECT ogc_fid, the_geom,
            CASE
                WHEN vagnr3 != '' AND rand > .75 THEN vagnr3
                WHEN vagnr2 != '' AND rand > .5 THEN vagnr2
                ELSE vagnr1 END AS n,
            detaljtyp, rand
        FROM (select fastighk_vl.*, random() as rand from fastighk_vl) AS fastighk_vl_rand
        /* Filter out euro roads and "riksvägar", roads with numbers < 100 */
        WHERE detaljtyp != 'FÄRJELED' AND vagnr1 != '' AND (left(vagnr1, 1) = 'E' OR CHAR_LENGTH(vagnr1) < 3)
    ) AS road
    WHERE n IS NOT NULL AND CHAR_LENGTH(n) > 0;
