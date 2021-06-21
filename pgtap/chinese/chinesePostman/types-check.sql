\i setup.sql

UPDATE edge_table SET cost = sign(cost), reverse_cost = sign(reverse_cost);
SELECT CASE WHEN is_version_2() THEN plan(1) ELSE plan(5) END;


CREATE OR REPLACE FUNCTION types_check()
RETURNS SETOF TEXT AS
$BODY$
BEGIN

IF is_version_2() THEN
  RETURN QUERY
  SELECT skip(1, 'Function is new on 3.0.0');
  RETURN;
END IF;

RETURN QUERY
SELECT has_function('pgr_chinesepostman');

RETURN QUERY
SELECT has_function('pgr_chinesepostman',    ARRAY['text']);

RETURN QUERY
SELECT function_returns('pgr_chinesepostman', ARRAY['text'], 'setof record');

RETURN QUERY
SELECT set_eq(
    $$SELECT proargnames from pg_proc where proname = 'pgr_chinesepostman'$$,
    $$SELECT '{"", "seq", "node", "edge", "cost", "agg_cost"}'::TEXT[] $$
);

RETURN QUERY
SELECT set_eq(
    $$SELECT  proallargtypes from pg_proc where proname = 'pgr_chinesepostman'$$,
    $$SELECT  '{25,23,20,20,701,701}'::OID[] $$
);

END;
$BODY$
LANGUAGE plpgsql;

SELECT types_check();

SELECT * FROM finish();
ROLLBACK;
