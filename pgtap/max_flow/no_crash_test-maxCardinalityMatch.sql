\i setup.sql

UPDATE edge_table SET cost = sign(cost), reverse_cost = sign(reverse_cost);
SELECT plan(5);

PREPARE edges AS
SELECT id, source, target, cost AS going, reverse_cost AS coming FROM edge_table;

SELECT isnt_empty('edges', 'Should not be empty true to tests be meaningful');


CREATE OR REPLACE FUNCTION test_function()
RETURNS SETOF TEXT AS
$BODY$
DECLARE
params TEXT[];
subs TEXT[];
BEGIN
  IF is_version_2() AND NOT is_version_2('2.6.1') THEN
    RETURN QUERY
    SELECT skip (4, 'STATIC was added on 2.6.1');
    RETURN;
  END IF;

    params = ARRAY[
        '$$SELECT id, source, target, cost AS going, reverse_cost AS coming FROM edge_table$$'
        ]::TEXT[];
    subs = ARRAY[
        'NULL'
        ]::TEXT[];

    RETURN query SELECT * FROM no_crash_test('pgr_maxCardinalityMatch', params, subs);

END
$BODY$
LANGUAGE plpgsql VOLATILE;


SELECT * FROM test_function();
SELECT finish();

ROLLBACK;
