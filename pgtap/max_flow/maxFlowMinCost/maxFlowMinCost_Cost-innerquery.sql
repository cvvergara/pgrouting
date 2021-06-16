\i setup.sql

UPDATE edge_table SET cost = sign(cost), reverse_cost = sign(reverse_cost);
SELECT plan(586);

CREATE OR REPLACE FUNCTION inner_query()
RETURNS SETOF TEXT AS
$BODY$
DECLARE
BEGIN
  IF is_version_2() THEN
    RETURN QUERY
    SELECT skip (586, 'pgr_maxflowmincost_cost is new on 3.0.0');
    RETURN;
  END IF;


RETURN QUERY SELECT has_function('pgr_maxflowmincost_cost',
    ARRAY['text', 'bigint', 'bigint']);
RETURN QUERY SELECT has_function('pgr_maxflowmincost_cost',
    ARRAY['text', 'bigint', 'anyarray']);
RETURN QUERY SELECT has_function('pgr_maxflowmincost_cost',
    ARRAY['text', 'anyarray', 'bigint']);
RETURN QUERY SELECT has_function('pgr_maxflowmincost_cost',
    ARRAY['text', 'anyarray', 'anyarray']);

RETURN QUERY SELECT function_returns('pgr_maxflowmincost_cost',
    ARRAY['text', 'bigint', 'bigint'],
    'double precision');
RETURN QUERY SELECT function_returns('pgr_maxflowmincost_cost',
    ARRAY['text', 'bigint', 'anyarray'],
    'double precision');
RETURN QUERY SELECT function_returns('pgr_maxflowmincost_cost',
    ARRAY['text', 'anyarray', 'bigint'],
    'double precision');
RETURN QUERY SELECT function_returns('pgr_maxflowmincost_cost',
    ARRAY['text', 'anyarray', 'anyarray'],
    'double precision');

-- new signature on 3.2
RETURN QUERY SELECT CASE
WHEN is_version_2() OR NOT test_min_version('3.2.0') THEN
  skip(2, 'Combinations functiontionality new on 2.3')
WHEN test_min_version('3.2.0') THEN
  collect_tap(
    has_function('pgr_maxflowmincost_cost', ARRAY['text', 'text']),
    function_returns('pgr_maxflowmincost_cost', ARRAY['text', 'text'], 'double precision')
  )
END;

-- ONLY WORKS ON DIRECTED GRAPH
RETURN QUERY SELECT style_cost_flow('pgr_maxflowmincost_cost', ', 2, 3)');
RETURN QUERY SELECT style_cost_flow('pgr_maxflowmincost_cost', ', 2, ARRAY[3])');
RETURN QUERY SELECT style_cost_flow('pgr_maxflowmincost_cost', ', ARRAY[2], 3)');
RETURN QUERY SELECT style_cost_flow('pgr_maxflowmincost_cost', ', ARRAY[2], ARRAY[3])');

END
$BODY$
LANGUAGE plpgsql VOLATILE;


SELECT inner_query();
SELECT finish();
ROLLBACK;
