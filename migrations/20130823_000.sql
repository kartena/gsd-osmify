create table lmv_bright.waterway_low (
    gid int primary key,
    type varchar(16)
);

select AddGeometryColumn('lmv_bright', 'waterway_low', 'the_geom', 3006, 'MULTILINESTRING', 2);

insert into lmv_bright.waterway_low
	select gid,
		case
		when width >= 6 then 'river'
		when width >= 4 then 'canal'
		when width >= 2 then 'stream'
		else 'ditch' end as type,
		ST_SetSRID(the_geom, 3006)
	from (
		select gid, (80 - (kkod % 100)) / 10 as width, the_geom
		from oversikt_hl
		where kkod >= 9110
		) as oversikt_hl_width;

insert into lmv_bright.waterway_low
	select gid,
	'canal' as type,
		ST_SetSRID(the_geom, 3006)
	from oversikt_hl
		where kkod in (9021, 9022);

create index on lmv_bright.place (type);
create index on lmv_bright.waterway_low using gist (the_geom);
