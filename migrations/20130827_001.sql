create table lmv_bright.waterway_tatort (
    gid int primary key,
    type varchar(16)
);

select AddGeometryColumn('lmv_bright', 'waterway_tatort', 'the_geom', 3006, 'MULTILINESTRING', 2);

create table lmv_bright.tatort_coverage (
	gid int primary key
);

select AddGeometryColumn('lmv_bright', 'tatort_coverage', 'the_geom', 3006, 'POLYGON', 2);

insert into lmv_bright.tatort_coverage
	select row_number() over(), st_setsrid(the_geom, 3006)
	from (
		select (st_dump(st_union(the_geom))).geom the_geom
		from (select the_geom from tatort_my) t_my
		) as u;

create index on lmv_bright.tatort_coverage using gist (the_geom);

insert into lmv_bright.waterway_tatort
	select gid,
		case
		when kategori IN ('Vattendrag, kartografisk klass 3') THEN 'canal'
		when kategori IN ('Vattendrag, kartografisk klass 2') THEN 'stream'
		when kategori IN ('Vattendrag, kartografisk klass 1') THEN 'ditch'
		else 'other' end AS type,
		the_geom
	from (
		select row_number() over () gid, terrang_hl.kategori, 
			ST_CollectionExtract(st_multi(st_intersection(terrang_hl.the_geom, tatort_coverage.the_geom)), 2) the_geom
		from terrang_hl
		inner join lmv_bright.tatort_coverage on st_intersects(terrang_hl.the_geom, tatort_coverage.the_geom)
	) as waterways
	where not st_isempty(the_geom);

create index on lmv_bright.waterway_tatort (type);
create index on lmv_bright.waterway_tatort using gist (the_geom);
