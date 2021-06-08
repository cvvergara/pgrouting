SET log_min_duration_statement=-1;
SET extra_float_digits=-3;

\echo -- q1
SELECT * FROM pgr_TSPeuclidean(
    $$
    SELECT id, st_X(the_geom) AS x, st_Y(the_geom)AS y  FROM edge_table_vertices_pgr
    $$,
    randomize := false);
\echo -- q2
SELECT* from pgr_TSPeuclidean(
    $$
    SELECT * FROM wi29
    $$,
    start_id => 3);
\echo -- q3

SELECT* from pgr_TSPeuclidean(
    $$
    SELECT id, st_X(the_geom) AS x, st_Y(the_geom) AS y FROM edge_table_vertices_pgr
    $$,
    start_id => 5,
    end_id => 10);
\echo -- q4
