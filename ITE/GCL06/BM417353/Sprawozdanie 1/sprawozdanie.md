Lab 1
1. Instalacja Git i obsługa kluczy SSH
Na początku zainstalowano klienta Git oraz sprawdzono obecność obsługi SSH. Umożliwia to klonowanie repozytoriów i uwierzytelnianie się za pomocą kluczy kryptograficznych.

2. Klonowanie repozytorium przedmiotowego przez HTTPS z użyciem Personal Access Token (PAT)
Repozytorium zostało sklonowane z wykorzystaniem adresu HTTPS. Ze względu na wymogi bezpieczeństwa (brak wsparcia dla login/hasło), do uwierzytelnienia użyto Personal Access Token wygenerowanego na stronie GitHub.
[ITE/GCL06/BM417353/Sprawozdanie 1/Zrzuty ekranu/Zrzut ekranu (102).png](https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO/blob/25693861ac96ded84a2f349056de99a50ce603ee/ITE/GCL06/BM417353/Sprawozdanie%201/Zrzuty%20ekranu/Zrzut%20ekranu%20(102).png)

4. Klonowanie repozytorium z użyciem protokołu SSH
Po poprawnym dodaniu klucza SSH, sklonowano repozytorium ponownie, tym razem za pomocą protokołu SSH. Zapomniałem zrobić tutaj zrzut ekranu, mam tylko z już sklonowanym repozytorium.

5. Konfiguracja 2FA 
Na koncie GitHub została skonfigurowana opcja 2FA (Two-Factor Authentication) przy użyciu aplikacji autoryzującej, Google Authenticator.
https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO/blob/1d67a17d42376e0a71f375d8b5656705aa5e4cf4/ITE/GCL06/BM417353/Sprawozdanie%201/Zrzuty%20ekranu/Zrzut%20ekranu%20(159).png

6. Utworzenie nowej gałęzi „inicjały & nr indeksu”
Zgodnie z poleceniem, utworzono nową gałąź, odgałęziając się od gałęzi grupowej.
https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO/blob/4163d7312daa50391f00a459c8c9cee3d178132a/ITE/GCL06/BM417353/Sprawozdanie%201/Zrzuty%20ekranu/Zrzut%20ekranu%20(160).png
10. Utworzenie katalogu o tej samej nazwie co gałąź
W katalogu grupowym utworzono nowy folder odpowiadający nazwie gałęzi.
https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO/blob/1d67a17d42376e0a71f375d8b5656705aa5e4cf4/ITE/GCL06/BM417353/Sprawozdanie%201/Zrzuty%20ekranu/Zrzut%20ekranu%20(104).png
11. Napisanie i dodanie Git hooka
Stworzono prosty hook commit-msg, który sprawdza, czy komunikat commita zaczyna się od odpowiednich inicjałów i numeru indeksu. Niestety nie hook nie zadziałał poprawnie przesyłam wersje hooka jaką zamierzałem wykorzystać.
https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO/blob/1d67a17d42376e0a71f375d8b5656705aa5e4cf4/ITE/GCL06/BM417353/Sprawozdanie%201/githook
12. Wysłanie zmian do zdalnego repozytorium
Po wykonaniu wszystkich zmian, zostały one dodane, zatwierdzone i wypchnięte do zdalnego repozytorium.
https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO/blob/1d67a17d42376e0a71f375d8b5656705aa5e4cf4/ITE/GCL06/BM417353/Sprawozdanie%201/Zrzuty%20ekranu/Zrzut%20ekranu%20(103).png
