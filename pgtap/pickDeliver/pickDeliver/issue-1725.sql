\i setup.sql

UPDATE edge_table SET cost = sign(cost), reverse_cost = sign(reverse_cost);
SELECT CASE WHEN is_version_2() THEN plan(1) ELSE plan(1) END;

CREATE OR REPLACE FUNCTION issue()
RETURNS SETOF TEXT AS
$BODY$
BEGIN
  IF is_version_2() THEN
    RETURN QUERY
    SELECT skip(1, 'Function changed name on 3.0.0');
    RETURN;
  END IF;

PREPARE missing_id_on_matrix AS
SELECT * FROM pgr_pickDeliver(
    $$ SELECT * FROM orders ORDER BY id $$,
    $$ SELECT * FROM vehicles $$,
    $$ SELECT * from pgr_dijkstraCostMatrix(
        ' SELECT * FROM edge_table ', ARRAY[3, 4, 5, 8, 9, 11])
    $$
);

RETURN QUERY
SELECT throws_ok('missing_id_on_matrix', 'XX000', 'Unable to find node on matrix', 'Should throw: matrix is missing node 6');

END
$BODY$
LANGUAGE plpgsql VOLATILE;

SELECT issue();
SELECT finish();
ROLLBACK;
