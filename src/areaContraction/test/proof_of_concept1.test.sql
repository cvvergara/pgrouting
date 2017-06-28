\echo --q1
SELECT * FROM pgr_dijkstra(
  'SELECT * FROM edge_table', ARRAY[1,4,7,13],  ARRAY[1,4,7,13]);

\echo -- q2
WITH
a AS (SELECT * FROM pgr_dijkstra(
  'SELECT * FROM edge_table', ARRAY[1,4,7,13],  ARRAY[1,4,7,13])
  WHERE edge<>-1) SELECT edge,node AS source,cost FROM a GROUP BY edge,source,cost;

\echo -- q3
WITH
a AS (SELECT * from pgr_dijkstra(
          'SELECT * FROM edge_table', ARRAY[1,4,7,13],  ARRAY[1,4,7,13]) where edge<>-1),
b AS (SELECT edge as id,node as source,cost from a group by id,source,cost),
c AS (SELECT id, source, target, cost FROM edge_table),
d AS (SELECT b.id,b.source,target,c.cost from b join c on b.id=c.id)
select * from d;

\echo --q4
WITH
a AS (SELECT * from pgr_dijkstra(
          'SELECT * FROM edge_table', ARRAY[1,4,7,13],  ARRAY[1,4,7,13]) where edge<>-1),
b AS (SELECT edge as id,node as source,cost from a group by id,source,cost),
c AS (SELECT id, source, target, cost FROM edge_table),
d AS (SELECT b.id,b.source,
  CASE WHEN b.source=c.source THEN c.target
       ELSE c.source END as target,
  c.cost from b join c on b.id=c.id)
select * from d;
