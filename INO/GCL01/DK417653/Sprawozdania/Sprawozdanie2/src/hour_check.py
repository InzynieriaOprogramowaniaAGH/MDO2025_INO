import datetime

# Pobierz aktualne minuty
minute = datetime.datetime.now().minute

# Sprawdź, czy minuta jest parzysta
if minute % 2 == 0:
    print("Minuta jest parzysta, kontynuowanie...")
else:
    print("Minuta jest nieparzysta, kończenie builda!")
    exit(1)
