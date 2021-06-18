
\i setup.sql

UPDATE edge_table SET cost = sign(cost), reverse_cost = sign(reverse_cost);
SELECT CASE WHEN is_version_2() THEN plan(1) ELSE plan(1) END;

CREATE OR REPLACE FUNCTION compare()
RETURNS SETOF TEXT AS
$BODY$
BEGIN
  IF is_version_2() THEN
    RETURN QUERY
    SELECT skip(1, 'Function changed name on 3.0.0');
    RETURN;
  END IF;

PREPARE pd AS
SELECT seq, vehicle_seq, vehicle_id, stop_seq, stop_type,
    order_id, cargo,
    travel_time, arrival_time, wait_time, service_time, departure_time
FROM _pgr_pickDeliver(
    'SELECT * FROM orders ORDER BY id',
    'SELECT * from vehicles',
    -- matrix query
    'WITH
    A AS (
        SELECT p_node_id AS id, p_x AS x, p_y AS y FROM orders
        UNION
        SELECT d_node_id AS id, d_x, d_y FROM orders
        UNION
        SELECT start_node_id, start_x, start_y FROM vehicles
    )
    SELECT A.id AS start_vid, B.id AS end_vid, sqrt( (a.x - b.x) * (a.x - b.x) + (a.y - b.y) * (a.y - b.y)) AS agg_cost
    FROM A, A AS B WHERE A.id != B.id'
    );

PREPARE pd_e AS
SELECT * FROM _pgr_pickDeliverEuclidean(
    'SELECT * FROM orders ORDER BY id',
    'SELECT * from vehicles');

RETURN QUERY
SELECT set_eq('pd', 'pd_e');

END
$BODY$
LANGUAGE plpgsql VOLATILE;

SELECT compare();
SELECT finish();
ROLLBACK;
