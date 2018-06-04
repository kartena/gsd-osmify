insert into lmv_bright.admin
    select gid,
        CASE 
        WHEN kategori = 'Kommungräns' THEN 'municipality'
        WHEN kategori = 'Länsgräns' THEN 'county'
        END as type,
        the_geom
    from vagk_al where kategori in ('Kommungräns', 'Länsgräns');

