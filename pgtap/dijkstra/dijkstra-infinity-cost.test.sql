\i setup.sql

UPDATE edge_table SET cost = sign(cost), reverse_cost = sign(reverse_cost);
SELECT plan(8);

CREATE OR REPLACE FUNCTION infinity_cost()
RETURNS SETOF TEXT AS
$BODY$
BEGIN

IF is_version_2() THEN
  RETURN QUERY
  SELECT skip(8, 'Infinity cost fixed on 3.0.0');
  RETURN;
END IF;

PREPARE q0 AS
SELECT agg_cost FROM pgr_dijkstra( 'select id, source, target, cost from edge_table',
    7, 6) ORDER BY seq DESC LIMIT 1;

PREPARE update2infinity AS
UPDATE edge_table SET cost = 'Infinity' WHERE id = 7;

PREPARE q1 AS
SELECT agg_cost FROM pgr_dijkstra( 'select id, source, target, cost from edge_table',
    7, 8) ORDER BY seq DESC LIMIT 1;

PREPARE q2 AS
SELECT agg_cost FROM pgr_dijkstra( 'select id, source, target, cost from edge_table',
    8, 5) ORDER BY seq DESC LIMIT 1;

PREPARE q3 AS
SELECT agg_cost FROM pgr_dijkstra( 'select id, source, target, cost from edge_table',
    5, 6) ORDER BY seq DESC LIMIT 1;

PREPARE q4 AS
SELECT agg_cost FROM pgr_dijkstra( 'select id, source, target, cost from edge_table',
    7, 5) ORDER BY seq DESC LIMIT 1;

PREPARE q5 AS
SELECT agg_cost FROM pgr_dijkstra( 'select id, source, target, cost from edge_table',
    8, 6) ORDER BY seq DESC LIMIT 1;

PREPARE q6 AS
SELECT agg_cost FROM pgr_dijkstra( 'select id, source, target, cost from edge_table',
    7, 6) ORDER BY seq DESC LIMIT 1;

-- test for infinity if there is no alternative
RETURN QUERY
SELECT results_eq('q0', 'SELECT cast(3 as double precision) as agg_cost;');
RETURN QUERY
SELECT lives_ok('update2infinity', 'updating an edge to ''Infinity'' should be possible');
RETURN QUERY
SELECT results_eq('q1', 'SELECT cast(1 as double precision) as agg_cost;');
RETURN QUERY
SELECT results_eq('q2', 'SELECT cast(''Infinity'' as double precision) as agg_cost;', 'Routing through edge 7 should be ''Infinity''');
RETURN QUERY
SELECT results_eq('q3', 'SELECT cast(1 as double precision) as agg_cost;');
RETURN QUERY
SELECT results_eq('q4', 'SELECT cast(''Infinity'' as double precision) as agg_cost;', 'Routing through edge 7 should be ''Infinity''');
RETURN QUERY
SELECT results_eq('q5', 'SELECT cast(''Infinity'' as double precision) as agg_cost;', 'Routing through edge 7 should be ''Infinity''');
RETURN QUERY
SELECT results_eq('q6', 'SELECT cast(''Infinity'' as double precision) as agg_cost;', 'Routing through edge 7 should be ''Infinity''');

END;
$BODY$
LANGUAGE plpgsql;

SELECT infinity_cost();
SELECT * FROM finish();
ROLLBACK;
