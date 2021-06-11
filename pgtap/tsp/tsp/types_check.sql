\i setup.sql
UPDATE edge_table SET cost = sign(cost), reverse_cost = sign(reverse_cost);

CREATE OR REPLACE FUNCTION tsp_3_3()
RETURNS SETOF TEXT AS
$BODY$
BEGIN

  RETURN QUERY
  SELECT has_function('pgr_tsp', ARRAY['text', 'bigint', 'bigint']);

  RETURN QUERY
  SELECT function_returns('pgr_tsp', ARRAY['text', 'bigint', 'bigint'], 'setof record');

  PREPARE parameters AS
  SELECT array['','start_id','end_id','seq','node','cost','agg_cost'];

  RETURN QUERY
  SELECT bag_has(
    $$SELECT proargnames FROM pg_proc WHERE proname = 'pgr_tsp'$$,
    'parameters');

  RETURN QUERY
  SELECT set_eq(
    $$SELECT  proallargtypes from pg_proc where proname = 'pgr_tsp'$$,
    $$VALUES
    ('{25,20,20,23,20,701,701}'::OID[])
    $$
  );
END;
$BODY$
LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION tsp_3_0_to_3_2()
RETURNS SETOF TEXT AS
$BODY$
BEGIN

  RETURN QUERY
  SELECT has_function('pgr_tsp', ARRAY[
    'text', 'bigint', 'bigint',
    'double precision',
    'integer', 'integer', 'integer',
    'double precision',
    'double precision',
    'double precision',
    'boolean'
    ]);

  RETURN QUERY
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

  RETURN QUERY
  SELECT bag_has(
    $$SELECT proargnames FROM pg_proc WHERE proname = 'pgr_tsp'$$,
    'parameters');

  RETURN QUERY
  SELECT set_eq(
    $$SELECT  proallargtypes from pg_proc where proname = 'pgr_tsp'$$,
    $$VALUES
    ('{25,20,20,701,23,23,23,701,701,701,16,23,20,701,701}'::OID[])
    $$
  );
END;
$BODY$
LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION tsp_types_check()
RETURNS SETOF TEXT AS
$BODY$
BEGIN
  IF is_version_2() THEN
    RETURN QUERY
    SELECT skip(4, 'Not testing tsp on version 2.x.y (2.6)');
    RETURN;
  END IF;

  IF test_min_version('3.3.0') THEN
    RETURN QUERY
    SELECT tsp_3_3();
  ELSE
    RETURN QUERY
    SELECT tsp_3_0_to_3_2();
  END IF;
END;
$BODY$
LANGUAGE plpgsql;


SELECT plan(5);
SELECT has_function('pgr_tsp');
SELECT tsp_types_check();


SELECT finish();
