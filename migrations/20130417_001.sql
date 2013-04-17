/*
	Populate geometry_columns for lmv_bright tables. Mainly to speed up working
	with QGIS.
*/

SELECT Populate_Geometry_Columns('lmv_bright.area_labels'::regclass);
SELECT Populate_Geometry_Columns('lmv_bright.landuse_oversikt'::regclass);
SELECT Populate_Geometry_Columns('lmv_bright.landuse_tatort'::regclass);
SELECT Populate_Geometry_Columns('lmv_bright.landuse_terrang'::regclass);
SELECT Populate_Geometry_Columns('lmv_bright.motorway_label'::regclass);
SELECT Populate_Geometry_Columns('lmv_bright.place'::regclass);
SELECT Populate_Geometry_Columns('lmv_bright.railway'::regclass);
SELECT Populate_Geometry_Columns('lmv_bright.railway_tatort'::regclass);
SELECT Populate_Geometry_Columns('lmv_bright.roads_tatort'::regclass);
