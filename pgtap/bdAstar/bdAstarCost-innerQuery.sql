\i setup.sql

UPDATE edge_table SET cost = sign(cost), reverse_cost = sign(reverse_cost);
SELECT plan(418);


SELECT has_function('pgr_bdastarcost', ARRAY['text', 'bigint', 'bigint', 'boolean', 'integer', 'numeric', 'numeric']);
SELECT has_function('pgr_bdastarcost', ARRAY['text', 'bigint', 'anyarray', 'boolean', 'integer', 'numeric', 'numeric']);
SELECT has_function('pgr_bdastarcost', ARRAY['text', 'anyarray', 'bigint', 'boolean', 'integer', 'numeric', 'numeric']);
SELECT has_function('pgr_bdastarcost', ARRAY['text', 'anyarray', 'anyarray', 'boolean', 'integer', 'numeric', 'numeric']);

SELECT function_returns('pgr_bdastarcost', ARRAY['text', 'bigint', 'bigint', 'boolean', 'integer', 'numeric', 'numeric'],
    'setof record');
SELECT function_returns('pgr_bdastarcost', ARRAY['text', 'bigint', 'anyarray', 'boolean', 'integer', 'numeric', 'numeric'],
    'setof record');
SELECT function_returns('pgr_bdastarcost', ARRAY['text', 'anyarray', 'bigint', 'boolean', 'integer', 'numeric', 'numeric'],
    'setof record');
SELECT function_returns('pgr_bdastarcost', ARRAY['text', 'anyarray', 'anyarray', 'boolean', 'integer', 'numeric', 'numeric'],
    'setof record');

-- new signature on 3.2
SELECT CASE
WHEN is_version_2() OR NOT test_min_version('3.2.0') THEN
  skip(2, 'Combinations functiontionality new on 3.2.0')
WHEN test_min_version('3.2.0') THEN
  collect_tap(
    has_function('pgr_bdastarcost', ARRAY['text', 'text', 'boolean', 'integer', 'numeric', 'numeric']),
    function_returns('pgr_bdastarcost', ARRAY['text', 'text', 'boolean', 'integer', 'numeric', 'numeric'], 'setof record')
  )
END;

SELECT style_astar('pgr_bdastarcost', ', 2, 3, true)');
SELECT style_astar('pgr_bdastarcost', ', 2, ARRAY[3], true)');
SELECT style_astar('pgr_bdastarcost', ', ARRAY[2], 3, true)');
SELECT style_astar('pgr_bdastarcost', ', ARRAY[2], ARRAY[3], true)');

SELECT finish();
ROLLBACK;
