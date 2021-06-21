\i setup.sql
UPDATE edge_table SET cost = sign(cost), reverse_cost = sign(reverse_cost);
SELECT CASE WHEN is_version_2() THEN plan(1) ELSE plan(15) END;

CREATE OR REPLACE FUNCTION types_check()
RETURNS SETOF TEXT AS
$BODY$
BEGIN

IF is_version_2() THEN
  RETURN QUERY
  SELECT skip(1, 'Function is new on 3.0.0');
  RETURN;
END IF;


RETURN QUERY
SELECT has_function('pgr_dagshortestpath');

RETURN QUERY
SELECT has_function('pgr_dagshortestpath', ARRAY[ 'text', 'bigint', 'bigint' ]);
RETURN QUERY
SELECT has_function('pgr_dagshortestpath', ARRAY[ 'text', 'anyarray', 'bigint' ]);
RETURN QUERY
SELECT has_function('pgr_dagshortestpath', ARRAY[ 'text', 'bigint', 'anyarray' ]);
RETURN QUERY
SELECT has_function('pgr_dagshortestpath', ARRAY[ 'text', 'anyarray', 'anyarray' ]);

RETURN QUERY
SELECT function_returns('pgr_dagshortestpath', ARRAY[ 'text', 'bigint', 'bigint' ], 'setof record');
RETURN QUERY
SELECT function_returns('pgr_dagshortestpath', ARRAY[ 'text', 'anyarray', 'bigint' ], 'setof record');
RETURN QUERY
SELECT function_returns('pgr_dagshortestpath', ARRAY[ 'text', 'bigint', 'anyarray' ], 'setof record');
RETURN QUERY
SELECT function_returns('pgr_dagshortestpath', ARRAY[ 'text', 'anyarray', 'anyarray' ], 'setof record');

-- testing column names
RETURN QUERY
SELECT set_has(
    $$SELECT  proargnames from pg_proc where proname = 'pgr_dagshortestpath'$$,
    $$SELECT  '{"","","","seq","path_seq","node","edge","cost","agg_cost"}'::TEXT[] $$
);

-- parameter types
RETURN QUERY
SELECT set_has(
    $$SELECT  proallargtypes from pg_proc where proname = 'pgr_dagshortestpath'$$,
    $$VALUES
        ('{25,20,20,23,23,20,20,701,701}'::OID[]),
        ('{25,20,2277,23,23,20,20,701,701}'::OID[]),
        ('{25,2277,20,23,23,20,20,701,701}'::OID[]),
        ('{25,2277,2277,23,23,20,20,701,701}'::OID[])
    $$
);

-- new signature on 3.2
RETURN QUERY
SELECT CASE
WHEN is_version_2() OR NOT test_min_version('3.2.0') THEN
  skip(4, 'Combinations functiontionality new on 3.2.0')
WHEN test_min_version('3.2.0') THEN
  collect_tap(
    has_function('pgr_dagshortestpath', ARRAY['text','text']),
    function_returns('pgr_dagshortestpath', ARRAY['text','text'], 'setof record'),
    set_has(
      $$SELECT  proargnames from pg_proc where proname = 'pgr_dagshortestpath'$$,
      $$SELECT  '{"","",seq,path_seq,node,edge,cost,agg_cost}'::TEXT[] $$
    ),
    set_has(
      $$SELECT  proallargtypes from pg_proc where proname = 'pgr_dagshortestpath'$$,
      $$VALUES ('{25,25,23,23,20,20,701,701}'::OID[]) $$
    )
  )
END;

END;
$BODY$
LANGUAGE plpgsql;

SELECT types_check();

SELECT finish();
ROLLBACK;
