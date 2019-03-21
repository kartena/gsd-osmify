/*
	Add geometry type constraints for all lmv_bright tables. Mainly to speed up working
	with QGIS.
*/

ALTER TABLE lmv_bright.area_labels
  ADD CONSTRAINT enforce_geotype_the_geom CHECK (geometrytype(the_geom) = 'POINT'::text);

ALTER TABLE lmv_bright.buildings
  ADD CONSTRAINT enforce_geotype_the_geom CHECK (geometrytype(the_geom) = 'POLYGON'::text);

ALTER TABLE lmv_bright.landuse_oversikt
  ADD CONSTRAINT enforce_geotype_the_geom CHECK (geometrytype(the_geom) = 'MULTIPOLYGON'::text);

ALTER TABLE lmv_bright.landuse_tatort
  ADD CONSTRAINT enforce_geotype_the_geom CHECK (geometrytype(the_geom) = 'POLYGON'::text);

ALTER TABLE lmv_bright.landuse_terrang
  ADD CONSTRAINT enforce_geotype_the_geom CHECK (geometrytype(the_geom) = 'MULTIPOLYGON'::text);

ALTER TABLE lmv_bright.motorway_label
  ADD CONSTRAINT enforce_geotype_the_geom CHECK (geometrytype(the_geom) = 'POINT'::text);

ALTER TABLE lmv_bright.place
  ADD CONSTRAINT enforce_geotype_the_geom CHECK (geometrytype(the_geom) = 'POINT'::text);

ALTER TABLE lmv_bright.railway
  ADD CONSTRAINT enforce_geotype_the_geom CHECK (geometrytype(the_geom) = 'MULTILINESTRING'::text);

ALTER TABLE lmv_bright.railway_tatort
  ADD CONSTRAINT enforce_geotype_the_geom CHECK (geometrytype(the_geom) = 'LINESTRING'::text);

ALTER TABLE lmv_bright.road_label
  ADD CONSTRAINT enforce_geotype_the_geom CHECK (geometrytype(the_geom) = 'MULTILINESTRING'::text);

ALTER TABLE lmv_bright.roads_tatort
  ADD CONSTRAINT enforce_geotype_the_geom CHECK (geometrytype(the_geom) = 'LINESTRING'::text);
/*

ALTER TABLE lmv_bright.terrang_coverage_simple
  ADD CONSTRAINT enforce_geotype_the_geom CHECK (geometrytype(the_geom) = 'MULTIPOLYGON'::text);

ALTER TABLE lmv_bright.inre_norrland_roads
  ADD CONSTRAINT enforce_geotype_the_geom CHECK (geometrytype(the_geom) = 'MULTILINESTRING'::text);

ALTER TABLE lmv_bright.roads
  ADD CONSTRAINT enforce_geotype_the_geom CHECK (geometrytype(the_geom) = 'MULTILINESTRING'::text);
*/
