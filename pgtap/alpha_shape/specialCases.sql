\i setup.sql

UPDATE edge_table SET cost = sign(cost), reverse_cost = sign(reverse_cost);
SELECT plan(2);

CREATE OR REPLACE FUNCTION special_cases()
RETURNS SETOF TEXT AS
$BODY$
BEGIN

IF is_version_2() THEN
  RETURN QUERY
  SELECT skip(2, 'Function changed signature on 3.0.0');
  RETURN;
END IF;

-- duplicated points are removed
PREPARE q1 AS
SELECT ST_Area(pgr_alphaShape(
    (SELECT ST_Collect(the_geom) FROM edge_table_vertices_pgr)
));

PREPARE q2 AS
SELECT ST_Area(pgr_alphaShape(
    (WITH data AS (
        SELECT the_geom FROM edge_table_vertices_pgr
        UNION ALL
        SELECT the_geom FROM edge_table_vertices_pgr)
      SELECT  ST_Collect(the_geom) FROM data)
));


-- Ordering does not affect the result
PREPARE q3 AS
SELECT ST_Area(pgr_alphaShape(
    (SELECT ST_Collect(the_geom) FROM edge_table)
));

RETURN QUERY
SELECT set_eq('q1', 'q3');
RETURN QUERY
SELECT set_eq('q1', 'q2');

END;
$BODY$
LANGUAGE plpgsql;

SELECT special_cases();


SELECT finish();
ROLLBACK;
