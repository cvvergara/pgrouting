
\i setup.sql

SELECT plan(1);

CREATE OR REPLACE FUNCTION foo()
RETURNS SETOF TEXT AS
$BODY$
BEGIN
  IF is_version_2() THEN
    RETURN QUERY
    SELECT skip(1, 'Not testing tsp on version 2.x.y (2.6)');
    RETURN;
  END IF;

  IF test_min_version('3.2.0') THEN
    RETURN query
    SELECT is_empty(
      'SELECT path_seq,  start_vid,  end_vid, node, edge, cost, agg_cost FROM pgr_aStar(
        ''SELECT id, source, target, cost, reverse_cost, x1, y1, x2, y2 FROM edge_table'',
        ''SELECT * FROM combinations_table WHERE source IN (-1)'' ) '
    );
  ELSE
    RETURN query
    SELECT skip(1, 'Signature included on version 3.2');
  END IF;
END
$BODY$
language plpgsql;

SELECT * from foo();

SELECT * FROM finish();
ROLLBACK;
