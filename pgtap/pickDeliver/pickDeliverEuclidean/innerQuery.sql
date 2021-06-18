\i setup.sql

UPDATE edge_table SET cost = sign(cost), reverse_cost = sign(reverse_cost);
SELECT CASE WHEN is_version_2() THEN plan(1) ELSE plan(104) END;


/* testing the pick/deliver orders*/
CREATE OR REPLACE FUNCTION test_anyInteger_orders(fn TEXT, params TEXT[], parameter TEXT)
RETURNS SETOF TEXT AS
$BODY$
DECLARE
start_sql TEXT;
end_sql TEXT;
query TEXT;
p TEXT;
BEGIN
    start_sql = 'select * from ' || fn || '($$ SELECT ';
    FOREACH  p IN ARRAY params LOOP
        IF p = parameter THEN CONTINUE;
        END IF;
        start_sql = start_sql || p || ', ';
    END LOOP;
    end_sql = ' FROM orders $$,  $$SELECT * FROM vehicles $$, max_cycles := 30)';

    query := start_sql || parameter || '::SMALLINT ' || end_sql;
    RETURN query SELECT lives_ok(query);

    query := start_sql || parameter || '::INTEGER ' || end_sql;
    RETURN query SELECT lives_ok(query);

    query := start_sql || parameter || '::BIGINT ' || end_sql;
    RETURN query SELECT lives_ok(query);

    query := start_sql || parameter || '::REAL ' || end_sql;
    RETURN query SELECT throws_ok(query);

    query := start_sql || parameter || '::FLOAT8 ' || end_sql;
    RETURN query SELECT throws_ok(query);

    query := start_sql || parameter || '::NUMERIC ' || end_sql;
    RETURN query SELECT throws_ok(query);
END;
$BODY$ LANGUAGE plpgsql;

/* testing the pick/deliver orders*/
CREATE OR REPLACE FUNCTION test_anyNumerical_orders(fn TEXT, params TEXT[], parameter TEXT)
RETURNS SETOF TEXT AS
$BODY$
DECLARE
start_sql TEXT;
end_sql TEXT;
query TEXT;
p TEXT;
BEGIN
    start_sql = 'select * from ' || fn || '($$ SELECT ';
    FOREACH  p IN ARRAY params LOOP
        IF p = parameter THEN CONTINUE;
        END IF;
        start_sql = start_sql || p || ', ';
    END LOOP;
    end_sql = ' FROM orders $$,  $$SELECT * FROM vehicles $$, max_cycles := 30)';

    query := start_sql || parameter || '::SMALLINT ' || end_sql;
    RETURN query SELECT lives_ok(query);

    query := start_sql || parameter || '::INTEGER ' || end_sql;
    RETURN query SELECT lives_ok(query);

    query := start_sql || parameter || '::BIGINT ' || end_sql;
    RETURN query SELECT lives_ok(query);

    query := start_sql || parameter || '::REAL ' || end_sql;
    RETURN query SELECT lives_ok(query);

    query := start_sql || parameter || '::FLOAT8 ' || end_sql;
    RETURN query SELECT lives_ok(query);

    query := start_sql || parameter || '::NUMERIC ' || end_sql;
    RETURN query SELECT lives_ok(query);
END;
$BODY$ LANGUAGE plpgsql;

/*
testing the pick/deliver vehicles
*/
CREATE OR REPLACE FUNCTION test_anyInteger_vehicles(fn TEXT, params TEXT[], parameter TEXT)
RETURNS SETOF TEXT AS
$BODY$
DECLARE
start_sql TEXT;
end_sql TEXT;
query TEXT;
p TEXT;
BEGIN
    start_sql = 'SELECT * FROM ' || fn || '($$ SELECT * FROM orders $$, $$SELECT ';

    FOREACH  p IN ARRAY params LOOP
        IF p = parameter THEN CONTINUE;
        END IF;
        start_sql = start_sql || p || ', ';
    END LOOP;
    end_sql = ' FROM  vehicles $$, max_cycles := 30)';

    query := start_sql || parameter || '::SMALLINT ' || end_sql;
    RETURN query SELECT lives_ok(query);

    query := start_sql || parameter || '::INTEGER ' || end_sql;
    RETURN query SELECT lives_ok(query);

    query := start_sql || parameter || '::BIGINT ' || end_sql;
    RETURN query SELECT lives_ok(query);

    query := start_sql || parameter || '::REAL ' || end_sql;
    RETURN query SELECT throws_ok(query);

    query := start_sql || parameter || '::FLOAT8 ' || end_sql;
    RETURN query SELECT throws_ok(query);
END;
$BODY$ LANGUAGE plpgsql;

/*
testing the pick/deliver vehicles
 */
CREATE OR REPLACE FUNCTION test_anyNumerical_vehicles(fn TEXT, params TEXT[], parameter TEXT)
RETURNS SETOF TEXT AS
$BODY$
DECLARE
start_sql TEXT;
end_sql TEXT;
query TEXT;
p TEXT;
BEGIN
    start_sql = 'SELECT * FROM ' || fn || '($$ SELECT * FROM orders $$, $$ SELECT ';
    FOREACH  p IN ARRAY params LOOP
        IF p = parameter THEN CONTINUE;
        END IF;
        start_sql = start_sql || p || ', ';
    END LOOP;
    end_sql = ' FROM vehicles $$, max_cycles := 30)';

    query := start_sql || parameter || '::SMALLINT ' || end_sql;
    RETURN query SELECT lives_ok(query);

    query := start_sql || parameter || '::INTEGER ' || end_sql;
    RETURN query SELECT lives_ok(query);

    query := start_sql || parameter || '::BIGINT ' || end_sql;
    RETURN query SELECT lives_ok(query);

    query := start_sql || parameter || '::REAL ' || end_sql;
    RETURN query SELECT lives_ok(query);

    query := start_sql || parameter || '::FLOAT8 ' || end_sql;
    RETURN query SELECT lives_ok(query);
END;
$BODY$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION inner_query()
RETURNS SETOF TEXT AS
$BODY$
BEGIN
  IF is_version_2() THEN
    RETURN QUERY
    SELECT skip(1, 'Function changed name on 3.0.0');
    RETURN;
  END IF;

RETURN QUERY
SELECT has_function('pgr_pickdelivereuclidean',
    ARRAY['text', 'text', 'double precision', 'integer', 'integer']);

RETURN QUERY
SELECT function_returns('pgr_pickdelivereuclidean',
    ARRAY['text', 'text', 'double precision', 'integer', 'integer'],
    'setof record');
RETURN QUERY
SELECT test_anyInteger_orders('pgr_pickdelivereuclidean',
    ARRAY['id', 'demand',
    'p_x', 'p_y', 'p_open', 'p_close', 'p_service',
    'd_x', 'd_y', 'd_open', 'd_close', 'd_service'],
    'id');

RETURN QUERY
SELECT test_anynumerical_orders('pgr_pickdelivereuclidean',
    ARRAY['id', 'demand',
    'p_x', 'p_y', 'p_open', 'p_close', 'p_service',
    'd_x', 'd_y', 'd_open', 'd_close', 'd_service'],
    'demand');

RETURN QUERY
SELECT test_anynumerical_orders('pgr_pickdelivereuclidean',
    ARRAY['id', 'demand',
    'p_x', 'p_y', 'p_open', 'p_close', 'p_service',
    'd_x', 'd_y', 'd_open', 'd_close', 'd_service'],
    'p_x');
RETURN QUERY
SELECT test_anynumerical_orders('pgr_pickdelivereuclidean',
    ARRAY['id', 'demand',
    'p_x', 'p_y', 'p_open', 'p_close', 'p_service',
    'd_x', 'd_y', 'd_open', 'd_close', 'd_service'],
    'p_y');
RETURN QUERY
SELECT test_anynumerical_orders('pgr_pickdelivereuclidean',
    ARRAY['id', 'demand',
    'p_x', 'p_y', 'p_open', 'p_close', 'p_service',
    'd_x', 'd_y', 'd_open', 'd_close', 'd_service'],
    'p_open');
RETURN QUERY
SELECT test_anynumerical_orders('pgr_pickdelivereuclidean',
    ARRAY['id', 'demand',
    'p_x', 'p_y', 'p_open', 'p_close', 'p_service',
    'd_x', 'd_y', 'd_open', 'd_close', 'd_service'],
    'p_close');
RETURN QUERY
SELECT test_anynumerical_orders('pgr_pickdelivereuclidean',
    ARRAY['id', 'demand',
    'p_x', 'p_y', 'p_open', 'p_close', 'p_service',
    'd_x', 'd_y', 'd_open', 'd_close', 'd_service'],
    'p_service');

RETURN QUERY
SELECT test_anynumerical_orders('pgr_pickdelivereuclidean',
    ARRAY['id', 'demand',
    'p_x', 'p_y', 'p_open', 'p_close', 'p_service',
    'd_x', 'd_y', 'd_open', 'd_close', 'd_service'],
    'd_x');
RETURN QUERY
SELECT test_anynumerical_orders('pgr_pickdelivereuclidean',
    ARRAY['id', 'demand',
    'p_x', 'p_y', 'p_open', 'p_close', 'p_service',
    'd_x', 'd_y', 'd_open', 'd_close', 'd_service'],
    'd_y');
RETURN QUERY
SELECT test_anynumerical_orders('pgr_pickdelivereuclidean',
    ARRAY['id', 'demand',
    'p_x', 'p_y', 'p_open', 'p_close', 'p_service',
    'd_x', 'd_y', 'd_open', 'd_close', 'd_service'],
    'd_open');
RETURN QUERY
SELECT test_anynumerical_orders('pgr_pickdelivereuclidean',
    ARRAY['id', 'demand',
    'p_x', 'p_y', 'p_open', 'p_close', 'p_service',
    'd_x', 'd_y', 'd_open', 'd_close', 'd_service'],
    'd_close');
RETURN QUERY
SELECT test_anynumerical_orders('pgr_pickdelivereuclidean',
    ARRAY['id', 'demand',
    'p_x', 'p_y', 'p_open', 'p_close', 'p_service',
    'd_x', 'd_y', 'd_open', 'd_close', 'd_service'],
    'd_service');

/* Currently this are not used TODO add when they are used
    'end_x', 'end_y', 'end_open', 'end_close', 'end_service'],
    'speed' is optional defaults to 1
    'start_service' is optional defaults to 0
*/
RETURN QUERY
SELECT test_anyInteger_vehicles('pgr_pickdelivereuclidean',
    ARRAY['id', 'capacity',
    'start_x', 'start_y', 'start_open', 'start_close'],
    'id');
RETURN QUERY
SELECT test_anyNumerical_vehicles('pgr_pickdelivereuclidean',
    ARRAY['id', 'capacity',
    'start_x', 'start_y', 'start_open', 'start_close'],
    'capacity');
RETURN QUERY
SELECT test_anyNumerical_vehicles('pgr_pickdelivereuclidean',
    ARRAY['id', 'capacity',
    'start_x', 'start_y', 'start_open', 'start_close'],
    'start_x');
RETURN QUERY
SELECT test_anyNumerical_vehicles('pgr_pickdelivereuclidean',
    ARRAY['id', 'capacity',
    'start_x', 'start_y', 'start_open', 'start_close'],
    'start_y');
RETURN QUERY
SELECT test_anyNumerical_vehicles('pgr_pickdelivereuclidean',
    ARRAY['id', 'capacity',
    'start_x', 'start_y', 'start_open', 'start_close'],
    'start_open');
RETURN QUERY
SELECT test_anyNumerical_vehicles('pgr_pickdelivereuclidean',
    ARRAY['id', 'capacity',
    'start_x', 'start_y', 'start_open', 'start_close'],
    'start_close');

END
$BODY$
LANGUAGE plpgsql VOLATILE;

SELECT inner_query();
SELECT finish();
ROLLBACK;
