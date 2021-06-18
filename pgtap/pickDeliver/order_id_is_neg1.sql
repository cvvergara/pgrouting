\i setup.sql

UPDATE edge_table SET cost = sign(cost), reverse_cost = sign(reverse_cost);
SELECT CASE WHEN is_version_2() THEN plan(1) ELSE plan(2) END;

CREATE OR REPLACE FUNCTION issue()
RETURNS SETOF TEXT AS
$BODY$
BEGIN
  IF is_version_2() THEN
    RETURN QUERY
    SELECT skip(1, 'Function changed name on 3.0.0');
    RETURN;
  END IF;

------ https://github.com/pgRouting/pgrouting/issues/1004
CREATE TABLE results AS
SELECT *
FROM _pgr_pickDeliverEuclidean(
    $$SELECT * FROM orders$$,
    $$SELECT * FROM vehicles$$);

PREPARE q1 AS
SELECT DISTINCT order_id
FROM results
WHERE stop_type IN (-1, 1, 6);

RETURN QUERY
SELECT results_eq(
    'q1',
    ARRAY[ -1 ]::BIGINT[]
);

PREPARE q2 AS
SELECT DISTINCT stop_type FROM results ORDER BY stop_type;

RETURN QUERY
SELECT results_eq(
    'q2',
    ARRAY[ -1, 1, 2, 3, 6 ]::INTEGER[]
);

END
$BODY$
LANGUAGE plpgsql VOLATILE;

SELECT issue();
SELECT finish();
ROLLBACK;
