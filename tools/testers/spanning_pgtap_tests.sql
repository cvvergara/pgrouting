CREATE OR REPLACE FUNCTION inner_query_spanning(fn_name TEXT, ending TEXT)
RETURNS SETOF TEXT AS
$BODY$
DECLARE
BEGIN
  IF is_version_2() THEN
    RETURN QUERY
    SELECT skip (54, fn_name || ' is new on 3.0.0');
    RETURN;
  END IF;

  RETURN QUERY
  SELECT style_dijkstra(fn_name, ending);

END
$BODY$
LANGUAGE plpgsql VOLATILE;

