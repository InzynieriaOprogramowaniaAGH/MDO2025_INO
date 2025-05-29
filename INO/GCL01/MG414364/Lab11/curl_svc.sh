#!/bin/bash
for i in {1..100}; do
    curl -Is http://localhost:8080 | grep "nginx" &
done
wait