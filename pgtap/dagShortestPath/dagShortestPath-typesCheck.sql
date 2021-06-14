
UPDATE edge_table SET cost = sign(cost), reverse_cost = sign(reverse_cost);
SELECT plan(15);

SELECT has_function('pgr_dagshortestpath');

SELECT has_function('pgr_dagshortestpath', ARRAY[ 'text', 'bigint', 'bigint' ]);
SELECT has_function('pgr_dagshortestpath', ARRAY[ 'text', 'anyarray', 'bigint' ]);
SELECT has_function('pgr_dagshortestpath', ARRAY[ 'text', 'bigint', 'anyarray' ]);
SELECT has_function('pgr_dagshortestpath', ARRAY[ 'text', 'anyarray', 'anyarray' ]);

SELECT function_returns('pgr_dagshortestpath', ARRAY[ 'text', 'bigint', 'bigint' ], 'setof record');
SELECT function_returns('pgr_dagshortestpath', ARRAY[ 'text', 'anyarray', 'bigint' ], 'setof record');
SELECT function_returns('pgr_dagshortestpath', ARRAY[ 'text', 'bigint', 'anyarray' ], 'setof record');
SELECT function_returns('pgr_dagshortestpath', ARRAY[ 'text', 'anyarray', 'anyarray' ], 'setof record');

-- testing column names
SELECT bag_has(
    $$SELECT  proargnames from pg_proc where proname = 'pgr_dagshortestpath'$$,
    $$SELECT  '{"","","","seq","path_seq","node","edge","cost","agg_cost"}'::TEXT[] $$
);

-- parameter types
SELECT set_eq(
    $$SELECT  proallargtypes from pg_proc where proname = 'pgr_dagshortestpath'$$,
    $$VALUES
        ('{25,20,20,23,23,20,20,701,701}'::OID[]),
        ('{25,20,2277,23,23,20,20,701,701}'::OID[]),
        ('{25,2277,20,23,23,20,20,701,701}'::OID[]),
        ('{25,2277,2277,23,23,20,20,701,701}'::OID[])
    $$
);

-- new signature on 3.2
SELECT CASE
WHEN is_version_2() OR NOT test_min_version('3.2.0') THEN
  skip(4, 'Combinations functiontionality new on 2.3')
WHEN test_min_version('3.2.0') THEN
  collect_tap(
    has_function('pgr_dagshortestpath', ARRAY['text','text']),
    function_returns('pgr_dagshortestpath', ARRAY['text','text'], 'setof record'),
    bag_has(
      $$SELECT  proargnames from pg_proc where proname = 'pgr_dagshortestpath'$$,
      $$SELECT  '{}"","",seq,path_seq,node,edge,cost,agg_cost'::TEXT[] $$
    ),
    set_eq(
      $$SELECT  proallargtypes from pg_proc where proname = 'pgr_dagshortestpath'$$,
      $$VALUES ('{25,25,23,23,20,20,701,701}'::OID[]) $$
    )
  )
END;
