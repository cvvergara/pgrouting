
\i setup.sql

SELECT plan(5);
SET client_min_messages TO WARNING;

SELECT has_function('pgr_tsp');
SELECT has_function('pgr_tsp', ARRAY[
    'text', 'bigint', 'bigint',
    'double precision',
    'integer', 'integer', 'integer',
    'double precision',
    'double precision',
    'double precision',
    'boolean'
    ]);
SELECT function_returns('pgr_tsp', ARRAY[
    'text', 'bigint', 'bigint',
    'double precision',
    'integer', 'integer', 'integer',
    'double precision',
    'double precision',
    'double precision',
    'boolean'
    ], 'setof record');

PREPARE parameters AS
SELECT array[
'',
'start_id','end_id','max_processing_time',
'tries_per_temperature',
'max_changes_per_temperature',
'max_consecutive_non_changes',
'initial_temperature',
'final_temperature',
'cooling_factor',
'randomize',
'seq',
'node',
'cost',
'agg_cost'];

SELECT bag_has(
    $$SELECT proargnames FROM pg_proc WHERE proname = 'pgr_tsp'$$,
    'parameters');

SELECT set_eq(
    $$SELECT  proallargtypes from pg_proc where proname = 'pgr_tsp'$$,
    $$VALUES
        ('{25,20,20,701,23,23,23,701,701,701,16,23,20,701,701}'::OID[])
    $$
);

SELECT finish();
