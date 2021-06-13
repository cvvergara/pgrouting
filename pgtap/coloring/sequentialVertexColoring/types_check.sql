\i setup.sql

UPDATE edge_table SET cost = sign(cost), reverse_cost = sign(reverse_cost);
SELECT plan(5);

CREATE OR REPLACE FUNCTION types_check()
RETURNS SETOF TEXT AS
$BODY$
BEGIN

IF is_version_2() OR NOT test_min_version('3.2.0') THEN
  RETURN QUERY
  SELECT skip(5, 'Function is new on 3.2.0');
  RETURN;
END IF;

RETURN QUERY
SELECT has_function('pgr_sequentialvertexcoloring');

RETURN QUERY
SELECT has_function('pgr_sequentialvertexcoloring', ARRAY['text']);
RETURN QUERY
SELECT function_returns('pgr_sequentialvertexcoloring', ARRAY['text'],  'setof record');

-- pgr_sequentialvertexcoloring
-- parameter names
RETURN QUERY
SELECT bag_has(
    $$SELECT  proargnames from pg_proc where proname = 'pgr_sequentialvertexcoloring'$$,
    $$SELECT  '{"","vertex_id","color_id"}'::TEXT[] $$
);

-- parameter types
RETURN QUERY
SELECT set_eq(
    $$SELECT  proallargtypes from pg_proc where proname = 'pgr_sequentialvertexcoloring'$$,
    $$VALUES
        ('{25,20,20}'::OID[])
    $$
);
END;
$BODY$
LANGUAGE plpgsql;

SELECT types_check();

SELECT * FROM finish();
ROLLBACK;
