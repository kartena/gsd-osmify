DELETE FROM lmv_bright.railway;
ALTER TABLE lmv_bright.railway drop constraint enforce_geotype_the_geom;

ALTER TABLE lmv_bright.railway DROP COLUMN the_geom;
ALTER TABLE lmv_bright.railway ADD COLUMN the_geom geometry(LineString,3006);
CREATE INDEX ON lmv_bright.railway
  USING GIST(the_geom)

INSERT INTO lmv_bright.railway (gid, the_geom, type, stylegroup, bridge, tunnel)
    SELECT ogc_fid, the_geom,
    CASE
    WHEN detaljtyp in ('JVGR1.M', 'JVGR2.M', 'JVGU.M') THEN 'railway'
    WHEN detaljtyp in ('JVGÖ.M', 'JVGÖU.M') THEN 'tram'
    END AS type,
    'railway' AS stylegroup, 
    FALSE AS bridge, 
    detaljtyp in ('JVGU.M', 'JVGÖU.M') AS tunnel 
    FROM fastighk_jl
    WHERE detaljtyp != 'JVGBY.M';
