\i setup.sql

UPDATE edge_table SET cost = sign(cost), reverse_cost = sign(reverse_cost);
SELECT CASE WHEN is_version_2() THEN plan(1) ELSE plan(1156) END;

-- Compare final row of result (Only final row due to existence of multiple valid paths)

CREATE or REPLACE FUNCTION binaryBreadthFirstSearch_compare_dijkstra(max_limit INTEGER default 17)
RETURNS SETOF TEXT AS
$BODY$
DECLARE
inner_sql TEXT;
dijkstra_sql TEXT;
binaryBreadthFirstSearch TEXT;
BEGIN
  IF is_version_2() THEN
    RETURN QUERY
    SELECT skip(1, 'Function is new on 3.0.0');
    RETURN;
  END IF;


    FOR i IN 1.. max_limit LOOP
        FOR j IN 1.. max_limit LOOP

            -- DIRECTED
            inner_sql := 'SELECT id, source, target, road_work as cost, reverse_road_work as reverse_cost FROM roadworks';
            dijkstra_sql := 'SELECT * FROM pgr_dijkstra($$' || inner_sql || '$$, ' || i || ', ' || j
                || ', true) ORDER BY seq DESC LIMIT 1';

            binaryBreadthFirstSearch := 'SELECT * FROM pgr_binaryBreadthFirstSearch($$' || inner_sql || '$$, ' || i || ', ' || j
                || ', true) ORDER BY seq DESC LIMIT 1';
            RETURN query SELECT set_eq(binaryBreadthFirstSearch, dijkstra_sql, binaryBreadthFirstSearch);


            inner_sql := 'SELECT id, source, target, road_work as cost FROM roadworks';
            dijkstra_sql := 'SELECT * FROM pgr_dijkstra($$' || inner_sql || '$$, ' || i || ', ' || j
                || ', true) ORDER BY seq DESC LIMIT 1';

            binaryBreadthFirstSearch := 'SELECT * FROM pgr_binaryBreadthFirstSearch($$' || inner_sql || '$$, ' || i || ', ' || j
                || ', true) ORDER BY seq DESC LIMIT 1';
            RETURN query SELECT set_eq(binaryBreadthFirstSearch, dijkstra_sql, binaryBreadthFirstSearch);



            -- UNDIRECTED
            inner_sql := 'SELECT id, source, target, road_work as cost, reverse_road_work as reverse_cost FROM roadworks';
            dijkstra_sql := 'SELECT * FROM pgr_dijkstra($$' || inner_sql || '$$, ' || i || ', ' || j
                || ', false) ORDER BY seq DESC LIMIT 1';

            binaryBreadthFirstSearch := 'SELECT * FROM pgr_binaryBreadthFirstSearch($$' || inner_sql || '$$, ' || i || ', ' || j
                || ', false) ORDER BY seq DESC LIMIT 1';
            RETURN query SELECT set_eq(binaryBreadthFirstSearch, dijkstra_sql, binaryBreadthFirstSearch);


            inner_sql := 'SELECT id, source, target, road_work as cost FROM roadworks';
            dijkstra_sql := 'SELECT * FROM pgr_dijkstra($$' || inner_sql || '$$, ' || i || ', ' || j
                || ', false) ORDER BY seq DESC LIMIT 1';

            binaryBreadthFirstSearch := 'SELECT * FROM pgr_binaryBreadthFirstSearch($$' || inner_sql || '$$, ' || i || ', ' || j
                || ', false) ORDER BY seq DESC LIMIT 1';
            RETURN query SELECT set_eq(binaryBreadthFirstSearch, dijkstra_sql, binaryBreadthFirstSearch);


        END LOOP;
    END LOOP;

    RETURN;
END
$BODY$
language plpgsql;

SELECT * from binaryBreadthFirstSearch_compare_dijkstra();


SELECT * FROM finish();
ROLLBACK;

