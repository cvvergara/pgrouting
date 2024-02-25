-- CopyRight(c) pgRouting developers
-- Creative Commons Attribution-Share Alike 3.0 License : https://creativecommons.org/licenses/by-sa/3.0/
-- TODO move to pgtap

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
