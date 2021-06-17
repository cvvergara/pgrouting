\i setup.sql

UPDATE edge_table SET cost = sign(cost), reverse_cost = sign(reverse_cost);
SELECT plan(2);

CREATE OR REPLACE FUNCTION types_check()
RETURNS SETOF TEXT AS
$BODY$
DECLARE
BEGIN
  IF is_version_2() THEN
    RETURN QUERY
    SELECT skip (2, 'pgr_topologicalsort is new on 3.0.0');
    RETURN;
  END IF;

  RETURN QUERY
  SELECT has_function('pgr_topologicalsort');

  RETURN QUERY
SELECT function_returns('pgr_topologicalsort',ARRAY['text'],'setof record');

END
$BODY$
LANGUAGE plpgsql VOLATILE;

SELECT types_check();
SELECT finish();
ROLLBACK;
