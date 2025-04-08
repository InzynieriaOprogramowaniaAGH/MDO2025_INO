Lab 1
1. Instalacja Git i obsługa kluczy SSH
Na początku zainstalowano klienta Git oraz sprawdzono obecność obsługi SSH. Umożliwia to klonowanie repozytoriów i uwierzytelnianie się za pomocą kluczy kryptograficznych.

2. Klonowanie repozytorium przedmiotowego przez HTTPS z użyciem Personal Access Token (PAT)
Repozytorium zostało sklonowane z wykorzystaniem adresu HTTPS. Ze względu na wymogi bezpieczeństwa (brak wsparcia dla login/hasło), do uwierzytelnienia użyto Personal Access Token wygenerowanego na stronie GitHub.
[ITE/GCL06/BM417353/Sprawozdanie 1/Zrzuty ekranu/Zrzut ekranu (102).png](https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO/blob/25693861ac96ded84a2f349056de99a50ce603ee/ITE/GCL06/BM417353/Sprawozdanie%201/Zrzuty%20ekranu/Zrzut%20ekranu%20(102).png)
3. Generowanie dwóch kluczy SSH
Wygenerowano dwa klucze SSH, przy czym nie użyto algorytmu RSA. Jeden z nich został dodatkowo zabezpieczony hasłem:

4. Klonowanie repozytorium z użyciem protokołu SSH
Po poprawnym dodaniu klucza SSH, sklonowano repozytorium ponownie, tym razem za pomocą protokołu SSH.

5. Konfiguracja 2FA 
Na koncie GitHub została skonfigurowana opcja 2FA (Two-Factor Authentication) przy użyciu aplikacji autoryzującej, Google Authenticator.

6. Przełączanie gałęzi
W repozytorium przełączono się najpierw na główną gałąź main, a następnie na gałąź odpowiadającą grupie.

7. Utworzenie nowej gałęzi „inicjały & nr indeksu”
Zgodnie z poleceniem, utworzono nową gałąź, odgałęziając się od gałęzi grupowej.

8. Utworzenie katalogu o tej samej nazwie co gałąź
W katalogu grupowym utworzono nowy folder odpowiadający nazwie gałęzi.

9. Napisanie i dodanie Git hooka
Stworzono prosty hook commit-msg, który sprawdza, czy komunikat commita zaczyna się od odpowiednich inicjałów i numeru indeksu.

10. Wysłanie zmian do zdalnego repozytorium
Po wykonaniu wszystkich zmian, zostały one dodane, zatwierdzone i wypchnięte do zdalnego repozytorium.
