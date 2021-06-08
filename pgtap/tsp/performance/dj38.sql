-- NAME: dj38
-- COMMENT : 38 locations in Djibouti
-- COMMENT : Derived from National Imagery and Mapping Agency data
-- COMMENT : This file is a corrected version of dj89, where duplications
-- COMMENT:  have been removed.  Thanks to Jay Muthuswamy and others for
-- COMMENT:  requesting data sets without duplications.
-- TYPE: TSP
-- DIMENSION: 38
-- EDGE_WEIGHT_TYPE: EUC_2D

CREATE EXTENSION pgtap;
CREATE EXTENSION pgrouting CASCADE;
DROP TABLE IF EXISTS dj38;
CREATE TABLE dj38 (id BIGINT, x FLOAT, y FLOAT, the_geom geometry);
COPY dj38 (id, x, y) FROM stdin WITH DELIMITER ' ';
1 11003.611100 42102.500000
2 11108.611100 42373.888900
3 11133.333300 42885.833300
4 11155.833300 42712.500000
5 11183.333300 42933.333300
6 11297.500000 42853.333300
7 11310.277800 42929.444400
8 11416.666700 42983.333300
9 11423.888900 43000.277800
10 11438.333300 42057.222200
11 11461.111100 43252.777800
12 11485.555600 43187.222200
13 11503.055600 42855.277800
14 11511.388900 42106.388900
15 11522.222200 42841.944400
16 11569.444400 43136.666700
17 11583.333300 43150.000000
18 11595.000000 43148.055600
19 11600.000000 43150.000000
20 11690.555600 42686.666700
21 11715.833300 41836.111100
22 11751.111100 42814.444400
23 11770.277800 42651.944400
24 11785.277800 42884.444400
25 11822.777800 42673.611100
26 11846.944400 42660.555600
27 11963.055600 43290.555600
28 11973.055600 43026.111100
29 12058.333300 42195.555600
30 12149.444400 42477.500000
31 12286.944400 43355.555600
32 12300.000000 42433.333300
33 12355.833300 43156.388900
34 12363.333300 43189.166700
35 12372.777800 42711.388900
36 12386.666700 43334.722200
37 12421.666700 42895.555600
38 12645.000000 42973.333300
\.


UPDATE dj38 SET the_geom = ST_makePoint(x,y);

DROP FUNCTION IF EXISTS test_dj38;
CREATE OR REPLACE FUNCTION test_dj38(upper_bound FLOAT)
RETURNS SETOF TEXT AS
$BODY$
BEGIN
    FOR i IN 1..38
 LOOP
        RETURN query
        SELECT is((SELECT agg_cost < 6656 * upper_bound
                FROM pgr_TSPeuclidean(
                    $$SELECT * FROM dj38$$, start_id => i) WHERE seq = (38
 + 1)),
            't',
            'start_id = ' || i || ' upper_bound = ' || upper_bound);
    END LOOP;
END;
$BODY$ LANGUAGE plpgsql;

SELECT plan(38
);
SELECT test_dj38(2);
SELECT finish();