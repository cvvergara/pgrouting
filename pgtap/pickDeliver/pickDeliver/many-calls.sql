\i setup.sql

SELECT CASE WHEN is_version_2() THEN plan(1) ELSE plan(15) END;

CREATE OR REPLACE FUNCTION edge_cases()
RETURNS SETOF TEXT AS
$BODY$
BEGIN
  IF is_version_2() THEN
    RETURN QUERY
    SELECT skip(1, 'Function changed name on 3.0.0');
    RETURN;
  END IF;


PREPARE No_problem_query AS
SELECT * FROM pgr_pickDeliver(
    $$ SELECT * FROM orders ORDER BY id $$,
    $$ SELECT * FROM vehicles ORDER BY id$$,
    $$ SELECT * from pgr_dijkstraCostMatrix(
        'SELECT * FROM edge_table ',
        (SELECT array_agg(id) FROM (SELECT p_node_id AS id FROM orders
        UNION
        SELECT d_node_id FROM orders
        UNION
        SELECT start_node_id FROM vehicles) a))
    $$
);

RETURN QUERY
SELECT lives_ok('No_problem_query', 'Should live: '|| 1);
RETURN QUERY
SELECT lives_ok('No_problem_query', 'Should live: '|| 2);
RETURN QUERY
SELECT lives_ok('No_problem_query', 'Should live: '|| 3);
RETURN QUERY
SELECT lives_ok('No_problem_query', 'Should live: '|| 4);
RETURN QUERY
SELECT lives_ok('No_problem_query', 'Should live: '|| 5);
RETURN QUERY
SELECT lives_ok('No_problem_query', 'Should live: '|| 6);
RETURN QUERY
SELECT lives_ok('No_problem_query', 'Should live: '|| 7);
RETURN QUERY
SELECT lives_ok('No_problem_query', 'Should live: '|| 8);
RETURN QUERY
SELECT lives_ok('No_problem_query', 'Should live: '|| 9);
RETURN QUERY
SELECT lives_ok('No_problem_query', 'Should live: '|| 10);
RETURN QUERY
SELECT lives_ok('No_problem_query', 'Should live: '|| 11);
RETURN QUERY
SELECT lives_ok('No_problem_query', 'Should live: '|| 12);
RETURN QUERY
SELECT lives_ok('No_problem_query', 'Should live: '|| 13);
RETURN QUERY
SELECT lives_ok('No_problem_query', 'Should live: '|| 14);
RETURN QUERY
SELECT lives_ok('No_problem_query', 'Should live: '|| 15);

END
$BODY$
LANGUAGE plpgsql VOLATILE;

SELECT edge_cases();
SELECT finish();
ROLLBACK;
