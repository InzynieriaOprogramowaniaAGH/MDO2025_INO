# Sprawozdanie z przedmiotu Metodyki DevOps z laboratorium nr 1-4
Sprawozdanie wykonała: Amelia Nalborczyk, nr grupy: 2.
Data wykonania: 30.03. 2025 r.
## Laboratorium 1
1. Przygotowałam środowisko pracy
   - Zainstalowałam maszynę wirtualną z systemem Linux Fedora na Oracle VirtualBox.
   - Zalogowałam się do maszyny wirtualnej za pomocą SSH.
   - Skonfigurowałam środowisko Visual Studio Code, korzystając z wtyczki Remote - SSH.
2. Najpierw zainstalowałam klienta Git oraz skonfigurowałam obsługę kluczy SSH. SSH to sposób na bezpieczne łączenie się z GitHub bez potrzeby wpisywania loginu i hasła za każdym razem. Wykonanie tego zadania poprawnie można sprwdzić w sekcji "SSH and GPG keys" jak poniżej:
![Zrzut ekranu 1](screenshots/1.PNG)
3. Za pomocą Personal Access Token sklonowałam repozytorium przedmiotowe MDO2025_INO, używając protokołu HTTPS
![Zrzut ekranu 2](screenshots/2.PNG)
4. Wygenerowałam dwa klucze SSH, przy czym jeden z nich został zabezpieczony hasłem. Użyto polecenia: ssh-keygen
5. Skonfigurowałam klucz SSH jako metodę dostępu do GitHuba
6. By mieć dostęp do repozytorium jako uczestniczka sklonowałam repozytorium za pomocą klucza SSH.
7. Dalej przygotowałam swoją gałąź "AN416663". Od tej pory przełączam gałąź "main" na swoją za pomocą polecenia git branch. Do utworzenia gałęzi użyłam komendy git checkout. Dodany branch:
![Zrzut ekranu 3](screenshots/3.PNG)
8. W katalogu  dla grupy utwórzyłam nowy katalog "AN416663"
9. Aby zapewnić, że każdy commit message zaczyna się od inicjałów i numeru indeksu, utworzyłam Git Hooka. Nadałam plikowi odpowiednie uprawnienia komendą chmod. Git Hook został zamieszczony w nowo powstałym katalogu. Treść Git Hooka znajduje się poniżej:
![Zrzut ekranu 4](screenshots/4.PNG)
10. W katalogu stworzyłam przykładowy plik Sprawozdanie1.md dodałam przykładowy tekst oraz spróbowałam wysłać zmiany w następujący sposób:
![Zrzut ekranu 5](screenshots/5.PNG)
12. Próba wypchnięcia mojej gałęzi okazała się niepowodzeniem ze względu na uprawnieia w repozytorium przedmiotowym:
![Zrzut ekranu 6](screenshots/6.PNG)



## Laboratorium 2

## Laboratorium 3

## Laboratorium 4

## Użycie narzędzi GenAI
W ramach laboratorium korzystałam do wykonania ćwiczenia narzędzia ChatGPT - model 4o. 
Narzędzie zostało wykorzystane do 
- Korekty tekstu pisanego sprawozdania.
- Wytłumaczenia zagadnień poznawanych w ramach zajęć.
Odpowiedzi były weryfikowane osobiście przeze mnie.

