\i setup.sql

UPDATE edge_table SET cost = sign(cost), reverse_cost = sign(reverse_cost);
SELECT CASE WHEN is_version_2() THEN plan(1) ELSE plan(378) END;

CREATE OR REPLACE FUNCTION inner_query()
RETURNS SETOF TEXT AS
$BODY$
BEGIN

IF is_version_2() THEN
  RETURN QUERY
  SELECT skip(1, 'Function is new on 3.0.0');
  RETURN;
END IF;


RETURN QUERY
SELECT style_dijkstra('pgr_bellmanFord', ', 2, 3)');

RETURN QUERY
SELECT style_dijkstra('pgr_bellmanFord', ', 2, 3, true)');

RETURN QUERY
SELECT style_dijkstra('pgr_bellmanFord', ', 2, 3, false)');

-- ONE TO ONE
RETURN QUERY
SELECT style_dijkstra('pgr_bellmanFord', ', 2, 3, true)');

-- ONE TO MANY
RETURN QUERY
SELECT style_dijkstra('pgr_bellmanFord', ', 2, ARRAY[3], true)');

-- MANY TO ONE
RETURN QUERY
SELECT style_dijkstra('pgr_bellmanFord', ', ARRAY[2], 3, true)');

-- MANY TO MANY
RETURN QUERY
SELECT style_dijkstra('pgr_bellmanFord', ', ARRAY[2], ARRAY[3], true)');

END;
$BODY$
LANGUAGE plpgsql;

SELECT inner_query();

SELECT finish();
ROLLBACK;
