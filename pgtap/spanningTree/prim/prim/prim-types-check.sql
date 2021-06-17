\i setup.sql

UPDATE edge_table SET cost = sign(cost), reverse_cost = sign(reverse_cost);
SELECT plan(5);

CREATE OR REPLACE FUNCTION types_check()
RETURNS SETOF TEXT AS
$BODY$
DECLARE
BEGIN
  IF is_version_2() THEN
    RETURN QUERY
    SELECT skip (5, 'pgr_prim is new on 3.0.0');
    RETURN;
  END IF;


RETURN QUERY
SELECT has_function('pgr_prim');
RETURN QUERY
SELECT has_function('pgr_prim',    ARRAY['text']);
RETURN QUERY
SELECT function_returns('pgr_prim', ARRAY['text'], 'setof record');

RETURN QUERY
SELECT set_eq(
    $$SELECT  proargnames from pg_proc where proname = 'pgr_prim'$$,
    $$SELECT  '{"","edge","cost"}'::TEXT[] $$
);

RETURN QUERY
SELECT set_eq(
    $$SELECT  proallargtypes from pg_proc where proname = 'pgr_prim'$$,
    $$SELECT  '{25,20,701}'::OID[] $$
);

END
$BODY$
LANGUAGE plpgsql VOLATILE;

SELECT types_check();

SELECT * FROM finish();
ROLLBACK;
