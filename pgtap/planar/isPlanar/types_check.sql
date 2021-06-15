\i setup.sql

UPDATE edge_table SET cost = sign(cost), reverse_cost = sign(reverse_cost);
SELECT plan(4);

CREATE OR REPLACE FUNCTION types_check()
RETURNS SETOF TEXT AS
$BODY$
BEGIN

IF is_version_2() OR NOT test_min_version('3.2.0') THEN
  RETURN QUERY
  SELECT skip(4, 'Function is new on 3.2.0');
  RETURN;
END IF;

-- 0 edge, 0 vertex tests
RETURN QUERY
SELECT has_function('pgr_isplanar');

RETURN QUERY
SELECT function_returns('pgr_isplanar', ARRAY['text'], 'boolean');

RETURN QUERY
SELECT bag_has(
    $$SELECT  proargnames from pg_proc where proname = 'pgr_isplanar'$$,
    $$SELECT  NULL::TEXT[] $$
);

RETURN QUERY
SELECT bag_has(
    $$SELECT  prorettype from pg_proc where proname = 'pgr_isplanar'$$,
    $$VALUES ( '16'::oid )$$
);

END;
$BODY$
LANGUAGE plpgsql;

SELECT types_check();

SELECT * FROM finish();
ROLLBACK;
