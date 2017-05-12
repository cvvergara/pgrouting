------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------
--              PGR_drivingDistance
------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------

SET client_min_messages TO NOTICE;

\echo --q1
SELECT * FROM pgr_drivingDistance(
    'SELECT id::INTEGER, source::INTEGER, target::INTEGER, cost FROM edge_table',
    7, 1.5, false, false
) ;

SELECT * FROM pgr_drivingDistance(
    'SELECT id::INTEGER, source::INTEGER, target::INTEGER, cost, reverse_cost FROM edge_table',
    7, 1.5, true, true
) ;
\echo --q2
