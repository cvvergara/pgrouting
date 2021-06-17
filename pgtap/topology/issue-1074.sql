\i setup.sql

-- node the network
-- create 2 test cases with overlapping lines, one with crossing lines and one with touching (but no crossing) lines

UPDATE edge_table SET cost = sign(cost), reverse_cost = sign(reverse_cost);
SELECT plan(22);

CREATE OR REPLACE FUNCTION issue()
RETURNS SETOF TEXT AS
$BODY$
BEGIN
  IF is_version_2() THEN
    RETURN QUERY
    SELECT skip (22, 'issue 1074 fixed on 3.0.0');
    RETURN;
  END IF;

CREATE TABLE original (
      id serial NOT NULL PRIMARY KEY
);
PERFORM addgeometrycolumn('original', 'the_geom', 4326, 'LINESTRING', 2);


INSERT INTO original (id, the_geom) VALUES (1, 'SRID=4326;LineString (0 0, 2 1)');
INSERT INTO original (id, the_geom) VALUES (2, 'SRID=4326;LineString (0 2, 2 1)');
INSERT INTO original (id, the_geom) VALUES (3, 'SRID=4326;LineString (2 1, 5 1)');
INSERT INTO original (id, the_geom) VALUES (4, 'SRID=4326;LineString (1 2, 1 0)');
INSERT INTO original (id, the_geom) VALUES (5, 'SRID=4326;LineString (3 2, 3 0)');
INSERT INTO original (id, the_geom) VALUES (6, 'SRID=4326;LineString (4 2, 4 0)');
INSERT INTO original (id, the_geom) VALUES (7, 'SRID=4326;LineString (5 2, 5 0)');


RETURN QUERY
SELECT is((SELECT count(*)::INTEGER FROM original), 7, 'we have 7 original edges');
PERFORM pgr_nodeNetwork('original', 0.1, 'id', 'the_geom', 'roads', 'id IN (1, 2, 4, 6, 7)');
PERFORM pgr_nodeNetwork('original', 0.1, 'id', 'the_geom', 'bridges', 'id IN (3, 5)');
RETURN QUERY
SELECT is((SELECT count(*)::INTEGER FROM original_roads), 9, 'Now we have 9 edges');
RETURN QUERY
SELECT is((SELECT count(*)::INTEGER FROM original_bridges), 4, 'Now we have 4 edges');



CREATE TABLE original_noded (
	id bigserial PRIMARY KEY,
	old_id INTEGER,
	sub_id INTEGER,
	source BIGINT,
	target BIGINT,
	the_geom GEOMETRY(LINESTRING, 4326)
);
INSERT INTO original_noded (old_id, sub_id, source, target, the_geom)
SELECT old_id, sub_id, source, target, the_geom FROM original_roads
UNION
SELECT old_id, sub_id, source, target, the_geom FROM original_bridges;


PREPARE q1 AS
SELECT old_id, count(*) FROM original_noded GROUP BY old_id ORDER BY old_id;
prepare vals1 AS
VALUES (1,2),(2,2),(3,2),(4,3),(5,2),(6,1),(7,1);
RETURN QUERY
SELECT set_eq('q1', 'vals1',
    'For each original edge we have now the correct number of subedges');


  RETURN QUERY
SELECT is((SELECT count(*)::INTEGER FROM original_noded WHERE source is NULL), (SELECT count(*)::INTEGER FROM original_noded), 'all edges are missing source');
RETURN QUERY
SELECT is((SELECT count(*)::INTEGER FROM original_noded WHERE target is NULL), (SELECT count(*)::INTEGER FROM original_noded), 'all edges are missing target');
RETURN QUERY
SELECT hasnt_table('original_noded_vertices_pgr', 'original_noded_vertices_pgr table does not exist');

PERFORM pgr_createtopology('original_noded', 0.000001);

RETURN QUERY
SELECT has_table('original_noded_vertices_pgr', 'original_noded_vertices_pgr table now exist');
RETURN QUERY
SELECT is((SELECT count(*)::INTEGER FROM original_noded WHERE source is NULL), 0, '0 edges are missing source');
RETURN QUERY
SELECT is((SELECT count(*)::INTEGER FROM original_noded WHERE target is NULL), 0, '0 edges are missing target');
RETURN QUERY
SELECT is((SELECT count(*)::INTEGER FROM original_noded_vertices_pgr), 15, 'Now we have 15 vertices');
RETURN QUERY
SELECT is((SELECT count(*)::INTEGER FROM original_noded_vertices_pgr WHERE cnt is NULL), 15, '15 vertices are missing cnt');
RETURN QUERY
SELECT is((SELECT count(*)::INTEGER FROM original_noded_vertices_pgr WHERE chk is NULL), 15, '15 vertices are missing chk');
RETURN QUERY
SELECT is((SELECT count(*)::INTEGER FROM original_noded_vertices_pgr WHERE ein is NULL), 15, '15 vertices are missing ein');
RETURN QUERY
SELECT is((SELECT count(*)::INTEGER FROM original_noded_vertices_pgr WHERE eout is NULL), 15, '15 vertices are missing eout');

PERFORM pgr_analyzegraph('original_noded',  0.000001);

RETURN QUERY
SELECT is((SELECT count(*)::INTEGER FROM original_noded_vertices_pgr WHERE cnt is NULL), 0, '0 vertices are missing cnt');
RETURN QUERY
SELECT is((SELECT count(*)::INTEGER FROM original_noded_vertices_pgr WHERE chk is NULL), 0, '0 vertices are missing chk');
RETURN QUERY
SELECT is((SELECT count(*)::INTEGER FROM original_noded_vertices_pgr WHERE ein is NULL), 15, '15 vertices are missing ein');
RETURN QUERY
SELECT is((SELECT count(*)::INTEGER FROM original_noded_vertices_pgr WHERE eout is NULL), 15, '15 vertices are missing eout');
RETURN QUERY
SELECT is((SELECT count(*)::INTEGER FROM original_noded_vertices_pgr WHERE chk = 0), 14, 'In 14 vertices chk=0 aka have no problem');
RETURN QUERY
SELECT is((SELECT count(*)::INTEGER FROM original_noded_vertices_pgr WHERE chk = 1), 1, 'In 1 vertices chk=1 aka might have a gap near dead end');

PREPARE q2_bridges AS
SELECT cnt, count(*) AS M  FROM original_noded_vertices_pgr GROUP BY cnt ORDER BY cnt;
PREPARE vals2_bridges AS
VALUES (1,11), (3, 1), (4,3);

RETURN QUERY
SELECT set_eq('q2_bridges', 'vals2_bridges',
        'vertices referenced correctly by edges');

END
$BODY$
LANGUAGE plpgsql VOLATILE;

SELECT issue();

SELECT finish();
ROLLBACK;


