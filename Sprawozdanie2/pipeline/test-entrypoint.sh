#!/bin/bash
set -e

./autogen.sh
./configure

# utwórz katalog na logi i uruchom testy
mkdir -p logs
make check > logs/xz_test.log 2>&1 || true

# pokaż na stdout (żeby widzieć w konsoli Jenkins)
cat logs/xz_test.log
