\i setup.sql

UPDATE edge_table SET cost = sign(cost), reverse_cost = sign(reverse_cost);
SELECT CASE WHEN is_version_2() THEN plan(1) ELSE plan(56) END;

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
SELECT has_function('pgr_chinesepostmancost',
    ARRAY['text']);

RETURN QUERY
SELECT function_returns('pgr_chinesepostmancost',
    ARRAY['text'],
    'double precision');

DELETE FROM edge_table WHERE id > 10;

RETURN QUERY
SELECT style_dijkstra('pgr_chinesepostmancost', ')');

END;
$BODY$
LANGUAGE plpgsql;

SELECT inner_query();



SELECT finish();
ROLLBACK;
