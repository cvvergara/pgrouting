\i setup.sql

UPDATE edge_table SET cost = sign(cost), reverse_cost = sign(reverse_cost);
SELECT plan(18);
SET client_min_messages TO ERROR;


SELECT has_function('pgr_edwardmoore');


SELECT has_function('pgr_edwardmoore', ARRAY['text','bigint','bigint','boolean']);
SELECT has_function('pgr_edwardmoore', ARRAY['text','bigint','anyarray','boolean']);
SELECT has_function('pgr_edwardmoore', ARRAY['text','anyarray','bigint','boolean']);
SELECT has_function('pgr_edwardmoore', ARRAY['text','anyarray','anyarray','boolean']);
SELECT function_returns('pgr_edwardmoore', ARRAY['text','bigint','bigint','boolean'],  'setof record');
SELECT function_returns('pgr_edwardmoore', ARRAY['text','bigint','anyarray','boolean'],  'setof record');
SELECT function_returns('pgr_edwardmoore', ARRAY['text','anyarray','bigint','boolean'],  'setof record');
SELECT function_returns('pgr_edwardmoore', ARRAY['text','anyarray','anyarray','boolean'],  'setof record');

-- pgr_edwardmoore
-- parameter names
SELECT set_has(
    $$SELECT  proargnames from pg_proc where proname = 'pgr_edwardmoore'$$,
    $$SELECT  '{"","","","directed","seq","path_seq","node","edge","cost","agg_cost"}'::TEXT[] $$
);

SELECT set_has(
    $$SELECT  proargnames from pg_proc where proname = 'pgr_edwardmoore'$$,
    $$SELECT  '{"","","","directed","seq","path_seq","start_vid","node","edge","cost","agg_cost"}'::TEXT[] $$
);

SELECT set_has(
    $$SELECT  proargnames from pg_proc where proname = 'pgr_edwardmoore'$$,
    $$SELECT  '{"","","","directed","seq","path_seq","end_vid","node","edge","cost","agg_cost"}'::TEXT[] $$
);

SELECT set_has(
    $$SELECT  proargnames from pg_proc where proname = 'pgr_edwardmoore'$$,
    $$SELECT  '{"","","","directed","seq","path_seq","start_vid","end_vid","node","edge","cost","agg_cost"}'::TEXT[] $$
);


-- parameter types
SELECT set_has(
    $$SELECT  proallargtypes from pg_proc where proname = 'pgr_edwardmoore'$$,
    $$VALUES
        ('{25,20,20,16,23,23,20,20,701,701}'::OID[]),
        ('{25,20,2277,16,23,23,20,20,20,701,701}'::OID[]),
        ('{25,2277,20,16,23,23,20,20,20,701,701}'::OID[]),
        ('{25,2277,2277,16,23,23,20,20,20,20,701,701}'::OID[])
    $$
);

-- new signature on 3.2
SELECT CASE
WHEN is_version_2() OR NOT test_min_version('3.2.0') THEN
  skip(3, 'Combinations functiontionality new on 2.3')
WHEN test_min_version('3.2.0') THEN
  collect_tap(
    has_function('pgr_edwardmoore', ARRAY['text','text','boolean']),
    function_returns('pgr_edwardmoore', ARRAY['text','text','boolean'], 'setof record'),
    set_has(
      $$SELECT  proargnames from pg_proc where proname = 'pgr_edwardmoore'$$,
      $$SELECT  '{"","",directed,seq,path_seq,start_vid,end_vid,node,edge,cost,agg_cost}'::TEXT[] $$
    ),
 set_has(
    $$SELECT  proallargtypes from pg_proc where proname = 'pgr_edwardmoore'$$,
    $$VALUES ('{25,25,16,23,23,20,20,20,20,701,701}'::OID[]) $$
  )
)
END;

SELECT * FROM finish();
ROLLBACK;
