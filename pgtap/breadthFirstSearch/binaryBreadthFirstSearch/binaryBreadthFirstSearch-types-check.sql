\i setup.sql

UPDATE edge_table SET cost = sign(cost), reverse_cost = sign(reverse_cost);
SELECT CASE WHEN is_version_2() THEN plan(1) ELSE plan(18) END;

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
SELECT has_function('pgr_binarybreadthfirstsearch');

RETURN QUERY
SELECT has_function('pgr_binarybreadthfirstsearch', ARRAY['text','bigint','bigint','boolean']);

RETURN QUERY
SELECT has_function('pgr_binarybreadthfirstsearch', ARRAY['text','bigint','anyarray','boolean']);

RETURN QUERY
SELECT has_function('pgr_binarybreadthfirstsearch', ARRAY['text','anyarray','bigint','boolean']);

RETURN QUERY
SELECT has_function('pgr_binarybreadthfirstsearch', ARRAY['text','anyarray','anyarray','boolean']);

RETURN QUERY
SELECT function_returns('pgr_binarybreadthfirstsearch', ARRAY['text','bigint','bigint','boolean'],  'setof record');

RETURN QUERY
SELECT function_returns('pgr_binarybreadthfirstsearch', ARRAY['text','bigint','anyarray','boolean'],  'setof record');

RETURN QUERY
SELECT function_returns('pgr_binarybreadthfirstsearch', ARRAY['text','anyarray','bigint','boolean'],  'setof record');

RETURN QUERY
SELECT function_returns('pgr_binarybreadthfirstsearch', ARRAY['text','anyarray','anyarray','boolean'],  'setof record');

RETURN QUERY
SELECT bag_has(
    $$SELECT  proargnames from pg_proc where proname = 'pgr_binarybreadthfirstsearch'$$,
    $$SELECT  '{"","","","directed","seq","path_seq","node","edge","cost","agg_cost"}'::TEXT[] $$
);

RETURN QUERY
SELECT bag_has(
    $$SELECT  proargnames from pg_proc where proname = 'pgr_binarybreadthfirstsearch'$$,
    $$SELECT  '{"","","","directed","seq","path_seq","start_vid","node","edge","cost","agg_cost"}'::TEXT[] $$
);

RETURN QUERY
SELECT bag_has(
    $$SELECT  proargnames from pg_proc where proname = 'pgr_binarybreadthfirstsearch'$$,
    $$SELECT  '{"","","","directed","seq","path_seq","end_vid","node","edge","cost","agg_cost"}'::TEXT[] $$
);

RETURN QUERY
SELECT bag_has(
    $$SELECT  proargnames from pg_proc where proname = 'pgr_binarybreadthfirstsearch'$$,
    $$SELECT  '{"","","","directed","seq","path_seq","start_vid","end_vid","node","edge","cost","agg_cost"}'::TEXT[] $$
);

RETURN QUERY
SELECT set_has(
    $$SELECT  proallargtypes from pg_proc where proname = 'pgr_binarybreadthfirstsearch'$$,
    $$VALUES
        ('{25,20,20,16,23,23,20,20,701,701}'::OID[]),
        ('{25,20,2277,16,23,23,20,20,20,701,701}'::OID[]),
        ('{25,2277,20,16,23,23,20,20,20,701,701}'::OID[]),
        ('{25,2277,2277,16,23,23,20,20,20,20,701,701}'::OID[])
    $$
);

-- new signature on 3.2
RETURN QUERY
SELECT CASE
WHEN is_version_2() OR NOT test_min_version('3.2.0') THEN
  skip(4, 'Combinations functiontionality new on 3.2.0')
WHEN test_min_version('3.2.0') THEN
  collect_tap(
    has_function('pgr_binarybreadthfirstsearch', ARRAY['text','text','boolean']),
    function_returns('pgr_binarybreadthfirstsearch', ARRAY['text','text','boolean'], 'setof record'),
    set_has(
      $$SELECT  proargnames from pg_proc where proname = 'pgr_binarybreadthfirstsearch'$$,
      $$SELECT  '{"","",directed,seq,path_seq,start_vid,end_vid,node,edge,cost,agg_cost}'::TEXT[] $$
    ),
    set_has(
      $$SELECT  proallargtypes from pg_proc where proname = 'pgr_binarybreadthfirstsearch'$$,
      $$VALUES ('{25,25,16,23,23,20,20,20,20,701,701}'::OID[]) $$
    )
  )
END;

END;
$BODY$
LANGUAGE plpgsql;

SELECT types_check();

SELECT * FROM finish();
ROLLBACK;
