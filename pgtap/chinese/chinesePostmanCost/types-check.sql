\i setup.sql

UPDATE edge_table SET cost = sign(cost), reverse_cost = sign(reverse_cost);
SELECT CASE WHEN is_version_2() THEN plan(1) ELSE plan(6) END;

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
SELECT has_function('pgr_chinesepostmancost');

RETURN QUERY
SELECT has_function('pgr_chinesepostmancost',    ARRAY['text']);

RETURN QUERY
SELECT function_returns('pgr_chinesepostmancost', ARRAY['text'], 'double precision');

RETURN QUERY
SELECT set_eq(
    $$SELECT  proargnames from pg_proc where proname = 'pgr_chinesepostmancost'$$,
    $$SELECT  NULL::TEXT[] $$
);

RETURN QUERY
SELECT set_eq(
    $$SELECT  prorettype from pg_proc where proname = 'pgr_chinesepostmancost'$$,
    $$SELECT  701 $$
);

RETURN QUERY
SELECT set_eq(
    $$SELECT  proargtypes from pg_proc where proname = 'pgr_chinesepostmancost'$$,
    $$SELECT  '[0:0]={25}'::OID[] $$
);

END;
$BODY$
LANGUAGE plpgsql;

SELECT types_check();


SELECT * FROM finish();
ROLLBACK;
