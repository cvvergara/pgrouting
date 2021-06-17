\i setup.sql

UPDATE edge_table SET cost = sign(cost), reverse_cost = sign(reverse_cost);
SELECT CASE WHEN is_version_2() THEN plan(1) ELSE plan(57) END;

CREATE OR REPLACE FUNCTION inner_query()
RETURNS SETOF TEXT AS
$BODY$
BEGIN
  IF is_version_2() THEN
    RETURN QUERY
    SELECT skip(1, 'Function changed name on 3.0.0');
    RETURN;
  END IF;

RETURN QUERY
SELECT has_function('pgr_contraction');

RETURN QUERY
SELECT has_function('pgr_contraction', ARRAY[
    'text', 'bigint[]',
    'integer', 'bigint[]', 'boolean'
    ]);

RETURN QUERY
SELECT function_returns('pgr_contraction', ARRAY[
    'text', 'bigint[]',
    'integer', 'bigint[]', 'boolean'
    ], 'setof record');

-- LINEAR
RETURN QUERY
SELECT style_dijkstra('pgr_contraction', ', ARRAY[1]::BIGINT[], 1, ARRAY[3]::BIGINT[], false)');


END
$BODY$
LANGUAGE plpgsql;

SELECT inner_query();
SELECT finish();
ROLLBACK;
