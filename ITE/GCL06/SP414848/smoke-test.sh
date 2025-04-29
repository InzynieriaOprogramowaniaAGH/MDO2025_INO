#!/bin/sh
# Skrypt smoke testu dla sqlite

set -e  # Przerwij w przypadku błędu

echo "=== Rozpoczynanie smoke testu dla SQLite ==="

TEST_DB="/tmp/sqlite_smoke_test.db"

echo "=== Test 0: Wersja sqlite3 ==="
sqlite_version=$(/sqlite/sqlite3 --version)
if [ -n "$sqlite_version" ]; then
    echo "✓ Test 0 zakończony powodzeniem - sqlite3 wersja: ${sqlite_version}"
else
    echo "✗ Test 0 nie powiódł się - brak informacji o wersji sqlite3"
    exit 1
fi

echo "=== Test 1: Tworzenie bazy danych i tabeli ==="
/sqlite/sqlite3 "${TEST_DB}" "CREATE TABLE test_table (id INTEGER PRIMARY KEY, name TEXT, value REAL, timestamp DATETIME DEFAULT CURRENT_TIMESTAMP);"
if [ $? -eq 0 ]; then
    echo "✓ Test 1 zakończony powodzeniem"
else
    echo "✗ Test 1 nie powiódł się"
    exit 1
fi

echo "=== Test 2: Wstawianie danych ==="
/sqlite/sqlite3 "${TEST_DB}" "INSERT INTO test_table (id, name, value) VALUES (1, 'Test Row 1', 10.5);"
/sqlite/sqlite3 "${TEST_DB}" "INSERT INTO test_table (id, name, value) VALUES (2, 'Test Row 2', 20.75);"
/sqlite/sqlite3 "${TEST_DB}" "INSERT INTO test_table (id, name, value) VALUES (3, 'Test Row 3', 30.25);"
if [ $? -eq 0 ]; then
    echo "✓ Test 2 zakończony powodzeniem"
else
    echo "✗ Test 2 nie powiódł się"
    exit 1
fi

echo "=== Test 3: Odczyt danych ==="
result=$(/sqlite/sqlite3 "${TEST_DB}" "SELECT COUNT(*) FROM test_table;")
if [ "$result" = "3" ]; then
    echo "✓ Test 3 zakończony powodzeniem - znaleziono 3 wiersze"
else
    echo "✗ Test 3 nie powiódł się - oczekiwano 3 wierszy, otrzymano: ${result}"
    exit 1
fi

echo "=== Test 4: Zapytanie warunkowe ==="
result=$(/sqlite/sqlite3 "${TEST_DB}" "SELECT value FROM test_table WHERE id='2';")
if [ "$result" = "20.75" ]; then
    echo "✓ Test 4 zakończony powodzeniem - znaleziono wartość: 20.75"
else
    echo "✗ Test 4 nie powiódł się - oczekiwano wartość: 20.75, otrzymano: ${result}"
    exit 1
fi

echo "=== Test 5: Wersja sqldiff ==="
sqldiff_version=$(/sqlite/sqldiff --version)
if [ -n "$sqldiff_version" ]; then
    echo "✓ Test 5 zakończony powodzeniem - sqldiff wersja: ${sqldiff_version}"
else
    echo "✗ Test 5 nie powiódł się - brak informacji o wersji sqldiff"
    exit 1
fi

echo "=== Test 6: Wersja sqlite3_analyzer ==="
analyzer_version=$(/sqlite/sqlite3_analyzer --version)
if [ -n "$analyzer_version" ]; then
    echo "✓ Test 6 zakończony powodzeniem - sqlite3_analyzer wersja: ${analyzer_version}"
else
    echo "✗ Test 6 nie powiódł się - brak informacji o wersji sqlite3_analyzer"
    exit 1
fi

# Test 7: Wersja narzędzia sqlite3_rsync
echo "=== Test 7: Wersja sqlite3_rsync ==="
rsync_version=$(/sqlite/sqlite3_rsync --version)
if [ -n "$rsync_version" ]; then
    echo "✓ Test 7 zakończony powodzeniem - sqlite3_rsync wersja: ${rsync_version}"
else
    echo "✗ Test 7 nie powiódł się - brak informacji o wersji sqlite3_rsync"
    exit 1
fi

echo "=== Wszystkie testy zakończone powodzeniem! ==="
exit 0