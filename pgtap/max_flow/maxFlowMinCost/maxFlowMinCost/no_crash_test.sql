\i setup.sql

UPDATE edge_table SET cost = sign(cost), reverse_cost = sign(reverse_cost);
SELECT plan(81);

PREPARE edges AS
SELECT id,
    source,
    target,
    capacity,
    reverse_capacity,
    cost,
    reverse_cost
FROM edge_table
ORDER BY id;

-- A source should not be a sink
PREPARE combinations AS
SELECT source, target  FROM combinations_table WHERE target > 2;

PREPARE null_ret AS
SELECT id FROM edge_table_vertices_pgr  WHERE id IN (-1);

PREPARE null_ret_arr AS
SELECT array_agg(id) FROM edge_table_vertices_pgr  WHERE id IN (-1);

PREPARE null_combinations AS
SELECT source, target FROM combinations_table WHERE source IN (-1);

SELECT isnt_empty('edges', 'Should be not empty to tests be meaningful');
SELECT isnt_empty('combinations', 'Should be not empty to tests be meaningful');
SELECT is_empty('null_ret', 'Should be empty to tests be meaningful');
SELECT is_empty('null_combinations', 'Should be empty to tests be meaningful');
SELECT set_eq('null_ret_arr', 'SELECT NULL::BIGINT[]', 'Should be empty to tests be meaningful');


CREATE OR REPLACE FUNCTION test_function()
RETURNS SETOF TEXT AS
$BODY$
DECLARE
params TEXT[];
subs TEXT[];
BEGIN
  IF is_version_2() OR NOT test_min_version('3.2.0') THEN
    RETURN QUERY
    SELECT skip(48, 'Bug in function is fixed on 3.2.0');
  ELSE
    -- one to one
    params = ARRAY[
    '$$edges$$',
    '1::BIGINT',
    '2::BIGINT'
    ]::TEXT[];

    subs = ARRAY[
    'NULL',
    '(SELECT id FROM edge_table_vertices_pgr  WHERE id IN (-1))',
    '(SELECT id FROM edge_table_vertices_pgr  WHERE id IN (-1))'
    ]::TEXT[];
    RETURN query SELECT * FROM no_crash_test('pgr_maxFlowMinCost',params, subs);

    subs = ARRAY[
    'NULL',
    'NULL::BIGINT',
    'NULL::BIGINT'
    ]::TEXT[];
    RETURN query SELECT * FROM no_crash_test('pgr_maxFlowMinCost',params, subs);
    -- one to many

    params = ARRAY['$$edges$$',
    '1::BIGINT',
    'ARRAY[2,5]::BIGINT[]'
    ]::TEXT[];
    subs = ARRAY[
    'NULL',
    '(SELECT id FROM edge_table_vertices_pgr  WHERE id IN (-1))',
    '(SELECT array_agg(id) FROM edge_table_vertices_pgr  WHERE id IN (-1))'
    ]::TEXT[];

    RETURN query SELECT * FROM no_crash_test('pgr_maxFlowMinCost',params, subs);

    subs = ARRAY[
    'NULL',
    'NULL::BIGINT',
    'NULL::BIGINT[]'
    ]::TEXT[];
    RETURN query SELECT * FROM no_crash_test('pgr_maxFlowMinCost',params, subs);

    -- many to one
    params = ARRAY['$$edges$$',
        'ARRAY[2,5]::BIGINT[]',
        '1'
        ]::TEXT[];
    subs = ARRAY[
    'NULL',
    '(SELECT array_agg(id) FROM edge_table_vertices_pgr  WHERE id IN (-1))',
    '(SELECT id FROM edge_table_vertices_pgr  WHERE id IN (-1))'
    ]::TEXT[];

    RETURN query SELECT * FROM no_crash_test('pgr_maxFlowMinCost',params, subs);

    subs = ARRAY[
    'NULL',
    'NULL::BIGINT[]',
    'NULL::BIGINT'
    ]::TEXT[];
    RETURN query SELECT * FROM no_crash_test('pgr_maxFlowMinCost',params, subs);
  END IF;

    -- many to many
    params = ARRAY['$$edges$$',
        'ARRAY[1]::BIGINT[]',
        'ARRAY[2,5]::BIGINT[]'
        ]::TEXT[];
    subs = ARRAY[
    'NULL',
    '(SELECT array_agg(id) FROM edge_table_vertices_pgr  WHERE id IN (-1))',
    '(SELECT array_agg(id) FROM edge_table_vertices_pgr  WHERE id IN (-1))'
    ]::TEXT[];

    RETURN query SELECT * FROM no_crash_test('pgr_maxFlowMinCost',params, subs);

    subs = ARRAY[
    'NULL',
    'NULL::BIGINT[]',
    'NULL::BIGINT[]'
    ]::TEXT[];
    RETURN query SELECT * FROM no_crash_test('pgr_maxFlowMinCost',params, subs);

    IF is_version_2() OR NOT test_min_version('3.2.0') THEN
      RETURN QUERY
      SELECT skip(12, 'Combinations functionality is new on 3.2.0');
      RETURN;
    END IF;

    -- Combinations SQL
    params = ARRAY['$$edges$$', '$$combinations$$']::TEXT[];
    subs = ARRAY[
    'NULL',
    '$$(SELECT source, target FROM combinations_table  WHERE source IN (-1))$$'
    ]::TEXT[];

    RETURN query SELECT * FROM no_crash_test('pgr_maxFlowMinCost', params, subs);

    subs = ARRAY[
    'NULL',
    'NULL::TEXT'
    ]::TEXT[];
    RETURN query SELECT * FROM no_crash_test('pgr_maxFlowMinCost', params, subs);
END
$BODY$
LANGUAGE plpgsql VOLATILE;


SELECT * FROM test_function();

ROLLBACK;
