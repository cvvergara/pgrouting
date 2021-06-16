\i setup.sql

UPDATE edge_table SET cost = sign(cost), reverse_cost = sign(reverse_cost);
SELECT plan(20);

CREATE or REPLACE FUNCTION edge_cases()
RETURNS SETOF TEXT AS
$BODY$
BEGIN
  IF is_version_2() THEN
    RETURN QUERY
    SELECT skip (20, 'pgr_turnrestrictedpath was added on 3.0.0');
    RETURN;
  END IF;

----------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------
-- testing from an existing starting vertex to a non-existing destination
----------------------------------------------------------------------------------------------------------------

-- in directed graph
-- with restrictions
PREPARE q1 AS
SELECT * FROM pgr_turnRestrictedPath(
    'SELECT id, source, target, cost, reverse_cost FROM edge_table WHERE id = 4 OR id = 7',
    'SELECT * FROM new_restrictions WHERE id IN (1)',
    2, 3,
    3,
    strict := false
);


-- in undirected graph
-- with restrictions
PREPARE q2 AS
SELECT * FROM pgr_turnRestrictedPath(
    'SELECT id, source, target, cost, reverse_cost FROM edge_table WHERE id = 4 OR id = 7',
    'SELECT * FROM new_restrictions WHERE id IN (1)',
    2, 3,
    3,
    FALSE,
    strict := false
);

-- in directed graph
-- without restrictions
PREPARE q3 AS
SELECT * FROM pgr_turnRestrictedPath(
    'SELECT id, source, target, cost, reverse_cost FROM edge_table WHERE id = 4 OR id = 7',
    'SELECT * FROM new_restrictions where id > 10',
    2, 3,
    3,
    strict := false
);

-- in undirected graph
-- without restrictions
PREPARE q4 AS
SELECT * FROM pgr_turnRestrictedPath(
    'SELECT id, source, target, cost, reverse_cost FROM edge_table WHERE id = 4 OR id = 7',
    'SELECT * FROM new_restrictions where id > 10',
    2, 3,
    3,
    FALSE,
    strict := false
);

RETURN QUERY
SELECT is_empty('q1');
RETURN QUERY
SELECT is_empty('q2');
RETURN QUERY
SELECT is_empty('q3');
RETURN QUERY
SELECT is_empty('q4');

----------------------------------------------------------------------------------------------------------------
-- testing from an non-existing starting vertex to an existing destination
----------------------------------------------------------------------------------------------------------------

-- in directed graph
-- with restrictions
PREPARE q5 AS
SELECT * FROM pgr_turnRestrictedPath(
    'SELECT id, source, target, cost, reverse_cost FROM edge_table WHERE id = 4 OR id = 7',
    'SELECT * FROM new_restrictions WHERE id IN (1)',
    6, 8,
    3,
    strict := false
);

-- in undirected graph
-- with restrictions
PREPARE q6 AS
SELECT * FROM pgr_turnRestrictedPath(
    'SELECT id, source, target, cost, reverse_cost FROM edge_table WHERE id = 4 OR id = 7',
    'SELECT * FROM new_restrictions WHERE id IN (1)',
    6, 8,
    3,
    FALSE,
    strict := false
);

-- in directed graph
-- without restrictions
PREPARE q7 AS
SELECT * FROM pgr_turnRestrictedPath(
    'SELECT id, source, target, cost, reverse_cost FROM edge_table WHERE id = 4 OR id = 7',
    'SELECT * FROM new_restrictions where id > 10',
    6, 8,
    3,
    strict := false
);

-- in undirected graph
-- without restrictions
PREPARE q8 AS
SELECT * FROM pgr_turnRestrictedPath(
    'SELECT id, source, target, cost, reverse_cost FROM edge_table WHERE id = 4 OR id = 7',
    'SELECT * FROM new_restrictions where id > 10',
    6, 8,
    3,
    FALSE,
    strict := false
);

RETURN QUERY
SELECT is_empty('q5');
RETURN QUERY
SELECT is_empty('q6');
RETURN QUERY
SELECT is_empty('q7');
RETURN QUERY
SELECT is_empty('q8');

----------------------------------------------------------------------------------------------------------------
-- testing from a non-existing starting vertex to a non-existing destination
----------------------------------------------------------------------------------------------------------------

-- in directed graph
-- with restrictions
PREPARE q9 AS
SELECT * FROM pgr_turnRestrictedPath(
    'SELECT id, source, target, cost, reverse_cost FROM edge_table WHERE id = 4 OR id = 7',
    'SELECT * FROM new_restrictions WHERE id IN (1)',
    1, 17,
    3,
    strict := false
);

-- in undirected graph
-- with restrictions
PREPARE q10 AS
SELECT * FROM pgr_turnRestrictedPath(
    'SELECT id, source, target, cost, reverse_cost FROM edge_table WHERE id = 4 OR id = 7',
    'SELECT * FROM new_restrictions WHERE id IN (1)',
    1, 17,
    3,
    FALSE,
    strict := false
);

-- in directed graph
-- without restrictions
PREPARE q11 AS
SELECT * FROM pgr_turnRestrictedPath(
    'SELECT id, source, target, cost, reverse_cost FROM edge_table WHERE id = 4 OR id = 7',
    'SELECT * FROM new_restrictions where id > 10',
    1, 17,
    3,
    strict := false
);

-- in undirected graph
-- without restrictions
PREPARE q12 AS
SELECT * FROM pgr_turnRestrictedPath(
    'SELECT id, source, target, cost, reverse_cost FROM edge_table WHERE id = 4 OR id = 7',
    'SELECT * FROM new_restrictions where id > 10',
    1, 17,
    3,
    FALSE,
    strict := false
);

RETURN QUERY
SELECT is_empty('q9');
RETURN QUERY
SELECT is_empty('q10');
RETURN QUERY
SELECT is_empty('q11');
RETURN QUERY
SELECT is_empty('q12');

----------------------------------------------------------------------------------------------------------------
-- testing from an existing starting vertex to the same destination
----------------------------------------------------------------------------------------------------------------

-- in directed graph
-- with restrictions
PREPARE q13 AS
SELECT * FROM pgr_turnRestrictedPath(
    'SELECT id, source, target, cost, reverse_cost FROM edge_table WHERE id = 4 OR id = 7',
    'SELECT * FROM new_restrictions WHERE id IN (1)',
    2, 2,
    3,
    strict := false
);

-- in undirected graph
-- with restrictions
PREPARE q14 AS
SELECT * FROM pgr_turnRestrictedPath(
    'SELECT id, source, target, cost, reverse_cost FROM edge_table WHERE id = 4 OR id = 7',
    'SELECT * FROM new_restrictions WHERE id IN (1)',
    2, 2,
    3,
    FALSE,
    strict := false
);

-- in directed graph
-- without restrictions
PREPARE q15 AS
SELECT * FROM pgr_turnRestrictedPath(
    'SELECT id, source, target, cost, reverse_cost FROM edge_table WHERE id = 4 OR id = 7',
    'SELECT * FROM new_restrictions where id > 10',
    2, 2,
    3,
    strict := false
);

-- in undirected graph
-- without restrictions
PREPARE q16 AS
SELECT * FROM pgr_turnRestrictedPath(
    'SELECT id, source, target, cost, reverse_cost FROM edge_table WHERE id = 4 OR id = 7',
    'SELECT * FROM new_restrictions where id > 10',
    2, 2,
    3,
    FALSE,
    strict := false
);

RETURN QUERY
SELECT is_empty('q13');
RETURN QUERY
SELECT is_empty('q14');
RETURN QUERY
SELECT is_empty('q15');
RETURN QUERY
SELECT is_empty('q16');

----------------------------------------------------------------------------------------------------------------
-- testing from an existing starting vertex in one component to an existing destination in another component
----------------------------------------------------------------------------------------------------------------
-- in directed graph
-- with restrictions
PREPARE q17 AS
SELECT * FROM pgr_turnRestrictedPath(
    'SELECT id, source, target, cost, reverse_cost FROM edge_table WHERE id IN (4, 7, 17)',
    'SELECT * FROM new_restrictions WHERE id IN (1)',
    2, 14,
    3,
    strict := false
);

-- in undirected graph
-- with restrictions
PREPARE q18 AS
SELECT * FROM pgr_turnRestrictedPath(
    'SELECT id, source, target, cost, reverse_cost FROM edge_table WHERE id IN (4, 7, 17)',
    'SELECT * FROM new_restrictions WHERE id IN (1)',
    2, 14,
    3,
    FALSE,
    strict := false
);

-- in directed graph
-- without restrictions
PREPARE q19 AS
SELECT * FROM pgr_turnRestrictedPath(
    'SELECT id, source, target, cost, reverse_cost FROM edge_table WHERE id IN (4, 7, 17)',
    'SELECT * FROM new_restrictions where id > 10',
    2, 14,
    3,
    strict := false
);

-- in undirected graph
-- without restrictions
PREPARE q20 AS
SELECT * FROM pgr_turnRestrictedPath(
    'SELECT id, source, target, cost, reverse_cost FROM edge_table WHERE id IN (4, 7, 17)',
    'SELECT * FROM new_restrictions where id > 10',
    2, 14,
    3,
    FALSE,
    strict := false
);

RETURN QUERY
SELECT is_empty('q17');
RETURN QUERY
SELECT is_empty('q18');
RETURN QUERY
SELECT is_empty('q19');
RETURN QUERY
SELECT is_empty('q20');
----------------------------------------------------------------------------------------------------------------

END
$BODY$
language plpgsql;

SELECT edge_cases();
SELECT finish();
ROLLBACK;
