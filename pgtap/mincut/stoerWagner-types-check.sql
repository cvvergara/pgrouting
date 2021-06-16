\i setup.sql

UPDATE edge_table SET cost = sign(cost), reverse_cost = sign(reverse_cost);
SELECT plan(5);

CREATE OR REPLACE FUNCTION types_check()
RETURNS SETOF TEXT AS
$BODY$
DECLARE
BEGIN
  IF is_version_2() THEN
    RETURN QUERY
    SELECT skip (5, 'pgr_stoerWagner is new on 3.0.0');
    RETURN;
  END IF;

RETURN QUERY
SELECT has_function('pgr_stoerwagner');

RETURN QUERY
SELECT function_returns('pgr_stoerwagner', ARRAY['text'], 'setof record');


-- flags
-- error

RETURN QUERY
SELECT lives_ok(
    'SELECT * FROM pgr_stoerWagner(
        ''SELECT id, source, target, cost, reverse_cost FROM edge_table''
    )',
    '4: Documentation says works with no flags');

RETURN QUERY
SELECT throws_ok(
    'SELECT * FROM pgr_stoerWagner(
        ''SELECT id, source, target, cost, reverse_cost FROM edge_table id < 17'',
        3
    )','42883','function pgr_stoerwagner(unknown, integer) does not exist',
    '6: Documentation says it does not work with 1 flags');


-- prepare for testing return types

PREPARE all_return AS
SELECT
    'integer'::text AS t1,
    'bigint'::text AS t2,
    'double precision'::text AS t3,
    'double precision'::text AS t4;

PREPARE q1 AS
SELECT pg_typeof(seq)::text AS t1,
       pg_typeof(edge)::text AS t2,
       pg_typeof(cost)::text AS t3,
       pg_typeof(mincut)::text AS t4
    FROM (
        SELECT * FROM pgr_stoerWagner(
            'SELECT id, source, target, cost, reverse_cost FROM edge_table WHERE id < 17'
        ) ) AS a
    limit 1;


RETURN QUERY
SELECT set_eq('q1', 'all_return', 'Expected returning, columns names & types');

END
$BODY$
LANGUAGE plpgsql VOLATILE;


SELECT types_check();
SELECT * FROM finish();
ROLLBACK;
