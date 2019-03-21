truncate lmv_bright.buildings;

INSERT INTO lmv_bright.buildings
    SELECT ogc_fid as gid, the_geom FROM fastighk_by;

