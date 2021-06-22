\i setup.sql
\i flow_pgtap_tests.sql

UPDATE edge_table SET cost = sign(cost), reverse_cost = sign(reverse_cost);
SELECT CASE
WHEN is_version_2() AND NOT is_version_2('2.6.1') THEN plan(1)
WHEN is_version_2() AND is_version_2('2.6.1') THEN plan(68)
WHEN NOT is_version_2() AND NOT test_min_version('3.2.0') THEN plan(68)
ELSE plan(81)
END;


SELECT * FROM flow_no_crash('pgr_pushRelabel');
SELECT finish();

ROLLBACK;
