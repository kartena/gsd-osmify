CREATE TABLE "lmv_bright"."poi" (
    gid int primary key,
    name varchar(45),
    type varchar(26),
    the_geom geometry(Point, 3006),
    municipality varchar(4)
);
CREATE INDEX ON lmv_bright.poi USING GIST (the_geom);

-- CREATE OR REPLACE FUNCTION SP_CreateLmPoi() RETURNS void AS $$
-- DECLARE last_name varchar;
--     distance float;
--     list_count int;
-- 
--     -- the cursor will contain all the poi names which are not empty and 
--     -- will be ordered by name
--     cur_iterator CURSOR FOR
--                 SELECT
--                     bf.gid AS gid,
--                     bf.namn1 AS name,
--                     bf.funktion1 AS funktion1,
--                     ST_Centroid(bf.the_geom) AS the_geom,
--                     bf.kommunkod AS kommunkod
--                 FROM tatort_bf AS bf
--                 WHERE bf.namn1 IS NOT NULL
--                 ORDER BY bf.namn1, bf.kommunkod;
-- 
-- BEGIN
--     RAISE NOTICE 'Beginning';
--         last_name := '';
--         FOR it IN cur_iterator LOOP
--             -- If the name is a new one
--             IF it.name != last_name THEN
--                 /*
--                     1) Save the information from the list to the final table
--                     2) Clean the list (to start over)
--                     3) Insert the first new point to the list
--                 */
--                 INSERT INTO lmv_bright.poi
--                 SELECT l.gid, l.name, l.type, ST_PointFromText(ST_AsText(l.the_geom), 3006), l.municipality
--                 FROM list l;
--                 DELETE FROM list;
-- 
--                 --Inserting the new point to the list
--                 INSERT INTO list(gid, name, type, the_geom, municipality)
--                     VALUES (it.gid, it.name, it.funktion1, it.the_geom, it.kommunkod);
--             ELSE -- If the name is repeated
--                 /*
--                     1) If the list has any value in it:
--                     1.1) Get the Min distance between the current point and all the points in the list
--                     1.2) If the min value is more than a threshold (150 meters) => add it to the list
--                     1.3) If the min value is less than the threshold => skip it
--                     2) If the list is empty => add the new point to the list
-- 
--                 */
--                 SELECT COUNT(*) INTO list_count FROM list;
--                 IF list_count > 0 THEN
--                     SELECT MIN(ST_Distance(it.the_geom, l.the_geom)) INTO distance FROM list l;
--                     -- RAISE NOTICE 'Distance: %f', distance;
--                     IF distance > 150 THEN
--                         RAISE NOTICE 'Inserting %s', it.name;
--                         INSERT INTO list(gid, name, type, the_geom, municipality)
--                         VALUES (it.gid, it.name, it.funktion1, it.the_geom, it.kommunkod);
--                     END IF;
--                 ELSE
--                     RAISE NOTICE 'Inserting %s', it.name;
--                     INSERT INTO list(gid, name, type, the_geom, municipality)
--                         VALUES (it.gid, it.name, it.funktion1, it.the_geom, it.kommunkod);
--                 END IF;
--             END IF;
--             last_name := it.name;
--             -- RAISE NOTICE 'Iterator name: %s', it.name;
--         END LOOP;
--         SELECT COUNT(*) INTO list_count FROM list;
--         IF list_count > 0 THEN
--             RAISE NOTICE 'Inserting %s', last_name;
--             INSERT INTO lmv_bright.poi
--             SELECT l.gid, l.name, l.type, ST_PointFromText(ST_AsText(l.the_geom), 3006), l.municipality
--             FROM list l;
--             DELETE FROM list;
--         END IF;
-- END
-- $$ LANGUAGE plpgsql;
