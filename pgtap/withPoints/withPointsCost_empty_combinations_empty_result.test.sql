
\i setup.sql

SELECT plan(1);

create or REPLACE FUNCTION foo()
RETURNS SETOF TEXT AS
$BODY$
BEGIN
  IF is_version_2() OR NOT test_min_version('3.2.0') THEN
    RETURN QUERY
    SELECT skip(1, 'Signature is new on 3.2.0');
    RETURN;
  END IF;


    RETURN query SELECT is_empty(
      'SELECT start_pid,  end_pid, agg_cost FROM pgr_withPointsCost(
        ''SELECT id, source, target, cost, reverse_cost FROM edge_table'',
        ''SELECT pid, edge_id, fraction, side from pointsOfInterest'',
        ''SELECT * FROM combinations_table WHERE source IN (-1)'' ) '
    );
    RETURN;
END
$BODY$
language plpgsql;

select * from foo();

-- Finish the tests and clean up.
SELECT * FROM finish();
ROLLBACK;
