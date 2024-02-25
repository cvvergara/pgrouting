-- CopyRight(c) pgRouting developers
-- Creative Commons Attribution-Share Alike 3.0 License : https://creativecommons.org/licenses/by-sa/3.0/
-- TODO move to pgtap

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
  (104, 10, 40 , 1, -1, ST_MakeLine(ST_POINT(0,  2), ST_POINT(0,  0))),
  (301, 30, 10 , 1, -1, ST_MakeLine(ST_POINT(2,  0), ST_POINT(0,  2))),
  (203, 20, 30 , 1,  1, ST_MakeLine(ST_POINT(2,  2), ST_POINT(2,  0))),
  (304, 30, 40 , 1,  1, ST_MakeLine(ST_POINT(0,  0), ST_POINT(2,  0)));

SELECT *
FROM pgr_lineGraph('SELECT id, source, target, cost, reverse_cost FROM mathw_2', true);

CREATE TABLE mathw_3 (
    id BIGINT,
    source BIGINT,
    target BIGINT,
    cost FLOAT,
    reverse_cost FLOAT,
    geom geometry
);

INSERT INTO mathw_3 (id, source, target, cost, reverse_cost, geom) VALUES
  (102, 10, 20 , 1, -1, ST_MakeLine(ST_POINT(0,  2), ST_POINT(2,  2))),
  (104, 10, 40 , 1, -1, ST_MakeLine(ST_POINT(0,  2), ST_POINT(0,  0))),
  (301, 30, 10 , 1, -1, ST_MakeLine(ST_POINT(2,  0), ST_POINT(0,  2))),
  (203, 20, 30 , 1, -1, ST_MakeLine(ST_POINT(2,  2), ST_POINT(2,  0))),
  (304, 30, 40 , 1, -1, ST_MakeLine(ST_POINT(2,  0), ST_POINT(0,  0))),
  (302, 30, 20 , 1, -1, ST_MakeLine(ST_POINT(2,  0), ST_POINT(2,  2))),
  (403, 40, 30 , 1, -1, ST_MakeLine(ST_POINT(0,  0), ST_POINT(2,  0)));

SELECT *
FROM pgr_lineGraph('SELECT id, source, target, cost FROM mathw_3', true);

