# Sprawozdanie 1

## Wprowadzenie

Celem niniejszego sprawozdania jest udokumentowanie wykonania zadań laboratoryjnych dotyczących podstawowej obsługi systemu kontroli wersji Git oraz platformy GitHub. W ramach ćwiczenia przeprowadzono konfigurację kluczy SSH, sklonowano repozytorium zdalne, utworzono gałęzie zgodnie z przyjętą strukturą oraz wykonano operacje na plikach i repozytorium zgodnie z przyjętą konwencją commitów.

![image](https://github.com/user-attachments/assets/1fabcc99-3dd9-4c52-ba8a-51ea17698f60)
Zrzut ekranu 1.1
Wykonałem polecenie sudo apt update, aby zaktualizować listę dostępnych pakietów w systemie. Dzięki temu mam pewność, że wszystkie instalowane programy będą pochodziły z aktualnych źródeł
#
#
![1 2](https://github.com/user-attachments/assets/0d289fe3-c1ce-4305-af53-c16ac38ec174)
Zrzut ekranu 1.2
Zainstalowałem wymagane pakiety za pomocą polecenia sudo apt install git openssh-client -y. System automatycznie doinstalował również dodatkowe zależności, takie jak openssh-server i openssh-sftp-server.
#
#
![1 3](https://github.com/user-attachments/assets/bc699251-1c4a-444d-9b0f-5787b0108665)
Zrzut ekranu 1.3
Sprawdziłem, czy instalacja przebiegła pomyślnie. Komenda git --version potwierdziła, że mam zainstalowaną wersję Gita 2.43.0, a ssh -V pokazało wersję klienta OpenSSH 9.6p1.
#
#
![1 4](https://github.com/user-attachments/assets/b0fc08a0-22fd-42e9-9a20-9e49730e5d02)
Zrzut ekranu 1.4
Wygenerowałem parę kluczy SSH za pomocą komendy ssh-keygen -t ed25519 -C "wmatys.contact@gmail.com". Klucze zostały zapisane w niestandardowej lokalizacji /home/Wojtek/.ssh/id_devops. Wprowadziłem również hasło zabezpieczające klucz prywatny.
#
#
![1 5](https://github.com/user-attachments/assets/f90fc898-0a57-4b40-9519-ba3e0066fd92)
Zrzut ekranu 1.5
Uruchomiłem agenta SSH poleceniem eval "$(ssh-agent -s)", a następnie dodałem nowo utworzony klucz do agenta za pomocą ssh-add ~/.ssh/id_devops. Sprawdziłem zawartość klucza publicznego komendą cat ~/.ssh/id_devops.pub. Na końcu przetestowałem połączenie z GitHubem za pomocą ssh -T git@github.com – autoryzacja zakończyła się pomyślnie.
#
#
![1 6](https://github.com/user-attachments/assets/559c80ce-9878-47a7-99da-939564d024e3)
Zrzut ekranu 1.6
Sklonowałem repozytorium z GitHuba komendą git clone git@github.com:InzynieriaOprogramowaniaAGH/MDO2025_INO.git. Po udanym pobraniu wszystkich plików przeszedłem do katalogu MDO2025_INO i sprawdziłem zdalne repozytorium poleceniem git remote -v. Potwierdziłem, że połączenie zdalne wykorzystuje protokół SSH.
#
#
![1 7](https://github.com/user-attachments/assets/cfc5f14e-5829-4819-b804-b02a11487f6b)
Zrzut ekranu 1.7
Upewniłem się, że jestem na gałęzi main, a następnie wykonałem git pull origin main, aby pobrać najnowsze zmiany z repozytorium. Po tym przełączyłem się na gałąź grupową GCL02, wykonując polecenie git checkout GCL02, co ustawiło lokalną gałąź do śledzenia zdalnej origin/GCL02.
#
#
![1 8](https://github.com/user-attachments/assets/8be4b727-8b87-4c5d-975d-789ae7bfd117)
Zrzut ekranu 1.8
W edytorze Nano utworzyłem plik hooka Git (.git/hooks/commit-msg), który weryfikuje poprawność wiadomości commitów. Skrypt sprawdza, czy pierwszy wiersz wiadomości zaczyna się od mojego identyfikatora WM417892. Jeżeli nie, proces commitowania zostaje przerwany, a użytkownik otrzymuje komunikat o błędzie. Dzięki temu mam pewność, że wszystkie moje commity są odpowiednio oznaczone.
#
#
![1 9](https://github.com/user-attachments/assets/a000013b-c607-467a-ad46-ecf4ab5e1491)
Zrzut ekranu 1.9
Po zapisaniu skryptu hooka nadałem mu uprawnienia do wykonania poleceniem chmod +x. Następnie dodałem do śledzenia nowy plik sprawozdanie.md i wykonałem commit z poprawnie sformatowaną wiadomością zaczynającą się od WM417892. Commit zakończył się powodzeniem, co potwierdza poprawność działania mojego hooka.
#
#
![1 10](https://github.com/user-attachments/assets/99030f59-6c5c-4bc2-a324-846c65ba8b7e)
Zrzut ekranu 1.10
W katalogu INO/GCL02 utworzyłem nowy folder o nazwie WM417892, a następnie przeniosłem do niego plik sprawozdanie.md. Po przeniesieniu usunąłem oryginalny folder z katalogu głównego. Dodałem zmiany do systemu kontroli wersji, zatwierdziłem je z odpowiednią wiadomością commitującą i wypchnąłem gałąź WM417892 do zdalnego repozytorium za pomocą git push origin WM417892.
#
#
#
#
# Sprawozdanie zajęcia 2

## Wprowadzenie
Podczas drugich zajęć zapoznałem się z podstawami pracy z Dockerem oraz przypomniałem sobie najważniejsze komendy związane z systemem kontroli wersji Git. Moim celem było skonfigurowanie środowiska, uruchamianie kontenerów z gotowych obrazów (ubuntu, fedora, busybox, mysql) oraz stworzenie własnego obrazu za pomocą pliku Dockerfile. Dodatkowo zadbałem o wersjonowanie mojej pracy w repozytorium Git oraz stosowanie dobrych praktyk przy commitowaniu zmian.

![2 1](https://github.com/user-attachments/assets/fd68ed6c-cdf5-4a86-b23a-beee65ce2058)
Na powyższym zrzucie ekranu (2.1) widać, że zaktualizowałem system za pomocą polecenia:

```
sudo apt update && sudo apt upgrade -y
```

Dzięki temu upewniłem się, że wszystkie pakiety w systemie są w najnowszych dostępnych wersjach. Jest to dobry krok przygotowawczy przed instalacją nowych narzędzi – w tym przypadku Dockera.
#
#
![2 2](https://github.com/user-attachments/assets/1ac421ff-3e78-4382-977f-7ae0f7e8ada4)
Na zrzucie ekranu 2.2 zainstalowałem pakiety niezbędne do dalszej konfiguracji repozytorium Dockera, używając polecenia:

```
sudo apt install ca-certificates curl gnupg lsb-release
```

Pakiety te odpowiadają m.in. za obsługę certyfikatów SSL, narzędzie `curl` do pobierania danych, system zarządzania kluczami (`gnupg`) oraz identyfikację wersji systemu (`lsb-release`). W moim przypadku były już zainstalowane, więc system ich nie aktualizował.
#
#
![2 3](https://github.com/user-attachments/assets/253727f8-c6ad-4ee6-b295-50badac24f50)
Na zrzucie ekranu 2.3 utworzyłem katalog `/etc/apt/keyrings`, a następnie pobrałem i zapisałem klucz GPG Dockera w systemie. Klucz ten jest potrzebny do weryfikacji autentyczności pakietów Dockera pobieranych z zewnętrznego repozytorium.  
Użyłem poniższych poleceń:

```bash
sudo mkdir -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
```

Dzięki temu mogłem bezpiecznie dodać zewnętrzne repozytorium Dockera do systemowego APT.
#
#
![2 4](https://github.com/user-attachments/assets/c6475bb9-f240-4d5c-b1af-a6babcf03b1b)



#
#
![2 5](https://github.com/user-attachments/assets/7d8736ea-767e-4e06-817c-6044a9924cb9)

