#!/bin/bash
set -e

# Upewnij się, że wejściowy plik istnieje
if [ ! -f "input.mp4" ]; then
    echo "Brak pliku input.mp4. Upewnij się, że został dołączony do obrazu lub zamontowany jako wolumen."
    exit 1
fi

# Konwersja MP4 → AVI
ffmpeg -i input.mp4 output.avi

# Sprawdzenie, czy plik wynikowy istnieje
if [ -f "output.avi" ]; then
    echo "Konwersja udana!"
else
    echo "Konwersja nie powiodła się" >&2
    exit 1
fi
