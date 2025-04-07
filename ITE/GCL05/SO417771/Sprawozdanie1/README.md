# Zajęcia 01

---
1. Zainstalowano klienta Git i obsługę kluczy SSH.
![Opis obrazka](lab1/lab1.2.png)
![Opis obrazka](lab1/lab1.1.png)

2. Sklonowano repozytorium za pomocą HTTPS i personal access token.
![Opis obrazka](lab1/lab1.5.png)

3. Utworzono dwa klucze SSH, inne niż RSA, w tym co najmniej jeden zabezpieczony hasłem. Skonfigurowano klucz SSH jako metodę dostępu do GitHuba. Sklonowano repozytorium z wykorzystaniem protokołu SSH oraz skonfigurowano 2FA.
- ***ECDSA***
![Opis obrazka](lab1/lab1.4.png)
**ECDSA** to algorytm oparty na krzywych eliptycznych, który oferuje dobrą wydajność i bezpieczeństwo przy krótkich kluczach, ale jest mniej powszechny niż ED25519.

- ***ED25519***
![Opis obrazka](lab1/lab1.3.png)
**ED25519** to nowoczesny i bezpieczny algorytm, który zapewnia wyższą odporność na ataki i jest rekomendowany do używania w SSH ze względu na swoją szybkość i efektywność.

4. Przełączono się na gałąź main, a następnie na grupową gałąź GCL05, gdzie utworzono gałąź o nazwie SO417771 
![Opis obrazka](lab1/lab1.8.png)

5. Praca na nowej gałęzi

- W katalogu właściwym dla grupy utworzono nowy katalog, także o nazwie SO417771.

- Napisano Git hooka, czyli skrypt weryfikujący, że każdy mój "commit message" zaczyna się od "SO417771"

### Treść Git hooka
```sh

#!/usr/bin/sh

EXPECTED_PREFIX="SO417771"

COMMIT_MSG_FILE=$1
COMMIT_MSG=$(head -n 1 "$COMMIT_MSG_FILE")

if [[ ! $COMMIT_MSG =~ ^$EXPECTED_PREFIX ]]; then
    echo "Błąd: Commit message musi zaczynać się od \"$EXPECTED_PREFIX\"."
    echo "Przykład: \"$EXPECTED_PREFIX: Opis zmiany\""
    exit 1
fi

exit 0

```

- Dodadano ten skrypt do stworzonego wcześniej katalogu.

- Skopiowanao go we właściwe miejsce, tak by uruchamiał się za każdym razem przy commit'cie.
![Opis obrazka](lab1/lab1.9.png)

### Test napisanego Git hooka
 Test potwierdza poprawność napisanego Git hooka
![Opis obrazka](lab1/lab1.7.png)


# Zajęcia 02