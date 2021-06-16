\i setup.sql

UPDATE edge_table SET cost = sign(cost), reverse_cost = sign(reverse_cost);
SELECT plan(15);

CREATE OR REPLACE FUNCTION test_function()
RETURNS SETOF TEXT AS
$BODY$
DECLARE
params TEXT[];
subs TEXT[];
BEGIN
  IF is_version_2() AND is_version_2('2.1.0') THEN
    RETURN QUERY
    SELECT skip (15, 'STATIC was added on 2.1.0');
    RETURN;
  END IF;

  PREPARE edges AS
  SELECT id, source, target, cost, reverse_cost  FROM edge_table;

  PREPARE null_ret AS
  SELECT id FROM edge_table_vertices_pgr  WHERE id IN (-1);

  PREPARE null_ret_arr AS
  SELECT array_agg(id) FROM edge_table_vertices_pgr  WHERE id IN (-1);

  RETURN QUERY
  SELECT isnt_empty('edges', 'Should be not empty to tests be meaningful');

  RETURN QUERY
  SELECT is_empty('null_ret', 'Should be empty to tests be meaningful');

  RETURN QUERY
  SELECT set_eq('null_ret_arr', 'SELECT NULL::BIGINT[]', 'Should be empty to tests be meaningful');


  params = ARRAY['$$SELECT id, source, target, cost, reverse_cost  FROM edge_table$$',
  'ARRAY[2,5]::BIGINT[]'
  ]::TEXT[];
  subs = ARRAY[
  'NULL',
  '(SELECT array_agg(id) FROM edge_table_vertices_pgr  WHERE id IN (-1))'
  ]::TEXT[];
  RETURN query SELECT * FROM no_crash_test('pgr_dijkstraVia', params, subs);

  subs = ARRAY[
  'NULL',
  'NULL::BIGINT[]'
  ]::TEXT[];
  RETURN query SELECT * FROM no_crash_test('pgr_dijkstraVia', params, subs);

END
$BODY$
LANGUAGE plpgsql VOLATILE;


SELECT * FROM test_function();

ROLLBACK;
