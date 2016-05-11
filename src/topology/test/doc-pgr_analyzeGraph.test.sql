
BEGIN;


    ------------------------------------------------------------------------------------------------------
    ------------------------------------------------------------------------------------------------------
    --              PGR_analyzegraph
    ------------------------------------------------------------------------------------------------------
    ------------------------------------------------------------------------------------------------------
    --q01
    SELECT  pgr_createTopology('edge_table',0.001);
    SELECT  pgr_analyzeGraph('edge_table',0.001);
    --q02
    SELECT  pgr_analyzeGraph('edge_table',0.001,'the_geom','id','source','target');
    --q03
    SELECT  pgr_analyzeGraph('edge_table',0.001,the_geom:='the_geom',id:='id',source:='source',target:='target');
    --q04
    SELECT  pgr_analyzeGraph('edge_table',0.001,source:='source',id:='id',target:='target',the_geom:='the_geom');
    --q05
    SELECT  pgr_analyzeGraph('edge_table',0.001,source:='source');
    --q06
    SELECT  pgr_analyzeGraph('edge_table',0.001,rows_where:='id < 10');
    --q07
    SELECT  pgr_analyzeGraph('edge_table',0.001,rows_where:='the_geom && (SELECT st_buffer(the_geom,0.05) FROM edge_table WHERE id=5)');
    --q08
    DROP TABLE IF EXISTS otherTable;
    CREATE TABLE otherTable AS  (SELECT 100 AS gid, st_point(2.5,2.5) AS other_geom) ;
    SELECT  pgr_analyzeGraph('edge_table',0.001,rows_where:='the_geom && (SELECT st_buffer(other_geom,1) FROM otherTable WHERE gid=100)');
    --q09
    DROP TABLE IF EXISTS mytable;
    CREATE TABLE mytable AS (SELECT id AS gid, source AS src ,target AS tgt , the_geom AS mygeom FROM edge_table);
    SELECT pgr_createTopology('mytable',0.001,'mygeom','gid','src','tgt');
    --q10
    SELECT  pgr_analyzeGraph('mytable',0.001,'mygeom','gid','src','tgt');
    --q11
    SELECT  pgr_analyzeGraph('mytable',0.001,the_geom:='mygeom',id:='gid',source:='src',target:='tgt');
    --q12
    SELECT  pgr_analyzeGraph('mytable',0.001,source:='src',id:='gid',target:='tgt',the_geom:='mygeom');
    --q13
    SELECT  pgr_analyzeGraph('mytable',0.001,'mygeom','gid','src','tgt',rows_where:='gid < 10');
    --q14
    SELECT  pgr_analyzeGraph('mytable',0.001,source:='src',id:='gid',target:='tgt',the_geom:='mygeom',rows_where:='gid < 10');
    --q15
    SELECT  pgr_analyzeGraph('mytable',0.001,'mygeom','gid','src','tgt',
                                rows_where:='mygeom && (SELECT st_buffer(mygeom,1) FROM mytable WHERE gid=5)');

    --q16
    SELECT  pgr_analyzeGraph('mytable',0.001,source:='src',id:='gid',target:='tgt',the_geom:='mygeom',
                                rows_where:='mygeom && (SELECT st_buffer(mygeom,1) FROM mytable WHERE gid=5)');
    --q17
    DROP TABLE IF EXISTS otherTable;
    CREATE TABLE otherTable AS  (SELECT 'myhouse'::text AS place, st_point(2.5,2.5) AS other_geom) ;
    SELECT  pgr_analyzeGraph('mytable',0.001,'mygeom','gid','src','tgt',
                 rows_where:='mygeom && (SELECT st_buffer(other_geom,1) FROM otherTable WHERE place='||quote_literal('myhouse')||')');
    --q18
    SELECT  pgr_analyzeGraph('mytable',0.001,source:='src',id:='gid',target:='tgt',the_geom:='mygeom',
                 rows_where:='mygeom && (SELECT st_buffer(other_geom,1) FROM otherTable WHERE place='||quote_literal('myhouse')||')');
    --q19
    SELECT  pgr_createTopology('edge_table',0.001);
    SELECT pgr_analyzeGraph('edge_table', 0.001);
    --q20
    SELECT  pgr_analyzeGraph('edge_table',0.001,rows_where:='id < 10');
    --q21
    SELECT  pgr_analyzeGraph('edge_table',0.001,rows_where:='id >= 10');
    --q22
    SELECT pgr_createTopology('edge_table', 0.001,rows_where:='id <17');
    SELECT pgr_analyzeGraph('edge_table', 0.001);
    --q23
    SELECT pgr_createTopology('edge_table', 0.001,rows_where:='id <17');
    --q24
    SELECT pgr_analyzeGraph('edge_table', 0.001);
    --q25
    ROLLBACK;
