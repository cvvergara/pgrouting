
BEGIN;


    ------------------------------------------------------------------------------------------------------
    ------------------------------------------------------------------------------------------------------
    --              PGR_analyzegraph
    ------------------------------------------------------------------------------------------------------
    ------------------------------------------------------------------------------------------------------
    \echo --q01
    SELECT  pgr_createTopology('edge_table',0.001);
    SELECT  pgr_analyzeGraph('edge_table',0.001);
    \echo --q02
    SELECT  pgr_analyzeGraph('edge_table',0.001,'the_geom','id','source','target');
    \echo --q03
    SELECT  pgr_analyzeGraph('edge_table',0.001,the_geom:='the_geom',id:='id',source:='source',target:='target');
    \echo --q04
    SELECT  pgr_analyzeGraph('edge_table',0.001,source:='source',id:='id',target:='target',the_geom:='the_geom');
    \echo --q05
    SELECT  pgr_analyzeGraph('edge_table',0.001,source:='source');
    \echo --q06
    SELECT  pgr_analyzeGraph('edge_table',0.001,rows_where:='id < 10');
    \echo --q07
    SELECT  pgr_analyzeGraph('edge_table',0.001,rows_where:='the_geom && (SELECT st_buffer(the_geom,0.05) FROM edge_table WHERE id=5)');
    \echo --q08
    DROP TABLE IF EXISTS otherTable;
    CREATE TABLE otherTable AS  (SELECT 100 AS gid, st_point(2.5,2.5) AS other_geom) ;
    SELECT  pgr_analyzeGraph('edge_table',0.001,rows_where:='the_geom && (SELECT st_buffer(other_geom,1) FROM otherTable WHERE gid=100)');
    \echo --q09
    DROP TABLE IF EXISTS mytable;
    CREATE TABLE mytable AS (SELECT id AS gid, source AS src ,target AS tgt , the_geom AS mygeom FROM edge_table);
    SELECT pgr_createTopology('mytable',0.001,'mygeom','gid','src','tgt');
    \echo --q10
    SELECT  pgr_analyzeGraph('mytable',0.001,'mygeom','gid','src','tgt');
    \echo --q11
    SELECT  pgr_analyzeGraph('mytable',0.001,the_geom:='mygeom',id:='gid',source:='src',target:='tgt');
    \echo --q12
    SELECT  pgr_analyzeGraph('mytable',0.001,source:='src',id:='gid',target:='tgt',the_geom:='mygeom');
    \echo --q13
    SELECT  pgr_analyzeGraph('mytable',0.001,'mygeom','gid','src','tgt',rows_where:='gid < 10');
    \echo --q14
    SELECT  pgr_analyzeGraph('mytable',0.001,source:='src',id:='gid',target:='tgt',the_geom:='mygeom',rows_where:='gid < 10');
    \echo --q15
    SELECT  pgr_analyzeGraph('mytable',0.001,'mygeom','gid','src','tgt',
                                rows_where:='mygeom && (SELECT st_buffer(mygeom,1) FROM mytable WHERE gid=5)');

    \echo --q16
    SELECT  pgr_analyzeGraph('mytable',0.001,source:='src',id:='gid',target:='tgt',the_geom:='mygeom',
                                rows_where:='mygeom && (SELECT st_buffer(mygeom,1) FROM mytable WHERE gid=5)');
    \echo --q17
    DROP TABLE IF EXISTS otherTable;
    CREATE TABLE otherTable AS  (SELECT 'myhouse'::text AS place, st_point(2.5,2.5) AS other_geom) ;
    SELECT  pgr_analyzeGraph('mytable',0.001,'mygeom','gid','src','tgt',
                 rows_where:='mygeom && (SELECT st_buffer(other_geom,1) FROM otherTable WHERE place='||quote_literal('myhouse')||')');
    \echo --q18
    SELECT  pgr_analyzeGraph('mytable',0.001,source:='src',id:='gid',target:='tgt',the_geom:='mygeom',
                 rows_where:='mygeom && (SELECT st_buffer(other_geom,1) FROM otherTable WHERE place='||quote_literal('myhouse')||')');
    \echo --q19
    SELECT  pgr_createTopology('edge_table',0.001);
    SELECT pgr_analyzeGraph('edge_table', 0.001);
    \echo --q20
    SELECT  pgr_analyzeGraph('edge_table',0.001,rows_where:='id < 10');
    \echo --q21
    SELECT  pgr_analyzeGraph('edge_table',0.001,rows_where:='id >= 10');
    \echo --q22
    SELECT pgr_createTopology('edge_table', 0.001,rows_where:='id <17');
    SELECT pgr_analyzeGraph('edge_table', 0.001);
    \echo --q23
    SELECT pgr_createTopology('edge_table', 0.001,rows_where:='id <17');
    \echo --q24
    SELECT pgr_analyzeGraph('edge_table', 0.001);
    \echo --q25
    ROLLBACK;
