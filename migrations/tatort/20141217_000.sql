/* Create lmv_bright.poi from building names in
   tatort_by. */

CREATE TABLE "lmv_bright"."poi" (
    gid int primary key,
    name varchar(45),
    type varchar(26),
    the_geom geometry(Point, 3006),
    municipality varchar(4)
);
CREATE INDEX ON lmv_bright.poi USING GIST (the_geom);

/* Remove duplicates. Lots of nearby buildings share the
   same name. Buildings with huvudbyggn='J' should have
   priority, but when there's no huvudbyggnad, or more than
   one, we choose the largest one. */

/* Insert all buildings with names into a temporary table */
create temp table named_buildings (
    gid int,
    name varchar(45),
    type varchar(26),
    huvudbyggn varchar(1),
    the_geom geometry
);

create index on named_buildings (name, huvudbyggn);
create index on named_buildings using gist (the_geom);

insert into named_buildings (gid, name, type, huvudbyggn, the_geom)
    select b1.ogc_fid, b1.namn1,
    case
    when andamal_1t in ('Samhällsfunktion; Sjukhus') then 'hospital'
    when andamal_1t in ('Samhällsfunktion; Skola') then 'school'
    when andamal_1t in ('Samhällsfunktion; Universitet') then 'university'
    when andamal_1t in ('Samhällsfunktion; Högskola') then 'university'
    when andamal_1t in ('Samhällsfunktion; Samfund') then 'religous'
    else 'other'
    end, b1.huvudbyggn, b1.the_geom
    from public.tatort_by b1
    where b1.namn1!='';

select count(*) from named_buildings;

/* Find all duplicates and delete them */
delete from named_buildings where gid in (
    select p2.gid
    from named_buildings p1
    inner join named_buildings p2 
        on p1.gid!=p2.gid /* don't do < or other smart things, has to be by priority */
        and st_distance(p1.the_geom, p2.the_geom) < 1000
        and p1.name!='' and p2.name!='' and p1.name=p2.name
        and ((p1.huvudbyggn='J' and p2.huvudbyggn='') OR (p1.huvudbyggn=p2.huvudbyggn and st_area(p1.the_geom) > st_area(p2.the_geom)))
);

insert into lmv_bright.poi (gid, name, type, the_geom)
    select gid, name, type, st_centroid(the_geom) from named_buildings;
