INSERT INTO lmv_bright.landuse_terrang
    SELECT
    gid+10000000,
    the_geom,
    CASE
        WHEN kategori like 'Sankmark%' THEN 'swamp'
        WHEN kategori = 'Berg i dagen' THEN 'mountain'
        ELSE 'other' END as type
    FROM terrang_ms;
