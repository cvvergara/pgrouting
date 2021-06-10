\i setup.sql

UPDATE edge_table SET cost = sign(cost), reverse_cost = sign(reverse_cost);
SELECT plan(9);
SET client_min_messages TO WARNING;

CREATE TEMP TABLE matrixrows AS
SELECT * FROM pgr_dijkstraCostMatrix(
    $$SELECT id, source, target, cost, reverse_cost FROM edge_table$$,
    (SELECT array_agg(id) FROM edge_table_vertices_pgr WHERE ID < 14),
    directed:= false
);

SELECT CASE
  -- starting from 3.3.0 anaeling parameters are ignored
  WHEN test_min_version('3.3.0') THEN
    collect_tap(
      lives_ok($$
        SELECT * FROM pgr_TSP('SELECT start_vid, end_vid, agg_cost FROM matrixrows',
          max_processing_time := -4,
          randomize := false)$$,
        'SHOULD live because max_processing_time is ignored'),

      lives_ok($$
        SELECT * FROM pgr_TSP('SELECT start_vid, end_vid, agg_cost FROM matrixrows',
          tries_per_temperature := -4,
          randomize := false)$$,
        'SHOULD live because tries_per_temperature is ignored'),

      lives_ok($$
        SELECT * FROM pgr_TSP('SELECT start_vid, end_vid, agg_cost FROM matrixrows',
          max_changes_per_temperature := -4,
          randomize := false)$$,
        'SHOULD live because max_changes_per_temperature is ignored'),

      lives_ok($$
        SELECT * FROM pgr_TSP('SELECT start_vid, end_vid, agg_cost FROM matrixrows',
          max_consecutive_non_changes := -4,
          randomize := false)$$,
        'SHOULD live because max_consecutive_non_changes is ignored'),

      lives_ok($$
        SELECT * FROM pgr_TSP('SELECT start_vid, end_vid, agg_cost FROM matrixrows',
          cooling_factor := 0,
          randomize := false)$$,
        'SHOULD live because cooling_factor is ignored'),

      lives_ok($$
        SELECT * FROM pgr_TSP('SELECT start_vid, end_vid, agg_cost FROM matrixrows',
          cooling_factor := 1,
          randomize := false)$$,
        'SHOULD live because cooling_factor is ignored'),

      lives_ok($$
        SELECT * FROM pgr_TSP('SELECT start_vid, end_vid, agg_cost FROM matrixrows',
          initial_temperature := 0,
          randomize := false)$$,
        'SHOULD live because initial_temperature is ignored'),

      lives_ok($$
        SELECT * FROM pgr_TSP('SELECT start_vid, end_vid, agg_cost FROM matrixrows',
          final_temperature := 101,
          randomize := false)$$,
        'SHOULD live because final_temperature is ignored'),

      lives_ok($$
        SELECT * FROM pgr_TSP('SELECT start_vid, end_vid, agg_cost FROM matrixrows',
          final_temperature := 0,
          randomize := false)$$,
        'SHOULD live because final_temperature is ignored')
    )
  ELSE
    collect_tap(
      throws_ok($$
        SELECT * FROM pgr_TSP('SELECT start_vid, end_vid, agg_cost FROM matrixrows',
          max_processing_time := -4,
          randomize := false)$$,
        'XX000',
        'Condition not met: max_processing_time >= 0',
        'SHOULD throw because max_processing_time has illegal value'),

      throws_ok($$
        SELECT * FROM pgr_TSP('SELECT start_vid, end_vid, agg_cost FROM matrixrows',
          tries_per_temperature := -4,
          randomize := false)$$,
        'XX000',
        'Condition not met: tries_per_temperature >= 0',
        'SHOULD throw because tries_per_temperature has illegal value'),

      throws_ok($$
        SELECT * FROM pgr_TSP('SELECT start_vid, end_vid, agg_cost FROM matrixrows',
          max_changes_per_temperature := -4,
          randomize := false)$$,
        'XX000',
        'Condition not met: max_changes_per_temperature > 0',
        'SHOULD throw because max_changes_per_temperature has illegal value'),

      throws_ok($$
        SELECT * FROM pgr_TSP('SELECT start_vid, end_vid, agg_cost FROM matrixrows',
          max_consecutive_non_changes := -4,
          randomize := false)$$,
        'XX000',
        'Condition not met: max_consecutive_non_changes > 0',
        'SHOULD throw because max_consecutive_non_changes has illegal value'),

      throws_ok($$
        SELECT * FROM pgr_TSP('SELECT start_vid, end_vid, agg_cost FROM matrixrows',
          cooling_factor := 0,
          randomize := false)$$,
        'XX000',
        'Condition not met: 0 < cooling_factor < 1',
        'SHOULD throw because cooling_factor has illegal value'),

      throws_ok($$
        SELECT * FROM pgr_TSP('SELECT start_vid, end_vid, agg_cost FROM matrixrows',
          cooling_factor := 1,
          randomize := false)$$,
        'XX000',
        'Condition not met: 0 < cooling_factor < 1',
        'SHOULD throw because cooling_factor has illegal value'),

      throws_ok($$
        SELECT * FROM pgr_TSP('SELECT start_vid, end_vid, agg_cost FROM matrixrows',
          initial_temperature := 0,
          randomize := false)$$,
        'XX000',
        'Condition not met: initial_temperature > final_temperature',
        'SHOULD throw because initial_temperature has illegal value'),

      throws_ok($$
        SELECT * FROM pgr_TSP('SELECT start_vid, end_vid, agg_cost FROM matrixrows',
          final_temperature := 101,
          randomize := false)$$,
        'XX000',
        'Condition not met: initial_temperature > final_temperature',
        'SHOULD throw because final_temperature has illegal value'),

      throws_ok($$
        SELECT * FROM pgr_TSP('SELECT start_vid, end_vid, agg_cost FROM matrixrows',
          final_temperature := 0,
          randomize := false)$$,
        'XX000',
        'Condition not met: final_temperature > 0',
        'SHOULD throw because final_temperature has illegal value')
    )
END;

SELECT finish();
ROLLBACK;
