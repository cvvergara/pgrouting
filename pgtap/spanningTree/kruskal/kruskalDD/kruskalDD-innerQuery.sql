\i setup.sql

UPDATE edge_table SET cost = sign(cost), reverse_cost = sign(reverse_cost);
SELECT plan(54);

CREATE OR REPLACE FUNCTION inner_query()
RETURNS SETOF TEXT AS
$BODY$
DECLARE
BEGIN
  IF is_version_2() THEN
    RETURN QUERY
    SELECT skip (54, 'pgr_kruskalDD is new on 3.0.0');
    RETURN;
  END IF;

SELECT style_dijkstra('pgr_kruskalDD', ', 5, 3.5)');
END
$BODY$
LANGUAGE plpgsql VOLATILE;

SELECT inner_query();

SELECT finish();
ROLLBACK;
