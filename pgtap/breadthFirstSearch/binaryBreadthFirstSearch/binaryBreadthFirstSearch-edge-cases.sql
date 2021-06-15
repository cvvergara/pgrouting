\i setup.sql

UPDATE edge_table SET cost = sign(cost), reverse_cost = sign(reverse_cost);
SELECT plan(18);

CREATE OR REPLACE FUNCTION edge_cases()
RETURNS SETOF TEXT AS
$BODY$
BEGIN

IF is_version_2() THEN
  RETURN QUERY
  SELECT skip(18, 'Function is new on 3.0.0');
  RETURN;
END IF;

-- 0 edges tests


-- directed graph
RETURN QUERY
SELECT is_empty('
  SELECT * from pgr_binaryBreadthFirstSearch(''SELECT id, source, target, road_work as cost, reverse_road_work as reverse_cost  from roadworks where id>18 '', 5, 2)', '2');

RETURN QUERY
SELECT is_empty('
  SELECT * from pgr_binaryBreadthFirstSearch(''SELECT id, source, target, road_work as cost, reverse_road_work as reverse_cost  from roadworks where id>18 '',array[5], 3)','3');

RETURN QUERY
SELECT is_empty('
  SELECT * from pgr_binaryBreadthFirstSearch(''SELECT id, source, target, road_work as cost, reverse_road_work as reverse_cost  from roadworks where id>18 '',5, array[3, 7])','3');

RETURN QUERY
SELECT is_empty('
  SELECT * from pgr_binaryBreadthFirstSearch(''SELECT id, source, target, road_work as cost, reverse_road_work as reverse_cost  from roadworks where id>18 '',array[2,5], array[3,7])', '4');

-- undirected graph

RETURN QUERY
SELECT is_empty('
  SELECT * from pgr_binaryBreadthFirstSearch(''SELECT id, source, target, road_work as cost, reverse_road_work as reverse_cost  from roadworks where id>18 '', 5, 2, directed := false)', '5');

RETURN QUERY
SELECT is_empty('
  SELECT * from pgr_binaryBreadthFirstSearch(''SELECT id, source, target, road_work as cost, reverse_road_work as reverse_cost  from roadworks where id>18 '',array[5], 3, directed := false)','6');

RETURN QUERY
SELECT is_empty('
  SELECT * from pgr_binaryBreadthFirstSearch(''SELECT id, source, target, road_work as cost, reverse_road_work as reverse_cost  from roadworks where id>18 '',5, array[3, 7], directed := false)','7');

RETURN QUERY
SELECT is_empty('
  SELECT * from pgr_binaryBreadthFirstSearch(''SELECT id, source, target, road_work as cost, reverse_road_work as reverse_cost  from roadworks where id>18 '',array[2,5], array[3,7], directed := false)', '8');

-- -- vertex not present in graph tests
-- directed graph

RETURN QUERY
SELECT is_empty('
  SELECT * from pgr_binaryBreadthFirstSearch(''SELECT id, source, target, road_work as cost, reverse_road_work as reverse_cost  from roadworks'', -5, 2)', '2');

RETURN QUERY
SELECT is_empty('
  SELECT * from pgr_binaryBreadthFirstSearch(''SELECT id, source, target, road_work as cost, reverse_road_work as reverse_cost  from roadworks'',array[5], -3)','3');

RETURN QUERY
SELECT is_empty('
  SELECT * from pgr_binaryBreadthFirstSearch(''SELECT id, source, target, road_work as cost, reverse_road_work as reverse_cost  from roadworks'',5, array[-3, -7])','3');

RETURN QUERY
SELECT is_empty('
  SELECT * from pgr_binaryBreadthFirstSearch(''SELECT id, source, target, road_work as cost, reverse_road_work as reverse_cost  from roadworks'',array[-2,-5], array[3,7])', '4');

-- undirected graph

RETURN QUERY
SELECT is_empty('
  SELECT * from pgr_binaryBreadthFirstSearch(''SELECT id, source, target, road_work as cost, reverse_road_work as reverse_cost  from roadworks'', 5, -2, directed := false)', '5');

RETURN QUERY
SELECT is_empty('
  SELECT * from pgr_binaryBreadthFirstSearch(''SELECT id, source, target, road_work as cost, reverse_road_work as reverse_cost  from roadworks'',array[-5], 3, directed := false)','6');

RETURN QUERY
SELECT is_empty('
  SELECT * from pgr_binaryBreadthFirstSearch(''SELECT id, source, target, road_work as cost, reverse_road_work as reverse_cost  from roadworks'',-5, array[-3, 7], directed := false)','7');

RETURN QUERY
SELECT is_empty('
  SELECT * from pgr_binaryBreadthFirstSearch(''SELECT id, source, target, road_work as cost, reverse_road_work as reverse_cost  from roadworks'',array[-2,-5], array[-3,-7], directed := false)', '8');

CREATE TEMP TABLE roadworks_invalid_1 ON COMMIT DROP AS
SELECT * FROM roadworks;
UPDATE roadworks_invalid_1 SET road_work = 5 WHERE id = 1;

PREPARE errorTestManyWeights AS
SELECT *
FROM pgr_binaryBreadthFirstSearch(
  'SELECT id, source, target, road_work as cost, reverse_road_work as reverse_cost
  FROM roadworks_invalid_1',
  4, 6
);



RETURN QUERY
SELECT throws_ok('errorTestManyWeights',
  'XX000',
  'Graph Condition Failed: Graph should have atmost two distinct non-negative edge costs! If there are exactly two distinct edge costs, one of them must equal zero!',
  '17: Graph has more than 2 distinct weights');

CREATE TEMP TABLE roadworks_invalid_2 ON COMMIT DROP AS
SELECT * FROM roadworks;
UPDATE roadworks_invalid_2 SET road_work = 2 WHERE road_work = 0;
UPDATE roadworks_invalid_2 SET reverse_road_work = 2 WHERE reverse_road_work = 0;

PREPARE errorTestNoZeroWeight AS
SELECT *
FROM pgr_binaryBreadthFirstSearch(
  'SELECT id, source, target, road_work as cost, reverse_road_work as reverse_cost
  FROM roadworks_invalid_2',
  4, 6
);



RETURN QUERY
SELECT throws_ok('errorTestNoZeroWeight',
  'XX000',
  'Graph Condition Failed: Graph should have atmost two distinct non-negative edge costs! If there are exactly two distinct edge costs, one of them must equal zero!',
  '17: If graph has 2 distinct weights, one must be zero');

END;
$BODY$
LANGUAGE plpgsql;

SELECT edge_cases();


SELECT * FROM finish();
ROLLBACK;
