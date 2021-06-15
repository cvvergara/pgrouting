\i setup.sql

UPDATE edge_table SET cost = sign(cost), reverse_cost = sign(reverse_cost);
SELECT plan(29);

CREATE OR REPLACE FUNCTION edge_cases()
RETURNS SETOF TEXT AS
$BODY$
BEGIN

IF is_version_2() THEN
  RETURN QUERY
  SELECT skip(29, 'Function is new on 3.0.0');
  RETURN;
END IF;


-- 0 edges tests

RETURN QUERY
SELECT is_empty(' SELECT id, source, target, cost > 0, reverse_cost > 0  from edge_table where id>18 ','1');

-- directed graph
RETURN QUERY
SELECT is_empty('
  SELECT * from pgr_breadthFirstSearch(''SELECT id, source, target, cost, reverse_cost  from edge_table where id>18 '', 5)', '2');

RETURN QUERY
SELECT is_empty('
  SELECT * from pgr_breadthFirstSearch(''SELECT id, source, target, cost, reverse_cost  from edge_table where id>18 '',array[5])','3');

RETURN QUERY
SELECT is_empty('
  SELECT * from pgr_breadthFirstSearch(''SELECT id, source, target, cost, reverse_cost  from edge_table where id>18 '',array[2,5])', '4');

RETURN QUERY
SELECT is_empty('
  SELECT * from pgr_breadthFirstSearch(''SELECT id, source, target, cost, reverse_cost  from edge_table where id>18 '', 5, 2)', '5');

RETURN QUERY
SELECT is_empty('
  SELECT * from pgr_breadthFirstSearch(''SELECT id, source, target, cost, reverse_cost  from edge_table where id>18 '',array[5], 2)','6');

RETURN QUERY
SELECT is_empty('
  SELECT * from pgr_breadthFirstSearch(''SELECT id, source, target, cost, reverse_cost  from edge_table where id>18 '',array[2,5], 2)', '7');

-- undirected graph

RETURN QUERY
SELECT is_empty('
  SELECT * from pgr_breadthFirstSearch(''SELECT id, source, target, cost, reverse_cost  from edge_table where id>18 '', 5, directed := false)', '8');

RETURN QUERY
SELECT is_empty('
  SELECT * from pgr_breadthFirstSearch(''SELECT id, source, target, cost, reverse_cost  from edge_table where id>18 '',array[5], directed := false)','9');

RETURN QUERY
SELECT is_empty('
  SELECT * from pgr_breadthFirstSearch(''SELECT id, source, target, cost, reverse_cost  from edge_table where id>18 '',array[2,5], directed := false)', '10');

RETURN QUERY
SELECT is_empty('
  SELECT * from pgr_breadthFirstSearch(''SELECT id, source, target, cost, reverse_cost  from edge_table where id>18 '', 5, 2, directed := false)', '11');

RETURN QUERY
SELECT is_empty('
  SELECT * from pgr_breadthFirstSearch(''SELECT id, source, target, cost, reverse_cost  from edge_table where id>18 '',array[5], 2, directed := false)','12');

RETURN QUERY
SELECT is_empty('
  SELECT * from pgr_breadthFirstSearch(''SELECT id, source, target, cost, reverse_cost  from edge_table where id>18 '',array[2,5], 2, directed := false)', '13');


-- vertex not present in graph tests

-- directed graph


RETURN QUERY
SELECT is_empty('
  SELECT * from pgr_breadthFirstSearch(''SELECT id, source, target, cost, reverse_cost  from edge_table'', -10)', '14');

RETURN QUERY
SELECT is_empty('
  SELECT * from pgr_breadthFirstSearch(''SELECT id, source, target, cost, reverse_cost  from edge_table'',array[-10])','15');

RETURN QUERY
SELECT is_empty('
  SELECT * from pgr_breadthFirstSearch(''SELECT id, source, target, cost, reverse_cost  from edge_table'',array[20,-10])', '16');

RETURN QUERY
SELECT is_empty('
  SELECT * from pgr_breadthFirstSearch(''SELECT id, source, target, cost, reverse_cost  from edge_table'', -10, 2)', '17');

RETURN QUERY
SELECT is_empty('
  SELECT * from pgr_breadthFirstSearch(''SELECT id, source, target, cost, reverse_cost  from edge_table'',array[-10], 2)','18');

RETURN QUERY
SELECT is_empty('
  SELECT * from pgr_breadthFirstSearch(''SELECT id, source, target, cost, reverse_cost  from edge_table'',array[20,-10], 2)', '19');

-- undirected graph

RETURN QUERY
SELECT is_empty('
  SELECT * from pgr_breadthFirstSearch(''SELECT id, source, target, cost, reverse_cost  from edge_table'', -10, directed := false)', '20');

RETURN QUERY
SELECT is_empty('
  SELECT * from pgr_breadthFirstSearch(''SELECT id, source, target, cost, reverse_cost  from edge_table'',array[-10], directed := false)','21');

RETURN QUERY
SELECT is_empty('
  SELECT * from pgr_breadthFirstSearch(''SELECT id, source, target, cost, reverse_cost  from edge_table'',array[20,-10], directed := false)', '22');

RETURN QUERY
SELECT is_empty('
  SELECT * from pgr_breadthFirstSearch(''SELECT id, source, target, cost, reverse_cost  from edge_table'', -10, 2, directed := false)', '23');

RETURN QUERY
SELECT is_empty('
  SELECT * from pgr_breadthFirstSearch(''SELECT id, source, target, cost, reverse_cost  from edge_table'',array[-10], 2, directed := false)','24');

RETURN QUERY
SELECT is_empty('
  SELECT * from pgr_breadthFirstSearch(''SELECT id, source, target, cost, reverse_cost  from edge_table'',array[20,-10], 2, directed := false)', '25');

-- negative depth tests

PREPARE breadthFirstSearch26 AS
SELECT *
FROM pgr_breadthFirstSearch(
  'SELECT id, source, target, cost, reverse_cost
  FROM edge_table',
  4, -3
);


RETURN QUERY
SELECT throws_ok('breadthFirstSearch26',
  'P0001',
  'Negative value found on ''max_depth''',
  '26: Negative max_depth throws');



PREPARE breadthFirstSearch27 AS
SELECT *
FROM pgr_breadthFirstSearch(
  'SELECT id, source, target, cost, reverse_cost
  FROM edge_table',
  ARRAY[4, 10], -3
);


RETURN QUERY
SELECT throws_ok('breadthFirstSearch27',
  'P0001',
  'Negative value found on ''max_depth''',
  '27: Negative max_depth throws');

PREPARE breadthFirstSearch28 AS
SELECT *
FROM pgr_breadthFirstSearch(
  'SELECT id, source, target, cost, reverse_cost
  FROM edge_table',
  4, -3, directed := false
);


RETURN QUERY
SELECT throws_ok('breadthFirstSearch28',
  'P0001',
  'Negative value found on ''max_depth''',
  '28: Negative max_depth throws');



PREPARE breadthFirstSearch29 AS
SELECT *
FROM pgr_breadthFirstSearch(
  'SELECT id, source, target, cost, reverse_cost
  FROM edge_table',
  ARRAY[4, 10], -3, directed := false
);


RETURN QUERY
SELECT throws_ok('breadthFirstSearch29',
  'P0001',
  'Negative value found on ''max_depth''',
  '29: Negative max_depth throws');

END;
$BODY$
LANGUAGE plpgsql;

SELECT edge_cases();


SELECT * FROM finish();
ROLLBACK;
