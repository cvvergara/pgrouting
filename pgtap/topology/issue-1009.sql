\i setup.sql

-- node the network

UPDATE edge_table SET cost = sign(cost), reverse_cost = sign(reverse_cost);
SELECT plan(20);

CREATE OR REPLACE FUNCTION issue()
RETURNS SETOF TEXT AS
$BODY$
BEGIN
  IF is_version_2() THEN
    RETURN QUERY
    SELECT skip (20, 'issue 1009 fixed on 3.0.0');
    RETURN;
  END IF;

CREATE TABLE "test_graph" (gid serial,
    "id" numeric(10,0),
    "nom" varchar(80)
);
ALTER TABLE "test_graph" ADD PRIMARY KEY (gid);
PERFORM AddGeometryColumn('','test_graph','geom','25831','LINESTRING',2);


INSERT INTO "test_graph" ("id","nom",geom) VALUES ('3',NULL,'0102000020E764000008000000F281433F6B731A41C84583B869855141592275DD14731A41C89C7A7D73855141B3E5D70CD3721A4164B5681680855141BFC2A67BBE721A419A3856BE8585514137F861B0A1721A41D72C1EC58F855141D87C445995721A413DC21EB6968551416D2458939D721A41DFF4EFE89D85514137F861B0A1721A411578DD90A3855141');
INSERT INTO "test_graph" ("id","nom",geom) VALUES ('5',NULL,'0102000020E76400000900000065D6DA5A51701A410D5914A88B855141DA9E3C70E5701A4106E8394987855141ADE2BBDC85711A415E9B857C85855141C32F009B0D721A416B2643758485514150B2FF8D78721A41A8C313B784855141BFC2A67BBE721A419A3856BE85855141930626E85E731A4135FA4C92888551414E90077728741A418D04908A90855141A5E6108797741A41F399907B97855141');


RETURN QUERY
SELECT is((SELECT count(*)::INTEGER FROM test_graph), 2, 'we have 2 test_graph edges');
PERFORM pgr_nodenetwork ('test_Graph', 0.01, 'gid', 'geom');
RETURN QUERY
SELECT is((SELECT count(*)::INTEGER FROM test_graph_noded), 4, 'Now we have 4 edges');


PREPARE q1 AS
SELECT old_id, count(*) FROM test_graph_noded GROUP BY old_id ORDER BY old_id;
prepare vals1 AS
VALUES (1,2),(2,2);
RETURN QUERY
SELECT set_eq('q1', 'vals1',
    'For each test_graph edge we have now 2 subedges');


RETURN QUERY
SELECT is((SELECT count(*)::INTEGER FROM test_graph_noded WHERE source is NULL), (SELECT count(*)::INTEGER FROM test_graph_noded), 'all edges are missing source');
RETURN QUERY
SELECT is((SELECT count(*)::INTEGER FROM test_graph_noded WHERE target is NULL), (SELECT count(*)::INTEGER FROM test_graph_noded), 'all edges are missing target');
RETURN QUERY
SELECT hasnt_table('test_graph_noded_vertices_pgr', 'test_graph_noded_vertices_pgr table does not exist');

PERFORM pgr_createtopology('test_graph_noded', 0.000001, 'geom', 'id');

RETURN QUERY
SELECT has_table('test_graph_noded_vertices_pgr', 'test_graph_noded_vertices_pgr table now exist');

RETURN QUERY
SELECT is((SELECT count(*)::INTEGER FROM test_graph_noded WHERE source is NULL), 0, '0 edges are missing source');

RETURN QUERY
SELECT is((SELECT count(*)::INTEGER FROM test_graph_noded WHERE target is NULL), 0, '0 edges are missing target');

RETURN QUERY
SELECT is((SELECT count(*)::INTEGER FROM test_graph_noded_vertices_pgr), 5, 'Now we have 5 vertices');

RETURN QUERY
SELECT is((SELECT count(*)::INTEGER FROM test_graph_noded_vertices_pgr WHERE cnt is NULL), 5, '5 vertices are missing cnt');

RETURN QUERY
SELECT is((SELECT count(*)::INTEGER FROM test_graph_noded_vertices_pgr WHERE chk is NULL), 5, '5 vertices are missing chk');

RETURN QUERY
SELECT is((SELECT count(*)::INTEGER FROM test_graph_noded_vertices_pgr WHERE ein is NULL), 5, '5 vertices are missing ein');

RETURN QUERY
SELECT is((SELECT count(*)::INTEGER FROM test_graph_noded_vertices_pgr WHERE eout is NULL), 5, '5 vertices are missing eout');


PERFORM pgr_analyzegraph('test_graph_noded',  0.000001, 'geom');

RETURN QUERY
SELECT is((SELECT count(*)::INTEGER FROM test_graph_noded_vertices_pgr WHERE cnt is NULL), 0, '0 vertices are missing cnt');

RETURN QUERY
SELECT is((SELECT count(*)::INTEGER FROM test_graph_noded_vertices_pgr WHERE chk is NULL), 0, '0 vertices are missing chk');

RETURN QUERY
SELECT is((SELECT count(*)::INTEGER FROM test_graph_noded_vertices_pgr WHERE ein is NULL), 5, '5 vertices are missing ein');

RETURN QUERY
SELECT is((SELECT count(*)::INTEGER FROM test_graph_noded_vertices_pgr WHERE eout is NULL), 5, '5 vertices are missing eout');

RETURN QUERY
SELECT is((SELECT count(*)::INTEGER FROM test_graph_noded_vertices_pgr WHERE chk = 0), 5, 'In 5 vertices chk=0 aka have no problem');

PREPARE q2 AS
SELECT cnt, count(*) AS M  FROM test_graph_noded_vertices_pgr GROUP BY cnt ORDER BY cnt;
PREPARE vals2 AS
VALUES (1,4), (4, 1);

RETURN QUERY
SELECT set_eq('q2', 'vals2',
        'vertices referenced correctly by edges');

END
$BODY$
LANGUAGE plpgsql VOLATILE;

SELECT issue();

SELECT finish();
ROLLBACK;


