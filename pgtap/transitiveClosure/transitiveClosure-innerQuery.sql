\i setup.sql

UPDATE edge_table SET cost = sign(cost), reverse_cost = sign(reverse_cost);
SELECT plan(2);


CREATE OR REPLACE FUNCTION inner_query()
RETURNS SETOF TEXT AS
$BODY$
DECLARE
params TEXT[];
subs TEXT[];
BEGIN
  IF is_version_2() OR NOT test_min_version('3.0.0') THEN
    RETURN QUERY
    SELECT skip(2, 'Function is new on 3.0.0');
    RETURN;
  END IF;

  RETURN QUERY
  SELECT has_function('pgr_transitiveclosure');

  RETURN QUERY
  SELECT function_returns('pgr_transitiveclosure',ARRAY['text'],'setof record');
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

SELECT inner_query();

SELECT finish();
ROLLBACK;
