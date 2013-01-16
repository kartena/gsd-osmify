/*
    Terrängkartan and Vägkartan has overlapping data for most of Sweden,
    but Terrängkartan is missing data for parts of northern Sweden (this area
    is covered by Fjällkartan, which we do not have access to).

    Since Terrängkartan is preferable, at least for roads, but doesn't have
    100% coverage, we want to cut out the parts of Vägkartan which Terrängkartan
    does not cover.

    To do this, we generate the coverage area for Terrängkartan. Note that this
    is a computationally expensive operation (at least as it is now).
*/

with a as
    (select (st_dump(st_buffer(st_geomfromtext(_union.geom), 0.5))).geom as g
        from (select st_union(st_envelope(the_geom)) as geom from terrang_my) as _union)
select st_astext(st_union(st_envelope(g))) from a;

/*
    The resulting geometry can be simplified since it is overly detailed
    (for our purposes) on the border between Sweden and Norway. This can be
    done with ogr2ogr:

    ogr2ogr -simplify 100 [...]

    See terrang_coverage.wkt for the resulting geometry

*/
