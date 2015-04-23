alter table terrang_hl drop constraint enforce_srid_the_geom;

update terrang_hl set the_geom=st_setsrid(the_geom,3006);

ALTER TABLE terrang_hl
  ADD CONSTRAINT enforce_srid_the_geom CHECK (st_srid(the_geom) = (3006));
