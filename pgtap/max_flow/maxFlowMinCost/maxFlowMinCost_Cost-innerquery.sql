\i setup.sql

UPDATE edge_table SET cost = sign(cost), reverse_cost = sign(reverse_cost);
SELECT plan(586);


SELECT has_function('pgr_maxflowmincost_cost',
    ARRAY['text', 'bigint', 'bigint']);
SELECT has_function('pgr_maxflowmincost_cost',
    ARRAY['text', 'bigint', 'anyarray']);
SELECT has_function('pgr_maxflowmincost_cost',
    ARRAY['text', 'anyarray', 'bigint']);
SELECT has_function('pgr_maxflowmincost_cost',
    ARRAY['text', 'anyarray', 'anyarray']);

SELECT function_returns('pgr_maxflowmincost_cost',
    ARRAY['text', 'bigint', 'bigint'],
    'double precision');
SELECT function_returns('pgr_maxflowmincost_cost',
    ARRAY['text', 'bigint', 'anyarray'],
    'double precision');
SELECT function_returns('pgr_maxflowmincost_cost',
    ARRAY['text', 'anyarray', 'bigint'],
    'double precision');
SELECT function_returns('pgr_maxflowmincost_cost',
    ARRAY['text', 'anyarray', 'anyarray'],
    'double precision');

-- new signature on 3.2
SELECT CASE
WHEN is_version_2() OR NOT test_min_version('3.2.0') THEN
  skip(2, 'Combinations functiontionality new on 2.3')
WHEN test_min_version('3.2.0') THEN
  collect_tap(
    has_function('pgr_maxflowmincost_cost', ARRAY['text', 'text']),
    function_returns('pgr_maxflowmincost_cost', ARRAY['text', 'text'], 'double precision')
  )
END;

-- ONLY WORKS ON DIRECTED GRAPH
SELECT style_cost_flow('pgr_maxflowmincost_cost', ', 2, 3)');
SELECT style_cost_flow('pgr_maxflowmincost_cost', ', 2, ARRAY[3])');
SELECT style_cost_flow('pgr_maxflowmincost_cost', ', ARRAY[2], 3)');
SELECT style_cost_flow('pgr_maxflowmincost_cost', ', ARRAY[2], ARRAY[3])');

SELECT finish();
ROLLBACK;
