
CREATE OR REPLACE FUNCTION test_min_version(min_version TEXT)
RETURNS BOOLEAN AS
$BODY$
WITH
  current_version AS (SELECT string_to_array(regexp_replace((SELECT library FROM pgr_full_version()), '.*-', '', 'g'),'.')::int[] AS version),
  asked_version AS (SELECT string_to_array(min_version, '.')::int[] AS version)
  SELECT (a.version >= b.version) FROM current_version AS a, asked_version AS b;
$BODY$
LANGUAGE SQL;


