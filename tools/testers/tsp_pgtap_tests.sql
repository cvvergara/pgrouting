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
randomize TEXT := ', randomize := false)';
BEGIN

  IF min_version('4.0.0') THEN randomize :=')'; END IF;

  start_sql = 'SELECT * from ' || fn || '($$ SELECT ';
  FOREACH  p IN ARRAY params
  LOOP
    IF p = parameter THEN CONTINUE;
    END IF;
    start_sql = start_sql || p || ', ';
  END LOOP;
  end_sql = ' FROM data $$' || randomize;

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
  IF min_version('4.0.0') THEN randomize :=')'; END IF;

  start_sql = 'select * from ' || fn || '($$ SELECT ';
  FOREACH  p IN ARRAY params
  LOOP
    IF p = parameter THEN CONTINUE;
    END IF;
    start_sql = start_sql || p || ', ';
  END LOOP;
  end_sql = ' FROM data $$' || randomize;

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


CREATE OR REPLACE FUNCTION tsp_no_crash(fn TEXT)
RETURNS SETOF TEXT AS
$BODY$
DECLARE
params TEXT[];
subs TEXT[];
BEGIN
  params = ARRAY[
  '$q$SELECT * FROM data$q$',
  '1::BIGINT',
  '2::BIGINT'
  ]::TEXT[];

  subs = ARRAY[
  'NULL',
  'NULL',
  'NULL'
  ]::TEXT[];

  RETURN query SELECT * FROM no_crash_test(fn, params, subs);
END
$BODY$
LANGUAGE plpgsql VOLATILE;

CREATE OR REPLACE FUNCTION tsp_illegal_values(fn TEXT)
RETURNS SETOF TEXT AS
$BODY$
BEGIN
  IF min_version('4.0.0') THEN
    RETURN QUERY
    SELECT skip(1, 'Tsp tests are for annaeling signature');
  ELSIF min_lib_version('3.2.1') THEN
    RETURN QUERY
    SELECT lives_ok(format($$
        SELECT * FROM %1$s('SELECT * FROM data',
          max_processing_time := -4,
          randomize := false)$$, fn),
      'SHOULD live because parameters are ignored');

    RETURN QUERY
    SELECT lives_ok(format($$
        SELECT * FROM  %1$s('SELECT * FROM data',
          tries_per_temperature := -4,
          randomize := false)$$, fn),
      'SHOULD live because parameters are ignored');

    RETURN QUERY
    SELECT lives_ok(format($$
        SELECT * FROM  %1$s('SELECT * FROM data',
          max_changes_per_temperature := -4,
          randomize := false)$$, fn),
      'SHOULD live because parameters are ignored');

    RETURN QUERY
    SELECT lives_ok(format($$
        SELECT * FROM  %1$s('SELECT * FROM data',
          max_consecutive_non_changes := -4,
          randomize := false)$$, fn),
      'SHOULD live because parameters are ignored');
    RETURN QUERY
    SELECT lives_ok(format($$
        SELECT * FROM  %1$s('SELECT * FROM data',
          cooling_factor := 0,
          randomize := false)$$, fn),
      'SHOULD live because parameters are ignored');

    RETURN QUERY
    SELECT lives_ok(format($$
        SELECT * FROM  %1$s('SELECT * FROM data',
          cooling_factor := 1,
          randomize := false)$$, fn),
      'SHOULD live because parameters are ignored');

    RETURN QUERY
    SELECT lives_ok(format($$
        SELECT * FROM  %1$s('SELECT * FROM data',
          initial_temperature := 0,
          randomize := false)$$, fn),
      'SHOULD live because parameters are ignored');

    RETURN QUERY
    SELECT lives_ok(format($$
        SELECT * FROM  %1$s('SELECT * FROM data',
          final_temperature := 101,
          randomize := false)$$, fn),
      'SHOULD live because parameters are ignored');

    RETURN QUERY
    SELECT lives_ok(format($$
        SELECT * FROM  %1$s('SELECT * FROM data',
          final_temperature := 0,
          randomize := false)$$, fn),
      'SHOULD live because parameters are ignored');

  ELSE

    RETURN QUERY
    SELECT throws_ok(format($$
        SELECT * FROM  %1$s('SELECT * FROM data',
          max_processing_time := -4,
          randomize := false)$$, fn),
      'XX000',
      'Condition not met: max_processing_time >= 0',
      '1 SHOULD throw because max_processing_time has illegal value');

    RETURN QUERY
    SELECT throws_ok(format($$
        SELECT * FROM  %1$s('SELECT * FROM data',
          tries_per_temperature := -4,
          randomize := false)$$, fn),
      'XX000',
      'Condition not met: tries_per_temperature >= 0',
      '2 SHOULD throw because tries_per_temperature has illegal value');

    RETURN QUERY
    SELECT throws_ok(format($$
        SELECT * FROM  %1$s('SELECT * FROM data',
          max_changes_per_temperature := -4,
          randomize := false)$$, fn),
      'XX000',
      'Condition not met: max_changes_per_temperature > 0',
      '3 SHOULD throw because max_changes_per_temperature has illegal value');

    RETURN QUERY
    SELECT throws_ok(format($$
        SELECT * FROM  %1$s('SELECT * FROM data',
          max_consecutive_non_changes := -4,
          randomize := false)$$, fn),
      'XX000',
      'Condition not met: max_consecutive_non_changes > 0',
      '4 SHOULD throw because max_consecutive_non_changes has illegal value');

    RETURN QUERY
    SELECT throws_ok(format($$
        SELECT * FROM  %1$s('SELECT * FROM data',
          cooling_factor := 0,
          randomize := false)$$, fn),
      'XX000',
      'Condition not met: 0 < cooling_factor < 1',
      '5 SHOULD throw because cooling_factor has illegal value');

    RETURN QUERY
    SELECT throws_ok(format($$
        SELECT * FROM  %1$s('SELECT * FROM data',
          cooling_factor := 1,
          randomize := false)$$, fn),
      'XX000',
      'Condition not met: 0 < cooling_factor < 1',
      '6 SHOULD throw because cooling_factor has illegal value');

    RETURN QUERY
    SELECT throws_ok(format($$
        SELECT * FROM  %1$s('SELECT * FROM data',
          initial_temperature := 0,
          randomize := false)$$, fn),
      'XX000',
      'Condition not met: initial_temperature > final_temperature',
      '7 SHOULD throw because initial_temperature has illegal value');

    RETURN QUERY
    SELECT throws_ok(format($$
        SELECT * FROM  %1$s('SELECT * FROM data',
          final_temperature := 101,
          randomize := false)$$, fn),
      'XX000',
      'Condition not met: initial_temperature > final_temperature',
      '8 SHOULD throw because final_temperature has illegal value');

    RETURN QUERY
    SELECT throws_ok(format($$
        SELECT * FROM  %1$s('SELECT * FROM data',
          final_temperature := 0,
          randomize := false)$$, fn),
      'XX000',
      'Condition not met: final_temperature > 0',
      'SHOULD throw because final_temperature has illegal value');

  END IF;
END;
$BODY$
LANGUAGE plpgSQL;


