\i setup.sql

UPDATE edge_table SET cost = sign(cost), reverse_cost = sign(reverse_cost);
SELECT plan(5);

CREATE OR REPLACE FUNCTION types_check()
RETURNS SETOF TEXT AS
$BODY$
BEGIN
  IF is_version_2() THEN
    RETURN QUERY
    SELECT skip (5, 'pgr_extractvertices is new on 3.0.0');
    RETURN;
  END IF;

RETURN QUERY
SELECT has_function('pgr_extractvertices');
RETURN QUERY
SELECT has_function('pgr_extractvertices',    ARRAY['text', 'boolean']);
RETURN QUERY
SELECT function_returns('pgr_extractvertices', ARRAY['text', 'boolean'], 'setof record');

-- parameter names
RETURN QUERY
SELECT set_eq(
    $$SELECT  proargnames from pg_proc where proname = 'pgr_extractvertices'$$,
    $$SELECT  '{"","dryrun","id","in_edges","out_edges","x","y","geom"}'::TEXT[] $$
);

PREPARE fn_types AS
SELECT ARRAY[25,16,20,1016,1016,701,701,oid] FROM pg_type WHERE typname = 'geometry';

-- parameter types
RETURN QUERY
SELECT set_eq(
    $$SELECT  proallargtypes from pg_proc where proname = 'pgr_extractvertices'$$,
    $$fn_types$$
);

END
$BODY$
LANGUAGE plpgsql VOLATILE;

SELECT types_check();

SELECT * FROM finish();
ROLLBACK;
