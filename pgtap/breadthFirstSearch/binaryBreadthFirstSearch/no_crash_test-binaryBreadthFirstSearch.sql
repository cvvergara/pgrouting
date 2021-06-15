\i setup.sql

UPDATE edge_table SET cost = sign(cost), reverse_cost = sign(reverse_cost);
SELECT plan(157);

CREATE OR REPLACE FUNCTION preparation()
RETURNS SETOF TEXT AS
$BODY$
BEGIN

IF is_version_2() THEN
  RETURN QUERY
  SELECT skip(5, 'Function is new on 3.0.0');
  RETURN;
END IF;

PREPARE edges AS
SELECT id, source, target, cost, reverse_cost  FROM edge_table;

PREPARE combinations AS
SELECT source, target  FROM combinations_table;

PREPARE null_ret AS
SELECT id FROM edge_table_vertices_pgr  WHERE id IN (-1);

PREPARE null_ret_arr AS
SELECT array_agg(id) FROM edge_table_vertices_pgr  WHERE id IN (-1);

PREPARE null_combinations AS
SELECT source, target FROM combinations_table WHERE source IN (-1);

RETURN QUERY
SELECT isnt_empty('edges', 'Should be not empty to tests be meaningful');
RETURN QUERY
SELECT isnt_empty('combinations', 'Should be not empty to tests be meaningful');
RETURN QUERY
SELECT is_empty('null_ret', 'Should be empty to tests be meaningful');
RETURN QUERY
SELECT is_empty('null_combinations', 'Should be empty to tests be meaningful');
RETURN QUERY
SELECT set_eq('null_ret_arr', 'SELECT NULL::BIGINT[]', 'Should be empty to tests be meaningful');

END;
$BODY$
LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION no_crash()
RETURNS SETOF TEXT AS
$BODY$
DECLARE
params TEXT[];
subs TEXT[];
params_roadworks TEXT[];
subs_roadworks TEXT[];
BEGIN
  IF is_version_2() THEN
    RETURN QUERY
    SELECT skip(152, 'Function is new on 3.0.0');
    RETURN;
  END IF;

    -- one to one
    params = ARRAY[
    '$$SELECT id, source, target, cost, reverse_cost  FROM edge_table$$'
    ,'1::BIGINT',
    '2::BIGINT'
    ]::TEXT[];
    subs = ARRAY[
    'NULL',
    '(SELECT id FROM edge_table_vertices_pgr  WHERE id IN (-1))',
    '(SELECT id FROM edge_table_vertices_pgr  WHERE id IN (-1))'
    ]::TEXT[];

    RETURN query SELECT * FROM no_crash_test('pgr_binaryBreadthFirstSearch', params, subs);

    subs = ARRAY[
    'NULL',
    'NULL::BIGINT',
    'NULL::BIGINT'
    ]::TEXT[];
    RETURN query SELECT * FROM no_crash_test('pgr_binaryBreadthFirstSearch', params, subs);

    -- one to many
    params = ARRAY['$$edges$$','1', 'ARRAY[2,5]::BIGINT[]']::TEXT[];
    subs = ARRAY[
    'NULL',
    '(SELECT id FROM edge_table_vertices_pgr  WHERE id IN (-1))',
    '(SELECT array_agg(id) FROM edge_table_vertices_pgr  WHERE id IN (-1))'
    ]::TEXT[];

    RETURN query SELECT * FROM no_crash_test('pgr_binaryBreadthFirstSearch', params, subs);

    subs = ARRAY[
    'NULL',
    'NULL::BIGINT',
    'NULL::BIGINT[]'
    ]::TEXT[];
    RETURN query SELECT * FROM no_crash_test('pgr_binaryBreadthFirstSearch', params, subs);

    -- many to one
    params = ARRAY['$$edges$$', 'ARRAY[2,5]::BIGINT[]', '1']::TEXT[];
    subs = ARRAY[
    'NULL',
    '(SELECT array_agg(id) FROM edge_table_vertices_pgr  WHERE id IN (-1))',
    '(SELECT id FROM edge_table_vertices_pgr  WHERE id IN (-1))'
    ]::TEXT[];

    RETURN query SELECT * FROM no_crash_test('pgr_binaryBreadthFirstSearch', params, subs);

    subs = ARRAY[
    'NULL',
    'NULL::BIGINT[]',
    'NULL::BIGINT'
    ]::TEXT[];
    RETURN query SELECT * FROM no_crash_test('pgr_binaryBreadthFirstSearch', params, subs);

    -- many to many
    params = ARRAY['$$edges$$','ARRAY[1]::BIGINT[]', 'ARRAY[2,5]::BIGINT[]']::TEXT[];
    subs = ARRAY[
    'NULL',
    '(SELECT array_agg(id) FROM edge_table_vertices_pgr  WHERE id IN (-1))',
    '(SELECT array_agg(id) FROM edge_table_vertices_pgr  WHERE id IN (-1))'
    ]::TEXT[];

    RETURN query SELECT * FROM no_crash_test('pgr_binaryBreadthFirstSearch', params, subs);

    subs = ARRAY[
    'NULL',
    'NULL::BIGINT[]',
    'NULL::BIGINT[]'
    ]::TEXT[];
    RETURN query SELECT * FROM no_crash_test('pgr_binaryBreadthFirstSearch', params, subs);


    -- using roadworks
    -- one to one
    params_roadworks = ARRAY[
    '$$SELECT id, source, target, road_work as cost, reverse_road_work as reverse_cost  FROM roadworks$$'
    ,'1::BIGINT',
    '2::BIGINT'
    ]::TEXT[];
    subs_roadworks = ARRAY[
    'NULL',
    '(SELECT id FROM edge_table_vertices_pgr  WHERE id IN (-1))',
    '(SELECT id FROM edge_table_vertices_pgr  WHERE id IN (-1))'
    ]::TEXT[];

    RETURN query SELECT * FROM no_crash_test('pgr_binaryBreadthFirstSearch', params_roadworks, subs_roadworks);

    subs_roadworks = ARRAY[
    'NULL',
    'NULL::BIGINT',
    'NULL::BIGINT'
    ]::TEXT[];
    RETURN query SELECT * FROM no_crash_test('pgr_binaryBreadthFirstSearch', params_roadworks, subs_roadworks);

    -- one to many
    params_roadworks = ARRAY['$$edges$$','1', 'ARRAY[2,5]::BIGINT[]']::TEXT[];
    subs_roadworks = ARRAY[
    'NULL',
    '(SELECT id FROM edge_table_vertices_pgr  WHERE id IN (-1))',
    '(SELECT array_agg(id) FROM edge_table_vertices_pgr  WHERE id IN (-1))'
    ]::TEXT[];

    RETURN query SELECT * FROM no_crash_test('pgr_binaryBreadthFirstSearch', params_roadworks, subs_roadworks);

    subs_roadworks = ARRAY[
    'NULL',
    'NULL::BIGINT',
    'NULL::BIGINT[]'
    ]::TEXT[];
    RETURN query SELECT * FROM no_crash_test('pgr_binaryBreadthFirstSearch', params_roadworks, subs_roadworks);

    -- many to one
    params_roadworks = ARRAY['$$edges$$', 'ARRAY[2,5]::BIGINT[]', '1']::TEXT[];
    subs_roadworks = ARRAY[
    'NULL',
    '(SELECT array_agg(id) FROM edge_table_vertices_pgr  WHERE id IN (-1))',
    '(SELECT id FROM edge_table_vertices_pgr  WHERE id IN (-1))'
    ]::TEXT[];

    RETURN query SELECT * FROM no_crash_test('pgr_binaryBreadthFirstSearch', params_roadworks, subs_roadworks);

    subs_roadworks = ARRAY[
    'NULL',
    'NULL::BIGINT[]',
    'NULL::BIGINT'
    ]::TEXT[];
    RETURN query SELECT * FROM no_crash_test('pgr_binaryBreadthFirstSearch', params_roadworks, subs_roadworks);

    -- many to many
    params_roadworks = ARRAY['$$edges$$','ARRAY[1]::BIGINT[]', 'ARRAY[2,5]::BIGINT[]']::TEXT[];
    subs_roadworks = ARRAY[
    'NULL',
    '(SELECT array_agg(id) FROM edge_table_vertices_pgr  WHERE id IN (-1))',
    '(SELECT array_agg(id) FROM edge_table_vertices_pgr  WHERE id IN (-1))'
    ]::TEXT[];

    RETURN query SELECT * FROM no_crash_test('pgr_binaryBreadthFirstSearch', params_roadworks, subs_roadworks);

    subs_roadworks = ARRAY[
    'NULL',
    'NULL::BIGINT[]',
    'NULL::BIGINT[]'
    ]::TEXT[];
    RETURN query SELECT * FROM no_crash_test('pgr_binaryBreadthFirstSearch', params_roadworks, subs_roadworks);

    IF is_version_2() OR NOT test_min_version('3.2.0') THEN
      RETURN QUERY
      SELECT skip(24, 'Combinations signature is new on 3.2.0');
      RETURN;
    END IF;

    -- Combinations SQL
    params = ARRAY['$$edges$$', '$$combinations$$']::TEXT[];
    subs = ARRAY[
    'NULL',
    '$$(SELECT source, target FROM combinations_table  WHERE source IN (-1))$$'
    ]::TEXT[];

    RETURN query SELECT * FROM no_crash_test('pgr_binaryBreadthFirstSearch', params, subs);

    subs = ARRAY[
    'NULL',
    'NULL::TEXT'
    ]::TEXT[];
    RETURN query SELECT * FROM no_crash_test('pgr_binaryBreadthFirstSearch', params, subs);

    -- Combinations SQL
    params_roadworks = ARRAY[
    '$$SELECT id, source, target, road_work as cost, reverse_road_work as reverse_cost  FROM roadworks$$',
    '$$combinations$$'
    ]::TEXT[];
    subs_roadworks = ARRAY[
    'NULL',
    '$$(SELECT source, target FROM combinations_table  WHERE source IN (-1))$$'
    ]::TEXT[];

    RETURN query SELECT * FROM no_crash_test('pgr_binaryBreadthFirstSearch', params_roadworks, subs_roadworks);

    subs_roadworks = ARRAY[
    'NULL',
    'NULL::TEXT'
    ]::TEXT[];
    RETURN query SELECT * FROM no_crash_test('pgr_binaryBreadthFirstSearch', params_roadworks, subs_roadworks);

END
$BODY$
LANGUAGE plpgsql VOLATILE;


SELECT preparation();
SELECT no_crash();

ROLLBACK;
