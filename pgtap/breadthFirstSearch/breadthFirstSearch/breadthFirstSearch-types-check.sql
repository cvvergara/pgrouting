\i setup.sql

UPDATE edge_table SET cost = sign(cost), reverse_cost = sign(reverse_cost);
SELECT CASE WHEN is_version_2() THEN plan(1) ELSE plan(7) END;

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
SELECT has_function('pgr_breadthfirstsearch');


RETURN QUERY
SELECT has_function('pgr_breadthfirstsearch', ARRAY['text','bigint','bigint','boolean']);

RETURN QUERY
SELECT has_function('pgr_breadthfirstsearch', ARRAY['text','anyarray','bigint','boolean']);

RETURN QUERY
SELECT function_returns('pgr_breadthfirstsearch', ARRAY['text','bigint','bigint','boolean'],  'setof record');

RETURN QUERY
SELECT function_returns('pgr_breadthfirstsearch', ARRAY['text','anyarray','bigint','boolean'],  'setof record');

-- pgr_breadthfirstsearch
-- parameter names

RETURN QUERY
SELECT set_eq(
    $$SELECT  proargnames from pg_proc where proname = 'pgr_breadthfirstsearch'$$,
    $$VALUES
        ('{"","","max_depth","directed","seq","depth","start_vid","node","edge","cost","agg_cost"}'::TEXT[])
    $$
);

-- parameter types

RETURN QUERY
SELECT set_eq(
    $$SELECT  proallargtypes from pg_proc where proname = 'pgr_breadthfirstsearch'$$,
    $$VALUES
        ('{25,20,20,16,20,20,20,20,20,701,701}'::OID[]),
        ('{25,2277,20,16,20,20,20,20,20,701,701}'::OID[])
    $$
);

END;
$BODY$
LANGUAGE plpgsql;

SELECT types_check();
SELECT finish();
ROLLBACK;
