
-- [start_id, end_id] does not exist on the data
-- shoud throw
-- Problem with the data [from_vid, to vid] does not exist
-- row 0 cost is 0
SELECT * FROM pgr_TSP(
    $$
    SELECT * FROM pgr_withPointsCostMatrix(
        'SELECT id, source, target, cost, reverse_cost FROM edge_table ORDER BY id',
        'SELECT pid, edge_id, fraction from pointsOfInterest',
        array[-1, 3, 5, 6, -6], directed := false)
    $$,
    start_id := 5,
    end_id := 10,
    randomize := false
);

-- first  and last nodes are 5
-- second to last node is 3
-- total number of rows is 6 because there are 5 nodes involved)
-- row 0 cost is 0
SELECT * FROM pgr_TSP(
    $$
    SELECT * FROM pgr_withPointsCostMatrix(
        'SELECT id, source, target, cost, reverse_cost FROM edge_table ORDER BY id',
        'SELECT pid, edge_id, fraction from pointsOfInterest',
        array[-1, 3, 5, 6, -6], directed := false)
    $$,
    start_id := 5,
    end_id := 3,
    randomize := false
);

-- first  and last nodes are 3
-- second to last node is 5
-- total number of rows is 6 because there are 5 nodes involved)
-- row 0 cost is 0
SELECT * FROM pgr_TSP(
    $$
    SELECT * FROM pgr_withPointsCostMatrix(
        'SELECT id, source, target, cost, reverse_cost FROM edge_table ORDER BY id',
        'SELECT pid, edge_id, fraction from pointsOfInterest',
        array[-1, 3, 5, 6, -6], directed := false)
    $$,
    start_id := 3,
    end_id := 5,
    randomize := false
);


-- Above 2 queries give the same agg_cost on row 6

-- first  and last nodes are 5
-- total number of rows is 6 because there are 5 nodes involved)
-- row 0 cost is 0
SELECT * FROM pgr_TSP(
    $$
    SELECT * FROM pgr_withPointsCostMatrix(
        'SELECT id, source, target, cost, reverse_cost FROM edge_table ORDER BY id',
        'SELECT pid, edge_id, fraction from pointsOfInterest',
        array[-1, 3, 5, 6, -6], directed := false)
    $$,
    start_id := 5,
    randomize := false
);
