INSERT INTO lmv_bright.landuse_overlays
    SELECT
    ogc_fid,
    the_geom,
    CASE
     WHEN detaljtyp IN ('IDRPLAN') THEN 'sports_center'
     WHEN funktion IN ('Golfbana') THEN 'golf_course'
     WHEN funktion IN ('Motorbana') THEN 'sports_center'
     WHEN funktion IN ('Avfallsanläggning', 'Återvinningsanläggning', 'Bilskrotningsanläggning') THEN 'recycling'
     WHEN funktion IN ('Begravningsplats') THEN 'cemetery'
     WHEN funktion IN ('Campingplats') THEN 'camping'
     WHEN funktion IN ('Djurpark') THEN 'zoo'
     WHEN funktion IN ('Flygfält', 'Flygplats') THEN 'airfield'
     WHEN funktion IN ('Koloniområde') THEN 'park'
     WHEN funktion IN ('Skjutbana') THEN 'shooting_range'
    ELSE 'other' END as type
    FROM fastighk_ba;

INSERT INTO lmv_bright.landuse_overlays
    SELECT
    ogc_fid + 50000,
    the_geom,
    'nature_reserve'
    FROM fastighk_ny;
