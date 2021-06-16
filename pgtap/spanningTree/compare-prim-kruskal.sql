\i setup.sql

SELECT plan(3);

UPDATE edge_table SET cost = sign(cost) + 0.001 * id * id, reverse_cost = sign(reverse_cost) + 0.001 * id * id;

CREATE OR REPLACE FUNCTION compare()
RETURNS SETOF TEXT AS
$BODY$
DECLARE
BEGIN
  IF is_version_2() THEN
    RETURN QUERY
    SELECT skip (3, 'pgr_prim pgr_kruskal are new on 3.0.0');
    RETURN;
  END IF;

--
PREPARE prim AS
SELECT edge, cost::TEXT
FROM pgr_prim(
  'SELECT id, source, target, cost, reverse_cost FROM edge_table'
);

PREPARE kruskal AS
SELECT edge, cost::TEXT
FROM pgr_kruskal(
  'SELECT id, source, target, cost, reverse_cost FROM edge_table'
);

RETURN QUERY
SELECT set_eq('prim', 'kruskal', '1: Prim & kruskal should return same values');

PREPARE kruskal1 AS
SELECT edge, cost
FROM pgr_kruskal(
    'SELECT id, source, target, cost, reverse_cost FROM edge_table'
);

PREPARE prim1 AS
SELECT edge, cost
FROM pgr_prim(
    'SELECT id, source, target, cost, reverse_cost FROM edge_table'
);

RETURN QUERY
SELECT bag_has('kruskal1',
$$VALUES
(1 , 1.001),
(2 , 1.004),
(3 , 1.009),
(4 , 1.016),
(5 , 1.025),
(6 , 1.036),
(7 , 1.049),
(9 , 1.081),
(10 ,   1.1),
(11 , 1.121),
(13 , 1.169),
(14 , 1.196),
(17 , 1.289),
(18 , 1.324)$$,
'2: kruskal result');


RETURN QUERY
SELECT bag_has('prim1',
$$VALUES
(1 , 1.001),
(2 , 1.004),
(3 , 1.009),
(4 , 1.016),
(5 , 1.025),
(6 , 1.036),
(7 , 1.049),
(9 , 1.081),
(10 ,   1.1),
(11 , 1.121),
(13 , 1.169),
(14 , 1.196),
(17 , 1.289),
(18 , 1.324)$$,
'3: prim result');
END
$BODY$
LANGUAGE plpgsql VOLATILE;

SELECT compare();
SELECT * FROM finish();
ROLLBACK;
