\i setup.sql
UPDATE edge_table SET cost = sign(cost) + 0.001 * id * id, reverse_cost = sign(reverse_cost) + 0.001 * id * id;

CREATE TEMP TABLE data AS
SELECT * FROM pgr_withPointsCostMatrix(
  'SELECT id, source, target, cost, reverse_cost FROM edge_table ORDER BY id',
  'SELECT pid, edge_id, fraction from pointsOfInterest',
  array[-1, 3, 5, 6, -6], directed := false);

SELECT CASE WHEN is_version_2() THEN plan(1) ELSE plan(20) END;

CREATE FUNCTION tsp_edge_cases()
RETURNS SETOF TEXT AS
$code$
BEGIN
  IF is_version_2() THEN
    RETURN QUERY
    SELECT skip(1, 'Not testing tsp on version 2.x.y (2.6)');
    RETURN;
  END IF;

  IF NOT test_min_version('3.3.0') THEN PERFORM todo_start('Changes in 3.3.0'); END IF;
    RETURN QUERY
    SELECT throws_ok($$
      SELECT * FROM pgr_TSP('SELECT * FROM data', start_id => 5, end_id => 10) $$,
      'XX000',
      'start_id or end_id do not exist on the data',
      '1 SHOULD throw because end_id does not exist');

    RETURN QUERY
    SELECT throws_ok($$
      SELECT * FROM pgr_TSP('SELECT * FROM data', end_id => 10) $$,
      'XX000',
      'start_id or end_id do not exist on the data',
      '2 SHOULD throw because end_id does not exist');

    RETURN QUERY
    SELECT throws_ok($$
      SELECT * FROM pgr_TSP('SELECT * FROM data', start_id => 10, end_id => 5) $$,
      'XX000',
      'start_id or end_id do not exist on the data',
      '2 SHOULD throw because start_id does not exist');

    RETURN QUERY
    SELECT throws_ok($$
      SELECT * FROM pgr_TSP('SELECT * FROM data', start_id => 10) $$,
      'XX000',
      'start_id or end_id do not exist on the data',
      '2 SHOULD throw because start_id does not exist');


  IF NOT test_min_version('3.3.0') THEN PERFORM todo_enbd(); END IF;


RETURN QUERY
SELECT is(
  (SELECT count(*) FROM pgr_TSP('SELECT * FROM data', start_id => 5, end_id => 3)),
  6::BIGINT,
  '3 SHOULD PASS: total number of rows is 6 because there are 5 nodes involved');

RETURN QUERY
SELECT is(
  (SELECT agg_cost FROM pgr_TSP('SELECT * FROM data', start_id => 5, end_id => 3) WHERE seq = 1),
  0::FLOAT,
  '4 SHOULD PASS: agg_cost at row 0 is 0.0');

RETURN QUERY
SELECT is(
  (SELECT cost FROM pgr_TSP('SELECT * FROM data', start_id => 5, end_id => 3) WHERE seq = 1),
  0::FLOAT,
  '5 SHOULD PASS: cost at row 0 is 0.0');

RETURN QUERY
SELECT is(
  (SELECT node FROM pgr_TSP('SELECT * FROM data', start_id => 5, end_id => 3) WHERE seq = 1),
  5::BIGINT,
  '6 SHOULD PASS: first node should be 5');

RETURN QUERY
SELECT is(
  (SELECT node FROM pgr_TSP('SELECT * FROM data', start_id => 5, end_id => 3) WHERE seq = 6),
  5::BIGINT,
  '7 SHOULD PASS: last node should be 5');

RETURN QUERY
SELECT is(
  (SELECT node FROM pgr_TSP('SELECT * FROM data', start_id => 5, end_id => 3) WHERE seq = 5),
  3::BIGINT,
  '8 SHOULD PASS: second to last node should be 3');

RETURN QUERY
SELECT is(
  (SELECT count(*) FROM pgr_TSP('SELECT * FROM data', end_id => 3)),
  6::BIGINT,
  'end_id => 3 SHOULD PASS: total number of rows is 6 because there are 5 nodes involved');

RETURN QUERY
SELECT is(
  (SELECT node FROM pgr_TSP('SELECT * FROM data', end_id => 3) WHERE seq = 1),
  3::BIGINT,
  'end_id => 3 SHOULD PASS: first node should be 3');

RETURN QUERY
SELECT is(
  (SELECT node FROM pgr_TSP('SELECT * FROM data', end_id => 3) WHERE seq = 6),
  3::BIGINT,
  'end_id => 3 SHOULD PASS: last node should be 3');

RETURN QUERY
SELECT is(
  (SELECT agg_cost FROM pgr_TSP('SELECT * FROM data', end_id => 3) WHERE seq = 1),
  0::FLOAT,
  'end_id => 3 SHOULD PASS: agg_cost at row 0 is 0.0');

RETURN QUERY
SELECT is(
  (SELECT cost FROM pgr_TSP('SELECT * FROM data', end_id => 3) WHERE seq = 1),
  0::FLOAT,
  'end_id => 3 SHOULD PASS: cost at row 0 is 0.0');

RETURN QUERY
SELECT is(
  (SELECT count(*) FROM pgr_TSP('SELECT * FROM data', start_id => 5)),
  6::BIGINT,
  'start_id => 5 SHOULD PASS: total number of rows is 6 because there are 5 nodes involved');

RETURN QUERY
SELECT is(
  (SELECT node FROM pgr_TSP('SELECT * FROM data', start_id => 5) WHERE seq = 1),
  5::BIGINT,
  'start_id => 5 SHOULD PASS: first node should be 5');

RETURN QUERY
SELECT is(
  (SELECT node FROM pgr_TSP('SELECT * FROM data', start_id => 5) WHERE seq = 6),
  5::BIGINT,
  'start_id => 5 SHOULD PASS: last node should be 5');

RETURN QUERY
SELECT is(
  (SELECT agg_cost FROM pgr_TSP('SELECT * FROM data', start_id => 5) WHERE seq = 1),
  0::FLOAT,
  'start_id => 5 SHOULD PASS: agg_cost at row 0 is 0.0');

RETURN QUERY
SELECT is(
  (SELECT cost FROM pgr_TSP('SELECT * FROM data', start_id => 5) WHERE seq = 1),
  0::FLOAT,
  'start_id => 5 SHOULD PASS: cost at row 0 is 0.0');

END;
$code$
language plpgsql;
SELECT tsp_edge_cases();

SELECT finish();
ROLLBACK;
