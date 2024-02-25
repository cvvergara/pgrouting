-- CopyRight(c) pgRouting developers
-- Creative Commons Attribution-Share Alike 3.0 License : https://creativecommons.org/licenses/by-sa/3.0/
-- TODO move to pgtap

/* -- one edge graph */
SELECT * FROM pgr_lineGraph(
    'SELECT id, source, target, cost FROM edges WHERE id = 1'
);

/* -- two edge graphs */
SELECT * FROM pgr_lineGraph($$
    SELECT -id AS id, target, source, reverse_cost AS cost FROM edges WHERE id = 1
    UNION
    SELECT id, source, target, cost FROM edges WHERE id = 1
    $$
);
SELECT * FROM pgr_lineGraph($$
    SELECT id, target, source, reverse_cost AS cost FROM edges WHERE id = 1
    UNION
    SELECT -id AS id, source, target, cost FROM edges WHERE id = 1
    $$
);
SELECT * FROM pgr_lineGraph(
    'SELECT id, source, target, cost, reverse_cost FROM edges WHERE id = 1'
);
SELECT * FROM pgr_lineGraph(
    'SELECT id, source, target, cost, reverse_cost FROM edges WHERE id = 17'
);

/* example from wikipedia */
CREATE TABLE wiki_1 (
    id BIGINT,
    source BIGINT,
    target BIGINT,
    cost FLOAT,
    geom geometry
);

INSERT INTO wiki_1 (id, source, target, cost, geom) VALUES
  (405, 40, 50 , 1,  ST_MakeLine(ST_POINT(0,  0), ST_POINT(  2,  0))),
  (304, 30, 40 , 1,  ST_MakeLine(ST_POINT(0,  0), ST_POINT(  1,  1))),
  (104, 10, 40 , 1,  ST_MakeLine(ST_POINT(0,  2), ST_POINT(  0,  0))),
  (103, 10, 30 , 1,  ST_MakeLine(ST_POINT(0,  2), ST_POINT(  1,  1))),
  (205, 20, 50 , 1,  ST_MakeLine(ST_POINT(2,  0), ST_POINT(  2,  2))),
  (102, 10, 20 , 1,  ST_MakeLine(ST_POINT(0,  2), ST_POINT(  2,  2)));

SELECT *
FROM pgr_lineGraph('SELECT id, source, target, cost FROM wiki_1', false);

/* example from https://mathworld.wolfram.com/LineGraph.html */
CREATE TABLE mathw_1 (
    id BIGINT,
    source BIGINT,
    target BIGINT,
    cost FLOAT,
    geom geometry
);

INSERT INTO mathw_1 (id, source, target, cost, geom) VALUES
  (102, 10, 20 , 1,  ST_MakeLine(ST_POINT(0,  2), ST_POINT(  2,  2))),
  (104, 10, 40 , 1,  ST_MakeLine(ST_POINT(0,  2), ST_POINT(  0,  0))),
  (203, 20, 30 , 1,  ST_MakeLine(ST_POINT(2,  2), ST_POINT(  2,  0))),
  (304, 30, 40 , 1,  ST_MakeLine(ST_POINT(2,  0), ST_POINT(  0,  0))),
  (204, 20, 40 , 1,  ST_MakeLine(ST_POINT(2,  2), ST_POINT(  0,  0)));

SELECT *
FROM pgr_lineGraph('SELECT id, source, target, cost FROM mathw_1', false);

/* example from https://mathworld.wolfram.com/LineGraph.html */
CREATE TABLE mathw_2 (
    id BIGINT,
    source BIGINT,
    target BIGINT,
    cost FLOAT,
    reverse_cost FLOAT,
    geom geometry
);

INSERT INTO mathw_2 (id, source, target, cost, reverse_cost, geom) VALUES
  (102, 10, 20 , 1, -1, ST_MakeLine(ST_POINT(0,  2), ST_POINT(2,  2))),
  (103, 10, 30 , 1, -1, ST_MakeLine(ST_POINT(0,  2), ST_POINT(0,  0))),
  (401, 40, 10 , 1, -1, ST_MakeLine(ST_POINT(2,  0), ST_POINT(0,  2))),
  (204, 20, 30 , 1,  1, ST_MakeLine(ST_POINT(2,  2), ST_POINT(2,  0))),
  (304, 30, 40 , 1,  1, ST_MakeLine(ST_POINT(0,  0), ST_POINT(0,  2)));

SELECT *
FROM pgr_lineGraph('SELECT id, source, target, cost FROM mathw_2', true);

