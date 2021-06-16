\i setup.sql

SELECT plan(1296);

SET client_min_messages TO ERROR;

UPDATE edge_table SET cost = sign(cost) + 0.001 * id * id, reverse_cost = sign(reverse_cost) + 0.001 * id * id;


CREATE or REPLACE FUNCTION dijkstratrsp_compare_dijkstra(i INTEGER, j INTEGER)
RETURNS SETOF TEXT AS
$BODY$
DECLARE
inner_sql TEXT;
restricted_sql TEXT;
dijkstra_sql TEXT;
dijkstratr_sql TEXT;
BEGIN

    restricted_sql := 'SELECT * FROM new_restrictions WHERE id > 10';

    -- DIRECTED with reverse cost
    inner_sql := 'SELECT id, source, target, cost, reverse_cost FROM edge_table';
    dijkstra_sql := 'SELECT * FROM pgr_dijkstra($$' || inner_sql || '$$, ' || i || ', ' || j
        || ', true)';

    dijkstratr_sql := 'SELECT seq, path_seq, node, edge, cost, agg_cost FROM pgr_turnrestrictedpath($$' || inner_sql || '$$, $$' || restricted_sql || '$$, '|| i || ', ' || j
        || ', 3, true)';
    RETURN QUERY SELECT set_eq(dijkstratr_sql, dijkstra_sql, dijkstratr_sql);

    -- UNDIRECTED with reverse_cost
    inner_sql := 'SELECT id, source, target, cost, reverse_cost FROM edge_table';
    dijkstra_sql := 'SELECT * FROM pgr_dijkstra($$' || inner_sql || '$$, ' || i || ', ' || j
        || ', false)';
    dijkstratr_sql := 'SELECT  seq, path_seq, node, edge, cost, agg_cost FROM pgr_turnrestrictedpath($$' || inner_sql || '$$, $$' || restricted_sql || '$$, '|| i || ', ' || j
        || ', 3, false)';
    RETURN QUERY SELECT set_eq(dijkstratr_sql, dijkstra_sql, dijkstratr_sql);

    -- DIRECTED without reverse_cost
    inner_sql := 'SELECT id, source, target, cost FROM edge_table';
    dijkstra_sql := 'SELECT * FROM pgr_dijkstra($$' || inner_sql || '$$, ' || i || ', ' || j
        || ', true)';

    dijkstratr_sql := 'SELECT  seq, path_seq, node, edge, cost, agg_cost FROM pgr_turnrestrictedpath($$' || inner_sql || '$$, $$' || restricted_sql || '$$, '|| i || ', ' || j
        || ', 3, true)';
    RETURN QUERY SELECT set_eq(dijkstratr_sql, dijkstra_sql, dijkstratr_sql);

    -- UNDIRECTED without reverse_cost
    inner_sql := 'SELECT id, source, target, cost FROM edge_table';
    dijkstra_sql := 'SELECT * FROM pgr_dijkstra($$' || inner_sql || '$$, ' || i || ', ' || j
        || ', false)';

    dijkstratr_sql := 'SELECT  seq, path_seq, node, edge, cost, agg_cost FROM pgr_turnrestrictedpath($$' || inner_sql || '$$, $$' || restricted_sql || '$$, '|| i || ', ' || j
        || ', 3, false)';
    RETURN QUERY SELECT set_eq(dijkstratr_sql, dijkstra_sql, dijkstratr_sql);



    RETURN;
END
$BODY$
language plpgsql;


CREATE or REPLACE FUNCTION turnrestricted_compare_dijkstra(i INTEGER, j INTEGER)
RETURNS SETOF TEXT AS
$BODY$
BEGIN
  FOR a IN 1..j LOOP
    RETURN QUERY SELECT * from dijkstratrsp_compare_dijkstra(i, a);
  END LOOP;
END;
$BODY$
language plpgsql;

CREATE or REPLACE FUNCTION compare_dijkstra()
RETURNS SETOF TEXT AS
$BODY$
BEGIN
  IF is_version_2() THEN
    RETURN QUERY
    SELECT skip (1296, 'pgr_turnrestrictedpath was added on 3.0.0');
    RETURN;
  END IF;

  RETURN QUERY
  SELECT * from turnrestricted_compare_dijkstra(1, 18);
  RETURN QUERY
  SELECT * from turnrestricted_compare_dijkstra(2, 18);
  RETURN QUERY
  SELECT * from turnrestricted_compare_dijkstra(3, 18);
  RETURN QUERY
  SELECT * from turnrestricted_compare_dijkstra(4, 18);
  RETURN QUERY
  SELECT * from turnrestricted_compare_dijkstra(5, 18);
  RETURN QUERY
  SELECT * from turnrestricted_compare_dijkstra(6, 18);
  RETURN QUERY
  SELECT * from turnrestricted_compare_dijkstra(7, 18);
  RETURN QUERY
  SELECT * from turnrestricted_compare_dijkstra(8, 18);
  RETURN QUERY
  SELECT * from turnrestricted_compare_dijkstra(9, 18);
  RETURN QUERY
  SELECT * from turnrestricted_compare_dijkstra(10, 18);
  RETURN QUERY
  SELECT * from turnrestricted_compare_dijkstra(11, 18);
  RETURN QUERY
  SELECT * from turnrestricted_compare_dijkstra(12, 18);
  RETURN QUERY
  SELECT * from turnrestricted_compare_dijkstra(13, 18);
  RETURN QUERY
  SELECT * from turnrestricted_compare_dijkstra(14, 18);
  RETURN QUERY
  SELECT * from turnrestricted_compare_dijkstra(15, 18);
  RETURN QUERY
  SELECT * from turnrestricted_compare_dijkstra(16, 18);
  RETURN QUERY
  SELECT * from turnrestricted_compare_dijkstra(17, 18);
  RETURN QUERY
  SELECT * from turnrestricted_compare_dijkstra(18, 18);
END
$BODY$
language plpgsql;

SELECT compare_dijkstra();
SELECT finish();
ROLLBACK;
