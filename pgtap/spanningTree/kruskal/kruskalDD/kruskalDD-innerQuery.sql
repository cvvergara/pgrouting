\i setup.sql
\i spanning_pgtap_tests.sql

UPDATE edge_table SET cost = sign(cost), reverse_cost = sign(reverse_cost);
SELECT plan(54);

SELECT inner_query_spanning('pgr_kruskalDD',', 5, 3.5)');

SELECT finish();
ROLLBACK;
