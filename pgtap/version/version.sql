
\i setup.sql

UPDATE edge_table SET cost = sign(cost), reverse_cost = sign(reverse_cost);
SELECT plan(5);


SELECT has_function('pgr_version');
SELECT has_function('pgr_version', ARRAY[]::text[]);

CREATE OR REPLACE FUNCTION types_check()
RETURNS SETOF TEXT AS
$BODY$
BEGIN

IF is_version_2() THEN
  RETURN QUERY
  SELECT skip(3, 'Function changed signature on 3.0.0');
  RETURN;
END IF;


RETURN QUERY
SELECT function_returns('pgr_version', ARRAY[]::text[], 'text');

RETURN QUERY
SELECT set_eq(
    $$SELECT  proargnames from pg_proc where proname = 'pgr_version'$$,
    $$SELECT  NULL::TEXT[] $$
);

RETURN QUERY
SELECT set_eq(
    $$SELECT  proallargtypes from pg_proc where proname = 'pgr_version'$$,
    $$SELECT  NULL::OID[] $$
);

END;
$BODY$
LANGUAGE plpgsql;

SELECT types_check();

SELECT finish();
ROLLBACK;
