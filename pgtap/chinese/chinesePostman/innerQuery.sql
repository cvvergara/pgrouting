\i setup.sql

UPDATE edge_table SET cost = sign(cost), reverse_cost = sign(reverse_cost);
SELECT CASE WHEN is_version_2() THEN plan(1) ELSE plan(54) END;

CREATE OR REPLACE FUNCTION inner_query()
RETURNS SETOF TEXT AS
$BODY$
BEGIN

IF is_version_2() THEN
  RETURN QUERY
  SELECT skip(1, 'Function is new on 3.0.0');
  RETURN;
END IF;


RETURN QUERY
SELECT has_function('pgr_chinesepostman',
    ARRAY['text']);

RETURN QUERY
SELECT function_returns('pgr_chinesepostman',
    ARRAY['text'],
    'setof record');

DELETE FROM edge_table WHERE id > 16;

IF min_lib_version('3.1.1') THEN
  RETURN QUERY
  SELECT skip(52, 'Function is new on 3.0.0');
  RETURN;
END IF;

RETURN QUERY
SELECT style_dijkstra('pgr_chinesepostman', ')');


END;
$BODY$
LANGUAGE plpgsql;

SELECT inner_query();



SELECT finish();
ROLLBACK;
