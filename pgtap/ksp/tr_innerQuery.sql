\i setup.sql

UPDATE edge_table SET cost = sign(cost), reverse_cost = sign(reverse_cost);
SELECT plan(164);
SET client_min_messages TO ERROR;

CREATE or REPLACE FUNCTION inner_query()
RETURNS SETOF TEXT AS
$BODY$
BEGIN
  IF is_version_2() THEN
    RETURN QUERY
    SELECT skip (164, 'pgr_turnrestrictedpath was added on 3.0.0');
    RETURN;
  END IF;

-------------------------------------------------------------

RETURN QUERY
SELECT has_function('pgr_turnrestrictedpath',
        ARRAY[ 'text', 'text', 'bigint', 'bigint', 'integer', 'boolean', 'boolean', 'boolean', 'boolean']
    );

RETURN QUERY
SELECT function_returns('pgr_turnrestrictedpath',
    ARRAY[ 'text', 'text', 'bigint', 'bigint', 'integer', 'boolean', 'boolean', 'boolean', 'boolean'],
    'setof record');

RETURN QUERY
SELECT style_dijkstraTR('pgr_turnrestrictedpath', ', $$SELECT * FROM new_restrictions$$, 2, 3, 3)');
RETURN QUERY
SELECT style_dijkstraTR('pgr_turnrestrictedpath', ', $$SELECT * FROM new_restrictions$$, 2, 3, 3, true)');
RETURN QUERY
SELECT style_dijkstraTR('pgr_turnrestrictedpath', ', $$SELECT * FROM new_restrictions$$, 2, 3, 3, false)');

END
$BODY$
language plpgsql;

SELECT inner_query();
SELECT finish();
ROLLBACK;
