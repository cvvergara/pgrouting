\i setup.sql

SELECT plan(24);

UPDATE edge_table SET cost = sign(cost) + 0.001 * id * id, reverse_cost = sign(reverse_cost) + 0.001 * id * id;

CREATE or REPLACE FUNCTION ComparePrimDDKruskalDD(distance FLOAT)
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
    prim_sql := 'SELECT ' || data || ' FROM pgr_primDD($$' || inner1_sql || '$$, 2, ' || distance || ')';
    kruskal_sql := 'SELECT ' || data || ' FROM pgr_kruskalDD($$' || inner1_sql || '$$, 2, ' || distance || ')';
    RETURN query SELECT set_eq(prim_sql, kruskal_sql, prim_sql);

    -----------------------
    -- Single vertex
    -- with out reverse cost
    -----------------------
    prim_sql := 'SELECT ' || data || ' FROM pgr_primDD($$' || inner2_sql || '$$, 2, ' || distance || ')';
    kruskal_sql := 'SELECT ' || data || ' FROM pgr_kruskalDD($$' || inner2_sql || '$$, 2, ' || distance || ')';
    RETURN query SELECT set_eq(prim_sql, kruskal_sql, prim_sql);

    -----------------------
    -- Multiple vertex
    -- with reverse cost
    -----------------------
    prim_sql := 'SELECT ' || data || ' FROM pgr_primDD($$' || inner1_sql || '$$, ' || vids || ', ' || distance || ')';
    kruskal_sql := 'SELECT ' || data || ' FROM pgr_kruskalDD($$' || inner1_sql || '$$, ' || vids || ', ' || distance || ')';
    RETURN query SELECT set_eq(prim_sql, kruskal_sql, prim_sql);

    -----------------------
    -- Multiple vertex
    -- with out reverse cost
    -----------------------
    prim_sql := 'SELECT ' || data || ' FROM pgr_primDD($$' || inner2_sql || '$$, ' || vids || ', ' || distance || ')';
    kruskal_sql := 'SELECT ' || data || ' FROM pgr_kruskalDD($$' || inner2_sql || '$$, ' || vids || ', ' || distance || ')';
    RETURN query SELECT set_eq(prim_sql, kruskal_sql, prim_sql);

    RETURN;
END
$BODY$
language plpgsql;

SELECT * from ComparePrimDDKruskalDD(0);
SELECT * from ComparePrimDDKruskalDD(1);
SELECT * from ComparePrimDDKruskalDD(2);
SELECT * from ComparePrimDDKruskalDD(3);
SELECT * from ComparePrimDDKruskalDD(4);
SELECT * from ComparePrimDDKruskalDD(5);


SELECT * FROM finish();
ROLLBACK;
