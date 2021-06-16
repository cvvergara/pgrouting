\i setup.sql

UPDATE edge_table SET cost = sign(cost), reverse_cost = sign(reverse_cost);
SELECT plan(9);


CREATE OR REPLACE FUNCTION no_crash()
RETURNS SETOF TEXT AS
$BODY$
DECLARE
params TEXT[];
subs TEXT[];
BEGIN
  IF is_version_2() THEN
    RETURN QUERY
    SELECT skip (9, 'pgr_prim is new on 3.0.0');
    RETURN;
  END IF;

  PREPARE edges AS
  SELECT id, source, target, cost, reverse_cost  FROM edge_table;

  RETURN QUERY
  SELECT isnt_empty('edges', 'Should be not empty to tests be meaningful');

    -- prim with no root vertex
    params = ARRAY[
    '$$SELECT id, source, target, cost, reverse_cost  FROM edge_table$$'
    ]::TEXT[];

    subs = ARRAY[
    'NULL'
    ]::TEXT[];

    RETURN query SELECT * FROM no_crash_test('pgr_prim', params, subs);

    params[1] := '$$edges$$';
    RETURN query SELECT * FROM no_crash_test('pgr_prim', params, subs);

END
$BODY$
LANGUAGE plpgsql VOLATILE;


SELECT * FROM no_crash();
SELECT finish();

ROLLBACK;
