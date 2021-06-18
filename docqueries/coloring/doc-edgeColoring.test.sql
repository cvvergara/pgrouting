\echo -- q1
SELECT * FROM pgr_edgeColoring(
    'SELECT id, source, target, cost, reverse_cost FROM edge_table
    ORDER BY id'
);
INSERT INTO edge_table (source, target, cost, reverse_cost) VALUES
(1, 7, 1, 1);
SELECT * FROM pgr_edgeColoring(
    'SELECT id, source, target, cost, reverse_cost FROM edge_table
    ORDER BY id'
);
\echo -- q2
