\i setup.sql

UPDATE edge_table SET cost = sign(cost), reverse_cost = sign(reverse_cost);
SELECT CASE WHEN is_version_2() THEN plan(1) ELSE plan(7) END;

PREPARE edges AS
SELECT id, source, target, cost, reverse_cost  FROM edge_table;



CREATE OR REPLACE FUNCTION test_function()
RETURNS SETOF TEXT AS
$BODY$
DECLARE
params TEXT[];
subs TEXT[];
BEGIN
  IF is_version_2() THEN
    RETURN QUERY
    SELECT skip(1, 'Function changed name on 3.0.0');
    RETURN;
  END IF;

  RETURN QUERY
  SELECT isnt_empty('edges', 'Should be not empty to tests be meaningful');

    params = ARRAY[
    '$$SELECT id, source, target, cost, reverse_cost  FROM edge_table$$',
    'ARRAY[1]::BIGINT[]'
    ]::TEXT[];
    subs = ARRAY[
    'NULL',
    'NULL::BIGINT[]'
    ]::TEXT[];

    RETURN query SELECT * FROM no_crash_test('pgr_contraction', params, subs);

END
$BODY$
LANGUAGE plpgsql VOLATILE;

SELECT test_function();
SELECT finish();
ROLLBACK;
