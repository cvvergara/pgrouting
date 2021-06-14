\i setup.sql

UPDATE edge_table SET cost = sign(cost), reverse_cost = sign(reverse_cost);
SELECT plan(658);

SELECT has_function('pgr_bddijkstra', ARRAY['text', 'bigint', 'bigint', 'boolean']);
SELECT has_function('pgr_bddijkstra', ARRAY['text', 'bigint', 'anyarray', 'boolean']);
SELECT has_function('pgr_bddijkstra', ARRAY['text', 'anyarray', 'bigint', 'boolean']);
SELECT has_function('pgr_bddijkstra', ARRAY['text', 'anyarray', 'anyarray', 'boolean']);

SELECT function_returns('pgr_bddijkstra', ARRAY['text', 'bigint', 'bigint', 'boolean'],
    'setof record');
SELECT function_returns('pgr_bddijkstra', ARRAY['text', 'bigint', 'anyarray', 'boolean'],
    'setof record');
SELECT function_returns('pgr_bddijkstra', ARRAY['text', 'anyarray', 'bigint', 'boolean'],
    'setof record');
SELECT function_returns('pgr_bddijkstra', ARRAY['text', 'anyarray', 'anyarray', 'boolean'],
    'setof record');

-- new signature on 3.2
SELECT CASE
WHEN is_version_2() OR NOT test_min_version('3.2.0') THEN
  skip(2, 'Combinations functiontionality new on 2.3')
WHEN test_min_version('3.2.0') THEN
  collect_tap(
    has_function('pgr_bddijkstra', ARRAY['text', 'text', 'boolean']),
    function_returns('pgr_bddijkstra', ARRAY['text', 'text', 'boolean'], 'setof record')
  )
END;


SELECT style_dijkstra('pgr_bddijkstra', ', 2, 3, true)');
SELECT style_dijkstra('pgr_bddijkstra', ', 2, ARRAY[3], true)');
SELECT style_dijkstra('pgr_bddijkstra', ',  2, ARRAY[3], true)');
SELECT style_dijkstra('pgr_bddijkstra', ',  ARRAY[2], ARRAY[3], true)');

SELECT style_dijkstra('pgr_bddijkstra', ', 2, 3)');
SELECT style_dijkstra('pgr_bddijkstra', ', 2, ARRAY[3])');
SELECT style_dijkstra('pgr_bddijkstra', ',  2, ARRAY[3])');
SELECT style_dijkstra('pgr_bddijkstra', ',  ARRAY[2], ARRAY[3])');

SELECT style_dijkstra('pgr_bddijkstra', ', 2, 3, false)');
SELECT style_dijkstra('pgr_bddijkstra', ', 2, ARRAY[3], false)');
SELECT style_dijkstra('pgr_bddijkstra', ',  2, ARRAY[3], false)');
SELECT style_dijkstra('pgr_bddijkstra', ',  ARRAY[2], ARRAY[3], false)');

SELECT finish();
ROLLBACK;
