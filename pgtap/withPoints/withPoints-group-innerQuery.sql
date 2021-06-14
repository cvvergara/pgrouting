\i setup.sql

UPDATE edge_table SET cost = sign(cost), reverse_cost = sign(reverse_cost);
SELECT plan(658);
SET client_min_messages TO ERROR;


SELECT has_function('pgr_withpoints',
    ARRAY['text', 'text', 'bigint', 'bigint', 'boolean','character', 'boolean']);
SELECT has_function('pgr_withpoints',
    ARRAY['text', 'text', 'bigint', 'anyarray', 'boolean','character', 'boolean']);
SELECT has_function('pgr_withpoints',
    ARRAY['text', 'text', 'anyarray', 'bigint', 'boolean','character', 'boolean']);
SELECT has_function('pgr_withpoints',
    ARRAY['text', 'text', 'anyarray', 'anyarray', 'boolean','character', 'boolean']);

SELECT function_returns('pgr_withpoints',
    ARRAY['text', 'text', 'bigint', 'bigint', 'boolean','character', 'boolean'],
    'setof record');
SELECT function_returns('pgr_withpoints',
    ARRAY['text', 'text', 'bigint', 'anyarray', 'boolean','character', 'boolean'],
    'setof record');
SELECT function_returns('pgr_withpoints',
    ARRAY['text', 'text', 'anyarray', 'bigint', 'boolean','character', 'boolean'],
    'setof record');
SELECT function_returns('pgr_withpoints',
    ARRAY['text', 'text', 'anyarray', 'anyarray', 'boolean','character', 'boolean'],
    'setof record');

-- new signature on 3.2
SELECT CASE
WHEN is_version_2() OR NOT test_min_version('3.2.0') THEN
  skip(2, 'Combinations functiontionality new on 2.3')
WHEN test_min_version('3.2.0') THEN
  collect_tap(
    has_function('pgr_withpoints', ARRAY['text', 'text', 'text', 'boolean','character', 'boolean']),
    function_returns('pgr_withpoints', ARRAY['text', 'text', 'text', 'boolean','character', 'boolean'], 'setof record')
  )
END;

-- DIRECTED
SELECT style_withpoints('pgr_withpoints', ', 2, 3)');
SELECT style_withpoints('pgr_withpoints', ', 2, ARRAY[3])');
SELECT style_withpoints('pgr_withpoints', ', ARRAY[2], 3)');
SELECT style_withpoints('pgr_withpoints', ', ARRAY[2], ARRAY[3])');
SELECT style_withpoints('pgr_withpoints', ', 2, 3, true)');
SELECT style_withpoints('pgr_withpoints', ', 2, ARRAY[3], true)');
SELECT style_withpoints('pgr_withpoints', ', ARRAY[2], 3, true)');
SELECT style_withpoints('pgr_withpoints', ', ARRAY[2], ARRAY[3], true)');
-- UNDIRECTED
SELECT style_withpoints('pgr_withpoints', ', 2, 3, false)');
SELECT style_withpoints('pgr_withpoints', ', 2, ARRAY[3], false)');
SELECT style_withpoints('pgr_withpoints', ', ARRAY[2], 3, false)');
SELECT style_withpoints('pgr_withpoints', ', ARRAY[2], ARRAY[3], false)');



SELECT finish();
ROLLBACK;
