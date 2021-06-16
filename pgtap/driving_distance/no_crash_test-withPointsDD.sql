\i setup.sql

UPDATE edge_table SET cost = sign(cost), reverse_cost = sign(reverse_cost);
SELECT plan(42);

CREATE OR REPLACE FUNCTION no_crash()
RETURNS SETOF TEXT AS
$BODY$
DECLARE
params TEXT[];
subs TEXT[];
BEGIN
  IF is_version_2() AND is_version_2('2.1.0') THEN
    RETURN QUERY
    SELECT skip (42, 'STATIC was added on 2.1.0');
    RETURN;
  END IF;

  PREPARE edges AS
  SELECT id, source, target, cost, reverse_cost  FROM edge_table;

  PREPARE pois AS
  SELECT pid, edge_id, fraction from pointsOfInterest;

  PREPARE null_ret AS
  SELECT array_agg(id) FROM edge_table_vertices_pgr  WHERE id IN (-1);

  RETURN QUERY
  SELECT isnt_empty('edges', 'Should be not empty to tests be meaningful');

  RETURN QUERY
  SELECT set_eq('null_ret', 'SELECT NULL::BIGINT[]', 'Should be empty to tests be meaningful');


  -- 1 to distance
  params = ARRAY[
  '$$SELECT id, source, target, cost, reverse_cost  FROM edge_table$$',
  '$$SELECT pid, edge_id, fraction from pointsOfInterest$$',
  '1',
  '1.3::FLOAT'
  ]::TEXT[];
  subs = ARRAY[
  'NULL',
  'NULL',
  '(SELECT id FROM edge_table_vertices_pgr  WHERE id IN (-1))',
  'NULL'
  ]::TEXT[];

  RETURN query SELECT * FROM no_crash_test('pgr_withPointsDD', params, subs);

  subs = ARRAY[
  'NULL',
  'NULL',
  'NULL::BIGINT',
  'NULL'
  ]::TEXT[];
  RETURN query SELECT * FROM no_crash_test('pgr_withPointsDD', params, subs);

  -- many to distance
  params = ARRAY[
  '$$SELECT id, source, target, cost, reverse_cost  FROM edge_table$$',
  '$$SELECT pid, edge_id, fraction from pointsOfInterest$$',
  'ARRAY[1]',
  '1.3::FLOAT'
  ]::TEXT[];
  subs = ARRAY[
  'NULL',
  'NULL',
  '(SELECT array_agg(id) FROM edge_table_vertices_pgr  WHERE id IN (-1))',
  'NULL'
  ]::TEXT[];
  RETURN query SELECT * FROM no_crash_test('pgr_withPointsDD', params, subs);

  subs = ARRAY[
  'NULL',
  'NULL',
  'NULL::BIGINT[]',
  'NULL'
  ]::TEXT[];
  RETURN query SELECT * FROM no_crash_test('pgr_withPointsDD', params, subs);

END
$BODY$
LANGUAGE plpgsql VOLATILE;


SELECT no_crash();
SELECT finish();

ROLLBACK;
