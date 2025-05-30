current_hour=$(date +%H)
if [ $((current_hour % 2)) -ne 0 ]; then
    exit 1
fi
