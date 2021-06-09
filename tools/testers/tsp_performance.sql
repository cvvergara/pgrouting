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

