# Sprawozdanie
## Wstęp, Git, Gałęzie, SSH
### 1) Instalacja Git i kluczy SSH Aby rozpocząć pracę z systemem Git oraz zapewnić bezpieczne połączenie przez SSH, zainstalowano odpowiednie narzędzia przy użyciu menedżera pakietów dnf, który jest domyślny w systemach Fedora.
### 2) Sklonowanie repozytorium Repozytorium przedmiotowe zostało sklonowane za pomocą polecenia git clone, początkowo używając protokołu HTTPS.
### 3)Generowanie kluczy SSH i zmiana połączenia na SSH Aby zapewnić bezpieczne połączenie z GitHubem bez konieczności każdorazowego podawania loginu i hasła, wygenerowano dwa klucze SSH: jeden dla algorytmu ed25519, drugi dla ecdsa.

Następnie klucze zostały dodane do agenta SSH:

Zmieniono połączenie z repozytorium na SSH:

### 4) Zmiana gałęzi Po skonfigurowaniu połączenia SSH przełączono się na gałąź główną i gałąź dedykowaną dla grupy.

### 5) Stworzenie nowej gałęzi Utworzono nową gałąź o nazwie KP415903, odgałęziając ją od gałęzi grupowej.

### 6)Praca na nowej gałęzi W odpowiednim katalogu stworzono folder o nazwie KP415903. Utworzono również Git hooka, który sprawdza, czy wiadomość commit zaczyna się od "KP415903".

