\i setup.sql

UPDATE edge_table SET cost = sign(cost), reverse_cost = sign(reverse_cost);
SELECT plan(432);

CREATE OR REPLACE FUNCTION inner_query()
RETURNS SETOF TEXT AS
$BODY$
BEGIN

IF is_version_2() THEN
  RETURN QUERY
  SELECT skip(432, 'Function is new on 3.0.0');
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
