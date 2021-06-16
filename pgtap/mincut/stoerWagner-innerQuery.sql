\i setup.sql

UPDATE edge_table SET cost = sign(cost), reverse_cost = sign(reverse_cost);
SELECT plan(56);


CREATE OR REPLACE FUNCTION inner_query()
RETURNS SETOF TEXT AS
$BODY$
DECLARE
BEGIN
  IF is_version_2() THEN
    RETURN QUERY
    SELECT skip (56, 'pgr_stoerWagner is new on 3.0.0');
    RETURN;
  END IF;

RETURN QUERY
SELECT has_function('pgr_stoerwagner');

RETURN QUERY
SELECT function_returns('pgr_stoerwagner', ARRAY['text'], 'setof record');

RETURN QUERY
SELECT style_dijkstra('pgr_stoerwagner', ')');
END
$BODY$
LANGUAGE plpgsql VOLATILE;


SELECT inner_query();
SELECT finish();
ROLLBACK;
