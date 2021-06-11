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
  IF is_version_2() THEN
    RETURN QUERY
    SELECT skip(loop_limit, 'Not testing tsp on version 2.x.y (2.6)');
    RETURN;
  END IF;

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
randomize TEXT := ', randomize := false)';
BEGIN
  IF is_version_2() THEN
    RETURN QUERY
    SELECT skip(5, 'Not testing tsp on version 2.x.y (2.6)');
    RETURN;
  END IF;

  IF test_min_version('3.3.0') THEN randomize :=')'; END IF;
  start_sql = 'SELECT * from ' || fn || '($$ SELECT ';
  FOREACH  p IN ARRAY params
  LOOP
    IF p = parameter THEN CONTINUE;
    END IF;
    start_sql = start_sql || p || ', ';
  END LOOP;
  end_sql = ' FROM matrixrows $$' || randomize;

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
randomize TEXT := ', randomize := false)';
BEGIN
  IF is_version_2() THEN
    RETURN QUERY
    SELECT skip(5, 'Not testing tsp on version 2.x.y (2.6)');
    RETURN;
  END IF;

  IF test_min_version('3.3.0') THEN randomize :=')'; END IF;
  start_sql = 'select * from ' || fn || '($$ SELECT ';
  FOREACH  p IN ARRAY params
  LOOP
    IF p = parameter THEN CONTINUE;
    END IF;
    start_sql = start_sql || p || ', ';
  END LOOP;
  end_sql = ' FROM matrixrows $$' || randomize;

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


CREATE OR REPLACE FUNCTION tsp_no_crash()
RETURNS SETOF TEXT AS
$BODY$
DECLARE
params TEXT[];
subs TEXT[];
BEGIN
  IF is_version_2() THEN
    RETURN QUERY
    SELECT skip(8, 'Not testing tsp on version 2.x.y (2.6)');
    RETURN;
  END IF;

  params = ARRAY[
  '$fn$SELECT * FROM matrix_rows$fn$',
  '1::BIGINT',
  '2::BIGINT'
  ]::TEXT[];
  subs = ARRAY[
  'NULL',
  'NULL',
  'NULL'
  ]::TEXT[];
  RETURN query SELECT * FROM no_crash_test('pgr_TSP', params, subs);
END
$BODY$
LANGUAGE plpgsql VOLATILE;

CREATE OR REPLACE FUNCTION tspeuclidean_no_crash()
RETURNS SETOF TEXT AS
$BODY$
DECLARE
params TEXT[];
subs TEXT[];
BEGIN
  IF is_version_2() THEN
    RETURN QUERY
    SELECT skip(8, 'Not testing tsp on version 2.x.y (2.6)');
    RETURN;
  END IF;

  params = ARRAY[
  '$fn$SELECT * FROM matrix_rows$fn$',
  '1::BIGINT',
  '2::BIGINT'
  ]::TEXT[];
  subs = ARRAY[
  'NULL',
  'NULL',
  'NULL'
  ]::TEXT[];

  RETURN query SELECT * FROM no_crash_test('pgr_TSPeuclidean', params, subs);

END
$BODY$
LANGUAGE plpgsql VOLATILE;

