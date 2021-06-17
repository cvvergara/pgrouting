\i setup.sql

UPDATE edge_table SET cost = sign(cost), reverse_cost = sign(reverse_cost);
SELECT plan(11);

CREATE OR REPLACE FUNCTION types_check()
RETURNS SETOF TEXT AS
$BODY$
DECLARE
BEGIN
  IF is_version_2() THEN
    RETURN QUERY
    SELECT skip (11, 'pgr_primDD is new on 3.0.0');
    RETURN;
  END IF;

RETURN QUERY
SELECT has_function('pgr_primdd');

RETURN QUERY
SELECT has_function('pgr_primdd',  ARRAY['text','bigint','numeric']);
RETURN QUERY
SELECT has_function('pgr_primdd',  ARRAY['text','anyarray','numeric']);
RETURN QUERY
SELECT has_function('pgr_primdd',  ARRAY['text','bigint','double precision']);
RETURN QUERY
SELECT has_function('pgr_primdd',  ARRAY['text','anyarray','double precision']);
RETURN QUERY
SELECT function_returns('pgr_primdd',  ARRAY['text','bigint','numeric'],  'setof record');
RETURN QUERY
SELECT function_returns('pgr_primdd',  ARRAY['text','anyarray','numeric'],  'setof record');
RETURN QUERY
SELECT function_returns('pgr_primdd',  ARRAY['text','bigint','double precision'],  'setof record');
RETURN QUERY
SELECT function_returns('pgr_primdd',  ARRAY['text','anyarray','double precision'],  'setof record');


-- parameter names
RETURN QUERY
SELECT set_eq(
    $$SELECT  proargnames from pg_proc where proname = 'pgr_primdd'$$,
    $$VALUES
        ('{"","","","seq","depth","start_vid","node","edge","cost","agg_cost"}'::TEXT[])
    $$
);

-- parameter types
RETURN QUERY
SELECT set_eq(
    $$SELECT  proallargtypes from pg_proc where proname = 'pgr_primdd'$$,
    $$VALUES
        ('{25,20,701,20,20,20,20,20,701,701}'::OID[]),
        ('{25,2277,701,20,20,20,20,20,701,701}'::OID[]),
        ('{25,20,1700,20,20,20,20,20,701,701}'::OID[]),
        ('{25,2277,1700,20,20,20,20,20,701,701}'::OID[]),
        ('{25,20,701,20,20,20,20,20,701,701}'::OID[]),
        ('{25,2277,701,20,20,20,20,20,701,701}'::OID[])
    $$
);

END
$BODY$
LANGUAGE plpgsql VOLATILE;

SELECT types_check();

SELECT finish();
ROLLBACK;
