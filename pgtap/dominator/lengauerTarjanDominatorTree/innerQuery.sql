\i setup.sql

UPDATE edge_table SET cost = sign(cost), reverse_cost = sign(reverse_cost);
SELECT plan(54);


CREATE OR REPLACE FUNCTION inner_query()
RETURNS SETOF TEXT AS
$BODY$
BEGIN

IF is_version_2() OR NOT test_min_version('3.2.0') THEN
  RETURN QUERY
  SELECT skip(54, 'Function is new on 3.2.0');
  RETURN;
END IF;

SELECT style_dijkstra('pgr_lengauerTarjanDominatorTree', ',1)');

END;
$BODY$
LANGUAGE plpgsql;

SELECT inner_query();

SELECT finish();
ROLLBACK;
