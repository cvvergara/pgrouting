
\i setup.sql

UPDATE edge_table SET cost = sign(cost), reverse_cost = sign(reverse_cost);
SELECT CASE WHEN is_version_2() THEN plan(1) ELSE plan(4) END;

CREATE OR REPLACE FUNCTION types_check()
RETURNS SETOF TEXT AS
$BODY$
BEGIN
  IF is_version_2() THEN
    RETURN QUERY
    SELECT skip(1, 'Function changed name on 3.0.0');
    RETURN;
  END IF;

RETURN QUERY
SELECT has_function('pgr_pickdeliver',
    ARRAY['text','text', 'text', 'double precision', 'integer', 'integer']);
RETURN QUERY
SELECT function_returns('_pgr_pickdeliver',
    ARRAY['text','text', 'text', 'double precision', 'integer', 'integer'],
    'setof record');

-- testing column names
RETURN QUERY
SELECT set_eq(
    $$SELECT  proargnames from pg_proc where proname = 'pgr_pickdeliver'$$,
    $$SELECT  '{"","","","factor","max_cycles","initial_sol","seq","vehicle_seq","vehicle_id","stop_seq","stop_type","stop_id","order_id","cargo",
    "travel_time","arrival_time","wait_time","service_time","departure_time"}'::TEXT[] $$
);

-- parameter types
RETURN QUERY
SELECT set_eq(
    $$SELECT  proallargtypes from pg_proc where proname = 'pgr_pickdeliver'$$,
    $$SELECT  '{25,25,25,701,23,23,23,23,20,23,23,20,20,701,701,701,701,701,701}'::OID[] $$
);

END
$BODY$
LANGUAGE plpgsql VOLATILE;

SELECT types_check();
SELECT finish();
ROLLBACK;
