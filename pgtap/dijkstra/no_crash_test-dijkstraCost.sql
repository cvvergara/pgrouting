\i setup.sql
\i dijkstra_pgtap_tests.sql

UPDATE edge_table SET cost = sign(cost), reverse_cost = sign(reverse_cost);
SELECT plan(81);

SELECT no_crash_dijkstra('pgr_dijkstraCost');
SELECT finish();

ROLLBACK;
