\i setup.sql

UPDATE edge_table SET cost = sign(cost), reverse_cost = sign(reverse_cost);
SELECT plan(54);

PREPARE edges AS
SELECT the_geom AS geom FROM edge_table;

PREPARE edges1 AS
SELECT id, the_geom AS geom FROM edge_table;

PREPARE edges2 AS
SELECT ST_startPoint(the_geom) AS startpoint, ST_startPoint(the_geom) AS endpoint FROM edge_table;

PREPARE edges3 AS
SELECT id, ST_startPoint(the_geom) AS startpoint, ST_startPoint(the_geom) AS endpoint FROM edge_table;

PREPARE edges4 AS
SELECT source, target FROM edge_table;

PREPARE edges5 AS
SELECT id, source, target FROM edge_table;


CREATE OR REPLACE FUNCTION no_crash()
RETURNS SETOF TEXT AS
$BODY$
DECLARE
params TEXT[];
subs TEXT[];
BEGIN
  IF is_version_2() THEN
    RETURN QUERY
    SELECT skip (54, 'pgr_extractvertices is new on 3.0.0');
    RETURN;
  END IF;

  RETURN QUERY
  SELECT isnt_empty('edges', 'Should be not empty to tests be meaningful');
  RETURN QUERY
  SELECT isnt_empty('edges1', 'Should be not empty to tests be meaningful');
  RETURN QUERY
  SELECT isnt_empty('edges2', 'Should be not empty to tests be meaningful');
  RETURN QUERY
  SELECT isnt_empty('edges3', 'Should be not empty to tests be meaningful');
  RETURN QUERY
  SELECT isnt_empty('edges4', 'Should be not empty to tests be meaningful');
  RETURN QUERY
  SELECT isnt_empty('edges5', 'Should be not empty to tests be meaningful');

    -- with geometry
    params = ARRAY[
    '$$SELECT the_geom AS geom FROM edge_table$$'
    ]::TEXT[];

    subs = ARRAY[
    'NULL'
    ]::TEXT[];

    RETURN query SELECT * FROM no_crash_test('pgr_extractVertices', params, subs);

    params[1] := '$$edges$$';
    RETURN query SELECT * FROM no_crash_test('pgr_extractVertices', params, subs);

    -- with geometry and id
    params = ARRAY[
    '$$SELECT id, the_geom AS geom FROM edge_table$$'
    ]::TEXT[];

    RETURN query SELECT * FROM no_crash_test('pgr_extractVertices', params, subs);

    params[1] := '$$edges1$$';
    RETURN query SELECT * FROM no_crash_test('pgr_extractVertices', params, subs);

    -- with startpoint & endpoint
    params = ARRAY[
    '$$SELECT ST_startPoint(the_geom) AS startpoint, ST_startPoint(the_geom) AS endpoint FROM edge_table$$'
    ]::TEXT[];

    RETURN query SELECT * FROM no_crash_test('pgr_extractVertices', params, subs);

    params[1] := '$$edges2$$';
    RETURN query SELECT * FROM no_crash_test('pgr_extractVertices', params, subs);

    -- with startpoint & endpoint and id
    params = ARRAY[
    '$$SELECT id, ST_startPoint(the_geom) AS startpoint, ST_startPoint(the_geom) AS endpoint FROM edge_table$$'
    ]::TEXT[];

    RETURN query SELECT * FROM no_crash_test('pgr_extractVertices', params, subs);

    params[1] := '$$edges3$$';
    RETURN query SELECT * FROM no_crash_test('pgr_extractVertices', params, subs);

    -- with source & target
    params = ARRAY[
    '$$SELECT source, target FROM edge_table$$'
    ]::TEXT[];

    RETURN query SELECT * FROM no_crash_test('pgr_extractVertices', params, subs);

    params[1] := '$$edges3$$';
    RETURN query SELECT * FROM no_crash_test('pgr_extractVertices', params, subs);

    -- with source & target & id
    params = ARRAY[
    '$$SELECT id, source, target FROM edge_table$$'
    ]::TEXT[];

    RETURN query SELECT * FROM no_crash_test('pgr_extractVertices', params, subs);

    params[1] := '$$edges3$$';
    RETURN query SELECT * FROM no_crash_test('pgr_extractVertices', params, subs);

END
$BODY$
LANGUAGE plpgsql VOLATILE;


SELECT no_crash();
SELECT finish();

ROLLBACK;
