\i setup.sql

UPDATE edge_table SET cost = sign(cost), reverse_cost = sign(reverse_cost);
SELECT CASE WHEN is_version_2() THEN plan(1) ELSE plan(5) END;

CREATE OR REPLACE FUNCTION edge_cases()
RETURNS SETOF TEXT AS
$BODY$
BEGIN
  IF is_version_2() THEN
    RETURN QUERY
    SELECT skip(1, 'Function changed name on 3.0.0');
    RETURN;
  END IF;

RETURN QUERY
SELECT throws_ok(
    $$SELECT * FROM pgr_contraction(
        'SELECT id, source, target, cost, reverse_cost FROM edge_table WHERE id = 1',
        ARRAY[-1]::integer[], 1, ARRAY[]::BIGINT[], true)$$,
    'XX000', 'Invalid contraction type found');

-- GRAPH: 1 <=> 2
PREPARE q1 AS
SELECT * FROM pgr_contraction(
    'SELECT id, source, target, cost, reverse_cost FROM edge_table WHERE id = 1',
    ARRAY[1]::integer[], 1, ARRAY[]::BIGINT[], true);

RETURN QUERY
SELECT set_eq('q1',
    $$SELECT
    'v'::CHAR AS type,
    2::BIGINT AS id,
    ARRAY[1]::BIGINT[] AS contracted_vertices,
    -1::BIGINT AS source,
    -1::BIGINT AS target,
    -1::FLOAT AS cost$$);


--GRAPH: 1 <=> 2 <- 3
-- EXPECTED

PREPARE q2 AS
SELECT * FROM pgr_contraction(
    'SELECT id, source, target, cost, reverse_cost FROM edge_table WHERE id < 3',
    ARRAY[1]::integer[], 1, ARRAY[]::BIGINT[], true);

RETURN QUERY
SELECT set_eq('q2',
    $$SELECT
    'v'::CHAR AS type,
    3::BIGINT AS id,
    ARRAY[1, 2]::BIGINT[] AS contracted_vertices,
    -1::BIGINT AS source,
    -1::BIGINT AS target,
    -1::FLOAT AS cost$$);



-- EXPECTED
--   1 | v    |  2 | {1}                 |     -1 |     -1 |   -1
--   2 | v    |  5 | {7,8}               |     -1 |     -1 |   -1
--   3 | v    | 10 | {13}                |     -1 |     -1 |   -1
--   4 | v    | 15 | {14}                |     -1 |     -1 |   -1
--   5 | v    | 17 | {16}                |     -1 |     -1 |   -1

PREPARE q3 AS
SELECT * FROM pgr_contraction(
    'SELECT id, source, target, cost, reverse_cost FROM edge_table',
    ARRAY[1]::integer[], 1, ARRAY[]::BIGINT[], true);

PREPARE sol3 AS
SELECT type, id, contracted_vertices, source, target, cost
FROM (VALUES
    ('v'::CHAR, 2::BIGINT, ARRAY[1]::BIGINT[], -1::BIGINT, -1::BIGINT, -1::FLOAT),
    ('v', 5, ARRAY[7,8], -1, -1, -1),
    ('v', 10, ARRAY[13], -1, -1, -1),
    ('v', 15, ARRAY[14], -1, -1, -1),
    ('v', 17, ARRAY[16], -1, -1, -1)
) AS t(type, id, contracted_vertices, source, target, cost );

RETURN QUERY
SELECT set_eq('q3', 'sol3');


-- 5 <- 6
-- "    ^
-- 2 <- 3

-- EXPECTED
-- (empty)

PREPARE q4 AS
SELECT * FROM pgr_contraction(
	$$SELECT id, source, target, cost, reverse_cost FROM edge_table
	WHERE id IN (2, 4, 5, 8)$$,
	ARRAY[1]::integer[], 1, ARRAY[]::BIGINT[], true);

RETURN QUERY
SELECT is_empty('q4');

END
$BODY$
LANGUAGE plpgsql;

SELECT edge_cases();
SELECT finish();
ROLLBACK;
