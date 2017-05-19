
SELECT plan(4);

SELECT has_function('pgr_vidhandijkstra');

SELECT has_function('pgr_vidhandijkstra', ARRAY[ 'text', 'bigint', 'bigint', 'boolean', 'boolean' ]);

SELECT function_returns('pgr_vidhandijkstra', ARRAY[ 'text', 'bigint', 'bigint', 'boolean', 'boolean' ], 'setof record');

-- testing column names
SELECT bag_has(
    $$SELECT  proargnames from pg_proc where proname = 'pgr_vidhandijkstra'$$,
    $$SELECT  '{"","","","directed","only_cost","seq","path_seq","node","edge","cost","agg_cost"}'::TEXT[] $$
);

