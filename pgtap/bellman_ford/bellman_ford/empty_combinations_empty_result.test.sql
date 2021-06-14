\i setup.sql

SELECT plan(1);

CREATE OR REPLACE FUNCTION foo()
RETURNS SETOF TEXT AS
$BODY$
BEGIN

  IF is_version_2() OR NOT test_min_version('3.2.0') THEN
    RETURN QUERY
    SELECT skip(1, 'Combinations signature is new on 3.2.0');
    RETURN;
  END IF;


    RETURN query SELECT is_empty(
      'SELECT seq, path_seq, node, edge, cost, agg_cost FROM pgr_bellmanFord(
        ''SELECT id, source, target, cost, reverse_cost FROM edge_table'',
        ''SELECT * FROM combinations_table WHERE source IN (-1)'' ) '
    );
    RETURN;
END
$BODY$
language plpgsql;

SELECT * FROM foo();

-- Finish the tests and clean up.
SELECT * FROM finish();
ROLLBACK;
