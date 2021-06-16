\i setup.sql

SELECT plan(28);

UPDATE edge_table SET cost = sign(cost) + 0.001 * id * id, reverse_cost = sign(reverse_cost) + 0.001 * id * id;

CREATE or REPLACE FUNCTION ComparePrimDFSKruskalDFS()
RETURNS SETOF TEXT AS
$BODY$
DECLARE
inner1_sql TEXT;
inner2_sql TEXT;
prim_sql TEXT;
kruskal_sql TEXT;
vids TEXT;
data TEXT;
BEGIN
  IF is_version_2() THEN
    RETURN QUERY
    SELECT skip (4, 'pgr_prim pgr_kruskal are new on 3.0.0');
    RETURN;
  END IF;

    inner1_sql := 'SELECT id, source, target, cost, reverse_cost FROM edge_table';
    inner2_sql := 'SELECT id, source, target, cost FROM edge_table';

    data := ' seq, depth, start_vid, node, edge,  cost::text, agg_cost::text ';
    vids := ' ARRAY[2, 5] ';


    -----------------------
    -- Single vertex
    -- with reverse cost
    -----------------------
    prim_sql := 'SELECT ' || data || ' FROM pgr_primDFS($$' || inner1_sql || '$$, 2)';
    kruskal_sql := 'SELECT ' || data || ' FROM pgr_kruskalDFS($$' || inner1_sql || '$$, 2)';
    RETURN query SELECT set_eq(prim_sql, kruskal_sql, prim_sql);

    -----------------------
    -- Single vertex
    -- with out reverse cost
    -----------------------
    prim_sql := 'SELECT ' || data || ' FROM pgr_primDFS($$' || inner2_sql || '$$, 2)';
    kruskal_sql := 'SELECT ' || data || ' FROM pgr_kruskalDFS($$' || inner2_sql || '$$, 2)';
    RETURN query SELECT set_eq(prim_sql, kruskal_sql, prim_sql);

    -----------------------
    -- Multiple vertex
    -- with reverse cost
    -----------------------
    prim_sql := 'SELECT ' || data || ' FROM pgr_primDFS($$' || inner1_sql || '$$, ' || vids || ')';
    kruskal_sql := 'SELECT ' || data || ' FROM pgr_kruskalDFS($$' || inner1_sql || '$$, ' || vids || ')';
    RETURN query SELECT set_eq(prim_sql, kruskal_sql, prim_sql);

    -----------------------
    -- Multiple vertex
    -- with out reverse cost
    -----------------------
    prim_sql := 'SELECT ' || data || ' FROM pgr_primDFS($$' || inner2_sql || '$$, ' || vids || ')';
    kruskal_sql := 'SELECT ' || data || ' FROM pgr_kruskalDFS($$' || inner2_sql || '$$, ' || vids || ')';
    RETURN query SELECT set_eq(prim_sql, kruskal_sql, prim_sql);

    RETURN;
END
$BODY$
language plpgsql;

CREATE or REPLACE FUNCTION ComparePrimDFSKruskalDFS(depth BIGINT)
RETURNS SETOF TEXT AS
$BODY$
DECLARE
inner1_sql TEXT;
inner2_sql TEXT;
prim_sql TEXT;
kruskal_sql TEXT;
vids TEXT;
data TEXT;
BEGIN
  IF is_version_2() THEN
    RETURN QUERY
    SELECT skip (4, 'pgr_prim pgr_kruskal are new on 3.0.0');
    RETURN;
  END IF;

    inner1_sql := 'SELECT id, source, target, cost, reverse_cost FROM edge_table';
    inner2_sql := 'SELECT id, source, target, cost FROM edge_table';

    data := ' seq, depth, start_vid, node, edge,  cost::text, agg_cost::text ';
    vids := ' ARRAY[2, 5] ';


    -----------------------
    -- Single vertex
    -- with reverse cost
    -----------------------
    prim_sql := 'SELECT ' || data || ' FROM pgr_primDFS($$' || inner1_sql || '$$, 2, ' || depth || ')';
    kruskal_sql := 'SELECT ' || data || ' FROM pgr_kruskalDFS($$' || inner1_sql || '$$, 2, ' || depth || ')';
    RETURN query SELECT set_eq(prim_sql, kruskal_sql, prim_sql);

    -----------------------
    -- Single vertex
    -- with out reverse cost
    -----------------------
    prim_sql := 'SELECT ' || data || ' FROM pgr_primDFS($$' || inner2_sql || '$$, 2, ' || depth || ')';
    kruskal_sql := 'SELECT ' || data || ' FROM pgr_kruskalDFS($$' || inner2_sql || '$$, 2, ' || depth || ')';
    RETURN query SELECT set_eq(prim_sql, kruskal_sql, prim_sql);

    -----------------------
    -- Multiple vertex
    -- with reverse cost
    -----------------------
    prim_sql := 'SELECT ' || data || ' FROM pgr_primDFS($$' || inner1_sql || '$$, ' || vids || ', ' || depth || ')';
    kruskal_sql := 'SELECT ' || data || ' FROM pgr_kruskalDFS($$' || inner1_sql || '$$, ' || vids || ', ' || depth || ')';
    RETURN query SELECT set_eq(prim_sql, kruskal_sql, prim_sql);

    -----------------------
    -- Multiple vertex
    -- with out reverse cost
    -----------------------
    prim_sql := 'SELECT ' || data || ' FROM pgr_primDFS($$' || inner2_sql || '$$, ' || vids || ', ' || depth || ')';
    kruskal_sql := 'SELECT ' || data || ' FROM pgr_kruskalDFS($$' || inner2_sql || '$$, ' || vids || ', ' || depth || ')';
    RETURN query SELECT set_eq(prim_sql, kruskal_sql, prim_sql);

    RETURN;
END
$BODY$
language plpgsql;

SELECT * from ComparePrimDFSKruskalDFS();
SELECT * from ComparePrimDFSKruskalDFS(0);
SELECT * from ComparePrimDFSKruskalDFS(1);
SELECT * from ComparePrimDFSKruskalDFS(2);
SELECT * from ComparePrimDFSKruskalDFS(3);
SELECT * from ComparePrimDFSKruskalDFS(4);
SELECT * from ComparePrimDFSKruskalDFS(5);


SELECT * FROM finish();
ROLLBACK;
