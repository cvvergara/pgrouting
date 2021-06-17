\i setup.sql

UPDATE edge_table SET cost = sign(cost), reverse_cost = sign(reverse_cost);
SELECT plan(7);

CREATE OR REPLACE FUNCTION types_check()
RETURNS SETOF TEXT AS
$BODY$
DECLARE
BEGIN
  IF is_version_2() THEN
    RETURN QUERY
    SELECT skip (7, 'pgr_primBFS is new on 3.0.0');
    RETURN;
  END IF;


RETURN QUERY
SELECT has_function('pgr_primbfs');

RETURN QUERY
SELECT has_function('pgr_primbfs', ARRAY['text','bigint','bigint']);
RETURN QUERY
SELECT has_function('pgr_primbfs', ARRAY['text','anyarray','bigint']);
RETURN QUERY
SELECT function_returns('pgr_primbfs', ARRAY['text','bigint','bigint'],  'setof record');
RETURN QUERY
SELECT function_returns('pgr_primbfs', ARRAY['text','anyarray','bigint'],  'setof record');

-- parameter names
RETURN QUERY
SELECT set_eq(
    $$SELECT  proargnames from pg_proc where proname = 'pgr_primbfs'$$,
    $$VALUES
        ('{"","","max_depth","seq","depth","start_vid","node","edge","cost","agg_cost"}'::TEXT[])
    $$
);

-- parameter types
RETURN QUERY
SELECT set_eq(
    $$SELECT  proallargtypes from pg_proc where proname = 'pgr_primbfs'$$,
    $$VALUES
        ('{25,20,20,20,20,20,20,20,701,701}'::OID[]),
        ('{25,2277,20,20,20,20,20,20,701,701}'::OID[])
    $$
);

END
$BODY$
LANGUAGE plpgsql VOLATILE;

SELECT types_check();
SELECT * FROM finish();
ROLLBACK;
