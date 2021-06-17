
\i setup.sql

UPDATE edge_table SET cost = sign(cost), reverse_cost = sign(reverse_cost);
SELECT plan(5);

CREATE OR REPLACE FUNCTION types_check()
RETURNS SETOF TEXT AS
$BODY$
BEGIN

IF is_version_2() THEN
  RETURN QUERY
  SELECT skip(5, 'Function is new on 3.0.0');
  RETURN;
END IF;


RETURN QUERY
SELECT has_function('pgr_full_version');
RETURN QUERY
SELECT has_function('pgr_full_version', ARRAY[]::text[]);
RETURN QUERY
SELECT function_returns('pgr_full_version', ARRAY[]::text[], 'record');

RETURN QUERY
SELECT set_eq(
    $$SELECT  proargnames from pg_proc where proname = 'pgr_full_version'$$,
    $$SELECT  '{"version","build_type","compile_date","library","system","postgresql","compiler","boost","hash"}'::TEXT[] $$
);

-- parameter types
RETURN QUERY
SELECT set_eq(
    $$SELECT  proallargtypes from pg_proc where proname = 'pgr_full_version'$$,
    $$SELECT  '{25,25,25,25,25,25,25,25,25}'::OID[] $$
);

END;
$BODY$
LANGUAGE plpgsql;

SELECT types_check();

SELECT finish();
ROLLBACK;
