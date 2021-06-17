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
    SELECT skip (5, 'pgr_kruskal is new on 3.0.0');
    RETURN;
  END IF;

----------------------------------
-- tests for all
-- prefix:  pgr_kruskal
----------------------------------

RETURN QUERY
SELECT has_function('pgr_kruskal');
RETURN QUERY
SELECT has_function('pgr_kruskal',    ARRAY['text']);
RETURN QUERY
SELECT function_returns('pgr_kruskal', ARRAY['text'], 'setof record');

-- pgr_kruskal
-- parameter names
RETURN QUERY
SELECT set_eq(
    $$SELECT  proargnames from pg_proc where proname = 'pgr_kruskal'$$,
    $$SELECT  '{"","edge","cost"}'::TEXT[] $$
);

-- parameter types
RETURN QUERY
SELECT set_eq(
    $$SELECT  proallargtypes from pg_proc where proname = 'pgr_kruskal'$$,
    $$SELECT  '{25,20,701}'::OID[] $$
);

END
$BODY$
LANGUAGE plpgsql VOLATILE;

SELECT types_check();

SELECT finish();
ROLLBACK;
