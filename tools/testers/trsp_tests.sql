
CREATE OR REPLACE FUNCTION compare_trsp_dijkstra_new(cant INTEGER, flag boolean, restrictions_sql TEXT)
RETURNS SETOF TEXT AS
$BODY$
DECLARE
  k INTEGER := 0;
  dijkstra_sql TEXT;
  trsp_sql TEXT;
  directed TEXT;
  msg TEXT;
BEGIN
  IF NOT min_version('3.4.0') THEN
    RETURN QUERY SELECT skip(1, 'pgr_signature added on 3.4.0');
    RETURN;
  END IF;

  directed = 'Undirected';
  IF flag THEN directed = 'Directed'; END IF;

  FOR i IN 1.. cant BY 2 LOOP
    FOR j IN 1..cant LOOP
      -- For related restrictions only when source and target are equal it is garanteed that the results are the same as
      -- dijkstra
      IF (restrictions_sql = 'related') THEN CONTINUE WHEN i != j; END IF;

      dijkstra_sql := 'SELECT seq, node, edge, cost::text FROM pgr_dijkstra($$with_reverse_cost$$, '
        || i || ', ' || j || ', ' || flag || ')';
      trsp_sql := 'SELECT seq, node, edge, cost::text from pgr_trsp($$with_reverse_cost$$, $$' || restrictions_sql ||'$$, '
        || i || ', ' || j || ', ' || flag || ')';
      msg := restrictions_sql || '-' || k || '-1 ' || directed || ', with reverse_cost from '  || i || ' to ' || j;
      RETURN QUERY SELECT set_eq(trsp_sql, dijkstra_sql, msg);

      dijkstra_sql := 'SELECT seq, node, edge, cost::text FROM pgr_dijkstra($$no_reverse_cost$$, '
        || i || ', ' || j || ', ' || flag || ')';
      trsp_sql := 'SELECT seq, node, edge, cost::text from pgr_trsp($$no_reverse_cost$$, $$' || restrictions_sql ||'$$, '
        || i || ', ' || j || ', ' || flag || ')';
      msg := restrictions_sql || '-' || k || '-2 ' || directed || ', NO reverse_cost from '  || i || ' to ' || j;
      RETURN QUERY SELECT set_eq(trsp_sql, dijkstra_sql, msg);

      k := k + 1;

    END LOOP;
  END LOOP;
END
$BODY$
language plpgsql;
