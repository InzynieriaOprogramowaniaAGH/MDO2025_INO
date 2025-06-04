#!/bin/bash
set -e

./autogen.sh
./configure

mkdir -p logs
make check > logs/xz_test.log 2>&1 || true

cat logs/xz_test.log