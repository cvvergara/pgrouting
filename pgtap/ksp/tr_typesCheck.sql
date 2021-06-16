\i setup.sql

UPDATE edge_table SET cost = sign(cost), reverse_cost = sign(reverse_cost);
SELECT plan(4);

CREATE or REPLACE FUNCTION types_check()
RETURNS SETOF TEXT AS
$BODY$
BEGIN
  IF is_version_2() THEN
    RETURN QUERY
    SELECT skip (4, 'pgr_turnrestrictedpath was added on 3.0.0');
    RETURN;
  END IF;

-------------------------------------------------------------

RETURN QUERY
SELECT has_function('pgr_turnrestrictedpath');

RETURN QUERY
SELECT has_function('pgr_turnrestrictedpath',
    ARRAY[ 'text', 'text', 'bigint', 'bigint', 'integer', 'boolean', 'boolean', 'boolean', 'boolean']
);

RETURN QUERY
SELECT function_returns('pgr_turnrestrictedpath',
    ARRAY[ 'text', 'text', 'bigint', 'bigint', 'integer', 'boolean', 'boolean', 'boolean', 'boolean'],
    'setof record');

-- testing column names
RETURN QUERY
SELECT set_eq(
    $$SELECT  proargnames from pg_proc where proname = 'pgr_turnrestrictedpath'$$,
    $$SELECT  '{"","","","","","directed","heap_paths","stop_on_first","strict","seq","path_id","path_seq","node","edge","cost","agg_cost"}'::TEXT[] $$
);

END
$BODY$
language plpgsql;

SELECT types_check();
SELECT finish();
ROLLBACK;
