\i setup.sql

UPDATE edge_table SET cost = sign(cost), reverse_cost = sign(reverse_cost);
SELECT plan(2);

CREATE OR REPLACE FUNCTION no_crash()
RETURNS SETOF TEXT AS
$BODY$
DECLARE
params TEXT[];
subs TEXT[];
BEGIN
  IF is_version_2() OR NOT test_min_version('3.0.0') THEN
    RETURN QUERY
    SELECT skip(2, 'Function is new on 3.0.0');
    RETURN;
  END IF;

  RETURN QUERY
  SELECT throws_ok(
    'SELECT * FROM pgr_transitiveclosure(
      ''SELECT id, source, target, cost, reverse_cost FROM edge_table id < 2'',
      3
    )','42883','function pgr_transitiveclosure(unknown, integer) does not exist',
    '6: Documentation says it does not work with 1 flags');


  RETURN QUERY
  SELECT lives_ok(
    'SELECT * FROM pgr_transitiveclosure(
      ''SELECT id, source, target, cost, reverse_cost FROM edge_table WHERE id = 2 ''
    )',
    '4: Documentation says works with no flags');
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

SELECT no_crash();
SELECT finish();


ROLLBACK;
