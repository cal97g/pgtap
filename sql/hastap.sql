\unset ECHO
\i test_setup.sql

-- $Id$

SELECT plan(30);

-- This will be rolled back. :-)
CREATE TABLE sometab(
    id    INT NOT NULL PRIMARY KEY,
    name  TEXT DEFAULT '',
    numb  NUMERIC(10, 2),
    myint NUMERIC(8)
);

/****************************************************************************/
-- Test has_table().

\echo ok 1 - has_table(table) fail

SELECT is(
    has_table( '__SDFSDFD__' ),
    'not ok 1 - Table __SDFSDFD__ should exist
# Failed test 1: "Table __SDFSDFD__ should exist"',
    'has_table(table) should fail for non-existent table'
);

\echo ok 3 - has_table(table, desc) fail
SELECT is(
    has_table( '__SDFSDFD__', 'lol' ),
    'not ok 3 - lol
# Failed test 3: "lol"',
    'has_table(table, dessc) should fail for non-existent table'
);

\echo ok 5 - has_table(schema, table, desc) fail
SELECT is(
    has_table( 'foo', '__SDFSDFD__', 'desc' ),
    'not ok 5 - desc
# Failed test 5: "desc"',
    'has_table(schema, table, desc) should fail for non-existent table'
);
UPDATE __tresults__ SET ok = true, aok = true WHERE numb IN( 1, 3, 5 );

\echo ok 7 - has_table(table, desc) pass
SELECT is(
    has_table( 'pg_type', 'lol' ),
    'ok 7 - lol',
    'has_table(table, desc) should pass for an existing table'
);

\echo ok 9 - has_table(schema, table, desc) pass
SELECT is(
    has_table( 'pg_catalog', 'pg_type', 'desc' ),
    'ok 9 - desc',
    'has_table(schema, table, desc) should pass for an existing table'
);

/****************************************************************************/
-- Test has_view().

\echo ok 11 - has_view(view) fail
SELECT is(
    has_view( '__SDFSDFD__' ),
    'not ok 11 - View __SDFSDFD__ should exist
# Failed test 11: "View __SDFSDFD__ should exist"',
    'has_view(view) should fail for non-existent view'
);

\echo ok 13 - has_view(view, desc) fail
SELECT is(
    has_view( '__SDFSDFD__', 'howdy' ),
    'not ok 13 - howdy
# Failed test 13: "howdy"',
    'has_view(view, desc) should fail for non-existent view'
);

\echo ok 15 - has_view(schema, view, desc) fail
SELECT is(
    has_view( 'foo', '__SDFSDFD__', 'desc' ),
    'not ok 15 - desc
# Failed test 15: "desc"',
    'has_view(schema, view, desc) should fail for non-existent view'
);
UPDATE __tresults__ SET ok = true, aok = true WHERE numb IN( 11, 13, 15 );

\echo ok 17 - has_view(view, desc) pass
SELECT is(
    has_view( 'pg_tables', 'yowza' ),
    'ok 17 - yowza',
    'has_view(view, desc) should pass for an existing view'
);

\echo ok 19 - has_view(schema, view, desc) pass
SELECT is(
    has_view( 'information_schema', 'tables', 'desc' ),
    'ok 19 - desc',
    'has_view(schema, view, desc) should pass for an existing view'
);

/****************************************************************************/
-- Test has_column().

\echo ok 21 - has_column(table, column) fail
SELECT is(
    has_column( '__SDFSDFD__', 'foo' ),
    'not ok 21 - Column __SDFSDFD__(foo) should exist
# Failed test 21: "Column __SDFSDFD__(foo) should exist"',
    'has_column(table, column) should fail for non-existent table'
);

\echo ok 23 - has_column(table, column, desc) fail
SELECT is(
    has_column( '__SDFSDFD__', 'bar', 'whatever' ),
    'not ok 23 - whatever
# Failed test 23: "whatever"',
    'has_column(table, column, desc) should fail for non-existent table'
);

\echo ok 25 - has_column(schema, table, column, desc) fail
SELECT is(
    has_column( 'foo', '__SDFSDFD__', 'bar', 'desc' ),
    'not ok 25 - desc
# Failed test 25: "desc"',
    'has_column(schema, table, column, desc) should fail for non-existent table'
);
UPDATE __tresults__ SET ok = true, aok = true WHERE numb IN( 21, 23, 25 );

\echo ok 27 - has_column(table, column) pass
SELECT is(
    has_column( 'sometab', 'id' ),
    'ok 27 - Column sometab(id) should exist',
    'has_column(table, column) should pass for an existing column'
);

\echo ok 29 - has_column(schema, column, desc) pass
SELECT is(
    has_column( 'information_schema', 'tables', 'table_name', 'desc' ),
    'ok 29 - desc',
    'has_column(schema, table, column, desc) should pass for an existing view column'
);

/****************************************************************************/
-- Finish the tests and clean up.
SELECT * FROM finish();
ROLLBACK;
