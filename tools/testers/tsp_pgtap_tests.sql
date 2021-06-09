CREATE OR REPLACE FUNCTION tsp_performance(
    tbl REGCLASS,
    loop_limit INTEGER,
    know_cost FLOAT,
    upper_bound FLOAT)
RETURNS SETOF TEXT AS
$BODY$
DECLARE
cost_limit FLOAT := know_cost * upper_bound;
BEGIN
  FOR i IN 1..loop_limit
  LOOP
    RETURN query
    SELECT is((
            SELECT agg_cost < cost_limit
            FROM pgr_TSPeuclidean(
                 format($$SELECT * FROM %1$I$$, tbl),
                 start_id => i)
            WHERE seq = (loop_limit + 1)),
        't',
        'start_id = ' || i || ' expecting: agg_cost < ' || cost_limit);
    END LOOP;
END;
$BODY$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION tsp_anyInteger(fn TEXT, params TEXT[], parameter TEXT)
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
end_sql = ' FROM matrixrows $$, randomize := false)';

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

CREATE OR REPLACE FUNCTION tsp_anyNumerical(fn TEXT, params TEXT[], parameter TEXT)
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
end_sql = ' FROM matrixrows $$, randomize := false)';

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

