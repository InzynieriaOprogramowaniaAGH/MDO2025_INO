#!/bin/sh
# Skrypt smoke testu dla sqlite

set -e  # Przerwij w przypadku błędu

echo "=== Starting smoke tests for sqlite3 ==="

TEST_DB="/tmp/sqlite_smoke_test.db"

echo "=== Test 0: sqlite3 version ==="
sqlite_version=$(/sqlite/sqlite3 --version)
if [ -n "$sqlite_version" ]; then
    echo "Test 0 passed - sqlite3 version: ${sqlite_version}"
else
    echo "Test 0 failed - no information on sqlite3 version"
    exit 1
fi

echo "=== Test 1: creating a table ==="
/sqlite/sqlite3 "${TEST_DB}" "CREATE TABLE test_table (id INTEGER PRIMARY KEY, name TEXT, value REAL, timestamp DATETIME DEFAULT CURRENT_TIMESTAMP);"
if [ $? -eq 0 ]; then
    echo "Test 1 passed"
else
    echo "Test 1 failed"
    exit 1
fi

echo "=== Test 2: inserting data ==="
/sqlite/sqlite3 "${TEST_DB}" "INSERT INTO test_table (id, name, value) VALUES (1, 'Test Row 1', 10.5);"
/sqlite/sqlite3 "${TEST_DB}" "INSERT INTO test_table (id, name, value) VALUES (2, 'Test Row 2', 20.75);"
/sqlite/sqlite3 "${TEST_DB}" "INSERT INTO test_table (id, name, value) VALUES (3, 'Test Row 3', 30.25);"
if [ $? -eq 0 ]; then
    echo "Test 2 passed"
else
    echo "Test 2 failed"
    exit 1
fi

echo "=== Test 3: reading data ==="
result=$(/sqlite/sqlite3 "${TEST_DB}" "SELECT COUNT(*) FROM test_table;")
if [ "$result" = "3" ]; then
    echo "Test 3 passed - found correct number of rows: 3"
else
    echo "Test 3 failed - expected 3 rows, got: ${result}"
    exit 1
fi

echo "=== Test 4: query with a condition ==="
result=$(/sqlite/sqlite3 "${TEST_DB}" "SELECT value FROM test_table WHERE id='2';")
if [ "$result" = "20.75" ]; then
    echo "Test 4 passed - found correct value: 20.75"
else
    echo "Test 4 failed - expected value: 20.75, got: ${result}"
    exit 1
fi

echo "=== All Tests Passed! ==="
exit 0