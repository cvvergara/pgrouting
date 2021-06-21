\i setup.sql

UPDATE edge_table SET cost = sign(cost), reverse_cost = sign(reverse_cost);
SELECT CASE WHEN is_version_2() THEN plan(1) ELSE plan(432) END;

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
SELECT style_dijkstra('pgr_breadthFirstSearch', ', 5)');

RETURN QUERY
SELECT style_dijkstra('pgr_breadthFirstSearch', ', 5, 2)');

RETURN QUERY
SELECT style_dijkstra('pgr_breadthFirstSearch', ', ARRAY[3,5])');

RETURN QUERY
SELECT style_dijkstra('pgr_breadthFirstSearch', ', ARRAY[3,5], 2)');

RETURN QUERY
SELECT style_dijkstra('pgr_breadthFirstSearch', ', 5, directed := true)');

RETURN QUERY
SELECT style_dijkstra('pgr_breadthFirstSearch', ', 5, 2, directed := true)');

RETURN QUERY
SELECT style_dijkstra('pgr_breadthFirstSearch', ', ARRAY[3,5], directed := true)');

RETURN QUERY
SELECT style_dijkstra('pgr_breadthFirstSearch', ', ARRAY[3,5],2, directed := true)');

END;
$BODY$
LANGUAGE plpgsql;

SELECT inner_query();

SELECT finish();
ROLLBACK;
