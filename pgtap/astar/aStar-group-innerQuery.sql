\i setup.sql

UPDATE edge_table SET cost = sign(cost), reverse_cost = sign(reverse_cost);
SELECT plan(418);


SELECT has_function('pgr_astar',
    ARRAY['text', 'bigint', 'bigint', 'boolean', 'integer', 'double precision', 'double precision']);
SELECT has_function('pgr_astar',
    ARRAY['text', 'bigint', 'anyarray', 'boolean', 'integer', 'double precision', 'double precision']);
SELECT has_function('pgr_astar',
    ARRAY['text', 'anyarray', 'bigint', 'boolean', 'integer', 'double precision', 'double precision']);
SELECT has_function('pgr_astar',
    ARRAY['text', 'anyarray', 'anyarray', 'boolean', 'integer', 'double precision', 'double precision']);

SELECT function_returns('pgr_astar',
    ARRAY['text', 'bigint', 'bigint', 'boolean', 'integer', 'double precision', 'double precision'],
    'setof record');
SELECT function_returns('pgr_astar',
    ARRAY['text', 'bigint', 'anyarray', 'boolean', 'integer', 'double precision', 'double precision'],
    'setof record');
SELECT function_returns('pgr_astar',
    ARRAY['text', 'anyarray', 'bigint', 'boolean', 'integer', 'double precision', 'double precision'],
    'setof record');
SELECT function_returns('pgr_astar',
    ARRAY['text', 'anyarray', 'anyarray', 'boolean', 'integer', 'double precision', 'double precision'],
    'setof record');

-- new function on 3.2
SELECT CASE
WHEN is_version_2() THEN
  skip(2, 'Not testing tsp on version 2.x.y (2.6)')
WHEN test_min_version('3.2.0') THEN
  collect_tap(
    has_function('pgr_astar', ARRAY['text', 'text', 'boolean', 'integer', 'double precision', 'double precision']),
    function_returns('pgr_astar', ARRAY['text', 'text', 'boolean', 'integer', 'double precision', 'double precision'], 'setof record')
  )
ELSE skip(2, 'Signature included on version 3.2')
END;


-- ONE TO ONE
SELECT style_astar('pgr_astar', ', 2, 3, true)');
-- ONE TO MANY
SELECT style_astar('pgr_astar', ', 2, ARRAY[3], true)');
-- MANY TO ONE
SELECT style_astar('pgr_astar', ', ARRAY[2], 3, true)');
-- MANY TO MANY
SELECT style_astar('pgr_astar', ', ARRAY[2], ARRAY[3], true)');


SELECT finish();
ROLLBACK;
