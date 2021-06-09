
\i setup.sql

UPDATE edge_table SET cost = sign(cost), reverse_cost = sign(reverse_cost);
SELECT plan(9);
SET client_min_messages TO WARNING;

CREATE TEMP TABLE coords AS
SELECT id, ST_X(the_geom) AS x, ST_Y(the_geom) AS y
FROM edge_table_vertices_pgr;


SELECT CASE
  -- starting from 3.3.0 anaeling parameters are ignored
  WHEN test_min_version('3.3.0') THEN
    collect_tap(
 lives_ok($$
    SELECT * FROM pgr_TSPeuclidean('SELECT id, x, y FROM coords',
        max_processing_time := -4,
        randomize := false)$$,
    '1 SHOULD live because max_processing_time is ignored'),

 lives_ok($$
    SELECT * FROM pgr_TSPeuclidean('SELECT id, x, y FROM coords',
        tries_per_temperature := -4,
        randomize := false)$$,
    '2 SHOULD live because tries_per_temperature is ignored'),

 lives_ok($$
    SELECT * FROM pgr_TSPeuclidean('SELECT id, x, y FROM coords',
        max_changes_per_temperature := -4,
        randomize := false)$$,
    '3 SHOULD live because max_changes_per_temperature is ignored'),

 lives_ok($$
    SELECT * FROM pgr_TSPeuclidean('SELECT id, x, y FROM coords',
        max_consecutive_non_changes := -4,
        randomize := false)$$,
    '4 SHOULD live because max_consecutive_non_changes is ignored'),

 lives_ok($$
    SELECT * FROM pgr_TSPeuclidean('SELECT id, x, y FROM coords',
        cooling_factor := 0,
        randomize := false)$$,
    '5 SHOULD live because cooling_factor is ignored'),

 lives_ok($$
    SELECT * FROM pgr_TSPeuclidean('SELECT id, x, y FROM coords',
        cooling_factor := 1,
        randomize := false)$$,
    '6 SHOULD live because cooling_factor is ignored'),

 lives_ok($$
    SELECT * FROM pgr_TSPeuclidean('SELECT id, x, y FROM coords',
        initial_temperature := 0,
        randomize := false)$$,
    '7 SHOULD live because initial_temperature is ignored'),

 lives_ok($$
    SELECT * FROM pgr_TSPeuclidean('SELECT id, x, y FROM coords',
        final_temperature := 101,
        randomize := false)$$,
    '8 SHOULD live because final_temperature is ignored'),

 lives_ok($$
    SELECT * FROM pgr_TSPeuclidean('SELECT id, x, y FROM coords',
        final_temperature := 0,
        randomize := false)$$,
    '9 SHOULD live because final_temperature is ignored')
    )
  ELSE
    collect_tap(
 throws_ok($$
    SELECT * FROM pgr_TSPeuclidean('SELECT id, x, y FROM coords',
        max_processing_time := -4,
        randomize := false)$$,
    'XX000',
    'Condition not met: max_processing_time >= 0',
    '1 SHOULD throw because max_processing_time has illegal value'),

 throws_ok($$
    SELECT * FROM pgr_TSPeuclidean('SELECT id, x, y FROM coords',
        tries_per_temperature := -4,
        randomize := false)$$,
    'XX000',
    'Condition not met: tries_per_temperature >= 0',
    '2 SHOULD throw because tries_per_temperature has illegal value'),

 throws_ok($$
    SELECT * FROM pgr_TSPeuclidean('SELECT id, x, y FROM coords',
        max_changes_per_temperature := -4,
        randomize := false)$$,
    'XX000',
    'Condition not met: max_changes_per_temperature > 0',
    '3 SHOULD throw because max_changes_per_temperature has illegal value'),

 throws_ok($$
    SELECT * FROM pgr_TSPeuclidean('SELECT id, x, y FROM coords',
        max_consecutive_non_changes := -4,
        randomize := false)$$,
    'XX000',
    'Condition not met: max_consecutive_non_changes > 0',
    '4 SHOULD throw because max_consecutive_non_changes has illegal value'),

 throws_ok($$
    SELECT * FROM pgr_TSPeuclidean('SELECT id, x, y FROM coords',
        cooling_factor := 0,
        randomize := false)$$,
    'XX000',
    'Condition not met: 0 < cooling_factor < 1',
    '5 SHOULD throw because cooling_factor has illegal value'),

 throws_ok($$
    SELECT * FROM pgr_TSPeuclidean('SELECT id, x, y FROM coords',
        cooling_factor := 1,
        randomize := false)$$,
    'XX000',
    'Condition not met: 0 < cooling_factor < 1',
    '6 SHOULD throw because cooling_factor has illegal value'),

 throws_ok($$
    SELECT * FROM pgr_TSPeuclidean('SELECT id, x, y FROM coords',
        initial_temperature := 0,
        randomize := false)$$,
    'XX000',
    'Condition not met: initial_temperature > final_temperature',
    '7 SHOULD throw because initial_temperature has illegal value'),

 throws_ok($$
    SELECT * FROM pgr_TSPeuclidean('SELECT id, x, y FROM coords',
        final_temperature := 101,
        randomize := false)$$,
    'XX000',
    'Condition not met: initial_temperature > final_temperature',
    '8 SHOULD throw because final_temperature has illegal value'),

 throws_ok($$
    SELECT * FROM pgr_TSPeuclidean('SELECT id, x, y FROM coords',
        final_temperature := 0,
        randomize := false)$$,
    'XX000',
    'Condition not met: final_temperature > 0',
    ' 9 SHOULD throw because final_temperature has illegal value')
  )
  END;



SELECT finish();
ROLLBACK;
