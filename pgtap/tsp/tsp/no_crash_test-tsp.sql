\i setup.sql

UPDATE edge_table SET cost = sign(cost), reverse_cost = sign(reverse_cost);
SELECT plan(9);

CREATE TEMP TABLE  matrix_rows AS
SELECT * FROM pgr_dijkstraCostMatrix(
    $$SELECT id, source, target, cost, reverse_cost FROM edge_table$$,
    (SELECT array_agg(id) FROM edge_table_vertices_pgr WHERE id < 14),
    directed := false
);

SELECT isnt_empty('SELECT * FROM matrix_rows', 'Should not be empty true to tests be meaningful');
SELECT * FROM tsp_no_crash();

SELECT finish();
ROLLBACK;
