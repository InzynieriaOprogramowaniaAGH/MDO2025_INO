# Sprawozdanie 3 Dawid Reszczyński

## Cel ćwiczeń

Laboratorium obejmowało kompleksowy przegląd nowoczesnych narzędzi do automatyzacji, od poziomu instalacji systemu operacyjnego, przez zarządzanie jego konfiguracją, aż po orkiestrację aplikacji kontenerowych.

Na laboratoriach zyskałem praktyczne doświadczenie w wykorzystaniu Ansible do bezagentowego zarządzania systemami, przeprowadziłem automatyczną instalację OS za pomocą pliku Kickstart, a następnie wdrożyłem i zarządzałem aplikacją Nginx w środowisku Kubernetes (Minikube). Kluczowym elementem było testowanie zaawansowanych strategii wdrażania (Recreate, Rolling Update, Canary) oraz mechanizmów rollback, co stanowi fundament niezawodnych systemów IT.

## Ćw 8 - Automatyzacja i zdalne wykonywanie poleceń z wykorzystaniem Ansible

### Instalacja Ansible na drugiej maszynie

#### Instalacja maszyny ansilbe-target i ustawienie odpowiedniego hostname

![ansible-target](images/image.png)

#### Instalacja openssh-server i tar

![openssh/tar](images/image-1.png)

#### Włączenie SSH

![ssh](images/image-2.png)

### Instalacja Ansible na maszynie głównej

#### Zmiana hosta na "ansible-main"

![host](images/image-3.png)

#### Instalacja Ansible

![ansible](images/image-4.png)

#### Wygenerowanie klucza ssh na głównej maszynie 

Klucz będzie wykorzystywany do komunikacji z innymi maszynami

![ssh-key](images/image-5.png)

#### IP maszyny "ansible-target"

![ip](images/image-6.png)

I tutaj pojawił się problem - nie mogłem skopiować kluczy - wymagało to zmiany ustawień karty sieciowej ansible-target na bridged

![bridged](images/image-7.png)

Stąd zmiana IP

#### Skopiowanie kluczy na docelową maszynę

![key-copy](images/image-8.png)

#### Logowanie na maszyne "ansible target" poprzez ssh

Warto zauważyć, że logowanie odbyło się bez podania hasła

![login](images/image-9.png)

#### Sprawdzenie komunikacji

![communication](images/image-10.png)

### Inwentaryzacja

#### Dodanie DNS na dwóch maszynach, by rozpoznawać nazwy hostów

![ansible-main](images/image-11.png)
![ansible-target](images/image-12.png)

#### Utworzenie pliku inwentaryzacji (inventory.ini). 

`Orchestrators` - maszyny zarządzające
`Endpoints` - maszyny docelowe

![inventory](images/image-24.png)

#### Wywołanie żądania ping dla wszystkich maszyn za pomocą ansible

```bash 
ansible all -i inventory.ini -m ping
```

![ping](images/image-13.png)

Tutaj wynikło, że trzeba dodać dopisek do pliku inventory informującym o byciu zalogowanym lokalnie na maszynie
![inv-login](images/image-14.png)

![ping2](images/image-15.png)

### Zdalne wywoływanie procedur 

#### Utworzenie pliku `playbook.yaml` i dodanie taska wysyłającego ping

![playbook](images/image-16.png)
```bash 
ansible-playbook -i inventory.ini playbook.yaml
```

#### Rozbudowanie `playbook.yaml` o kolejne zadania

![playbook2](images/image-17.png)

Pojawił się błąd: 

![ping-notsuccess](images/image-18.png)

Rozwiązanie to dodanie hasła do sudo do pliku `inventory.ini`

![inv-pass](images/image-19.png)

#### Wynik 

Jak widać, wszystko wykonuje się poprawnie:
 - SSH zostaje zresetowane prawidłowo
 - RNGD nie zostaje znalezione, więc jest ignorowane (zgodnie z plikiem .yaml)

![ping-success](images/image-20.png)

### Zarządzanie Kontenerem

#### Stworzenie nowego playbooka 

![playbook-new](images/image-21.png)

#### Rezultat

![result](images/image-22.png)

### Wnioski

Integracja narzędzia Ansible z ekosystemem Docker pozwoliła na skuteczną realizację celów w zakresie automatyzacji wdrażania aplikacji. Zastosowanie dedykowanych playbooków umożliwiło standaryzację cyklu życia kontenerów, od ich inicjalizacji po finalne uruchomienie aplikacji.

Kluczowym rezultatem jest znaczące uproszczenie zarządzania infrastrukturą kontenerową oraz uzyskanie zdolności do szybkiego dostosowywania konfiguracji do bieżących potrzeb projektowych. Takie podejście jest zgodne z paradygmatem elastycznych i skalowalnych systemów IT. Cały proces techniczny, obejmujący konfigurację i uruchomienie, został precyzyjnie udokumentowany przy użyciu zrzutów ekranu, co stanowi kompletną bazę referencyjną.

## Ćw 9 - Nienadzorowana Instalacja 

#### Skopiowanie pliku `anaconda-ks.cfg` do repozytorium

![anaconda-copy](images/image-23.png)

#### Modyfikacja pliku 

- Dodanie wzmianek o repozytoriach fedory
![anaconda-modify1](images/image-25.png)

- ustawienie hostname
![anaconda-modify2](images/image-26.png)

- wzmianki o pakietach (dodanie dockera)
![anaconda-modify3](images/image-27.png)

- formatowanie dysku
![anaconda-modify4](images/image-28.png)

#### Sekcja %post

W sekcji post odbywa sie inicjalizacja kontenera 

![anaconda-modify5](images/image-29.png)

#### Finalna wersja `anaconda-ks.cfg`

![anaconda-final](images/image-30.png)

#### Umieszczenie pliku na github

Plik umieściłem na github pod tym [linkiem](https://raw.githubusercontent.com/InzynieriaOprogramowaniaAGH/MDO2025_INO/refs/heads/DR415825/ITE/GCL06/DR415825/Sprawozdanie3/anaconda-ks.cfg)

#### Dopisanie zależności przy instalacji

Podczas instalacji nacisnąłem klawisz `e`, żeby przejść do uzupełnienia zależności 
Dopisanie `init.ks=https://raw.githubusercontent.com/InzynieriaOprogramowaniaAGH/MDO2025_INO/refs/heads/DR415825/ITE/GCL06/DR415825/Sprawozdanie3/anaconda-ks.cfg`

![grub-install](images/image-31.png)

#### Instalacja 
![instalation1](images/image-32.png)
![instalation2](images/image-33.png)

Po zalogowaniu widać kontener irssi i podłączyć się do niego za pomocą `docker attach`

![instalation3](images/image-34.png)
![instalation4](images/image-35.png)


Jak widać wszystko się uruchamia i działa poprawnie - ćwiczenie wykonane

### Wnioski

Podczas zajęć zautomatyzowano proces instalacji systemu Fedora, co dowiodło skuteczności plików Kickstart w tworzeniu powtarzalnych środowisk. Kluczowym elementem był centralnie zarządzany plik konfiguracyjny `anaconda.ks` przechowywany na GitHubie.

Jeśli chodzi o plusy tego rozwiązania, to są następujące:
- **Pełna automatyzacja:** Plik Kickstart umożliwił bezobsługowe przeprowadzenie całego procesu – od partycjonowania dysku, przez tworzenie użytkowników, aż po instalację konkretnych pakietów (Docker, Git).
- **Konfiguracja "po instalacji":** Wykorzystano skrypt post-install do automatycznego uruchomienia kontenera, co pokazuje, że system może być gotowy do pracy natychmiast po pierwszym starcie.
- **Prostota uruchomienia:** Cała procedura została zainicjowana jednym parametrem startowym w GRUB-ie `inst.ks=...`, co minimalizuje ryzyko błędu ludzkiego.


## Ćw 10-11 Kubernetes

### Wdrażanie na zarządzalne kontenery (L10)

#### Instalacja i uruchomienie Minikube

Pobranie i zainstalowanie Minikube 

![minicube-download](images/image-36.png)

Dodanie aliasu do skrócenia polecenia `minikube kubectl --` na `kubectl` 

![minicube-alias](images/image-37.png)

Sprawdzenie minikube `minikube version`

![minicube-version](images/image-38.png)

Uruchomienie minikube `minikube start`

![minicube-start](images/image-39.png)

Uruchomienie dashboard'u `minikube dashboard`

![minicube-dashboard-terminal](images/image-40.png)
![minicube-dashboar-browser](images/image-41.png)

#### Deployment i Service'y

Stworzenie plików `depl-nginx.yaml` i `serv-nginx.yaml` w celu późniejszego apply'u aplikacji
![deploy-file](images/image-42.png)
![serv-file](images/image-43.png)

Apply plików

![files-apply](images/image-44.png)

Weryfikacja czy pody i service'y zostały poprawnie utworzone
![pod-list](images/image-45.png)
![service-list](images/image-46.png)
![dashboard-list](images/image-47.png)

Port-forwarding z portu 8080 na localhost w celu ekspozycji aplikacji poza klaster

![forward](images/image-48.png)
![ports-vscode](images/image-49.png)
![nginx-browser](images/image-50.png)

### Wdrażanie na zarządzalne kontenery (L11)

#### Utworzenie Obrazów

Stworzenie 3 różnych od siebie obrazów nginxa

`Dockerfile1` - oryginalny obraz

![dockerfile1](images/image-51.png)

`Dockerfile2` - obraz ze zmienionym head'erem

![dockerfile2](images/image-52.png)

`DockerfileBad` - obraz, który zawsze zwróci błąd

![dockerfilebad](images/image-53.png)

#### Zbudowanie obrazów i publish

Logowanie do dockerhuba `docker login`

![docker-login](images/image-54.png)

Zbudowanie obrazów `docker build`

![docker-build](images/image-55.png)

Push do dockerhuba `docker push`

![docker-push](images/image-56.png)

I tak dla wszystkich obrazów

![docker-for-everyone](images/image-57.png)

#### Zbudowanie deploymentu i service'ów dla obrazów

Modyfikacja plików `depl-nginx.yaml` i `serv-nginx.yaml`

![depl-mod](images/image-58.png)
![serv-mod](images/image-59.png)

Apply `kubectl apply`

![depl-apply](images/image-60.png)
![serv-apply](images/image-61.png)

#### Zmiana ilości replik dla każdego deploymentu 

Uywane polecenia:
- `kubectl scale` - zmiana replik
- `kubectl set images/image` - zmiana obrazu
- `kubectl rollout undo` - powrót do poprzedniej wersji

Obrazy: 

- `nginx-custom:v1`
![nginx1-1](images/image-62.png)
![nginx1-2](images/image-63.png)

- `nginx-custom:v2` - zmiana obrazu i ilości replik 
![nginx2-1](images/image-64.png)
![nginx2-2](images/image-65.png)
![nginx2-3](images/image-66.png)

- `nginx-custom:bad` - zmiana obrazu
![nginx3-1](images/image-67.png)
![nginx3-2](images/image-68.png)

- Powrót do poprzedniej wersji
![nginx4-1](images/image-69.png)
![nginx4-2](images/image-70.png)

- Eventy
![nginx5-1](images/image-71.png)

#### Sprawdzenie statusu rolloutów i deploymentu 

`kubectl rollout history` i `kubectl rollout status`

![kubectl-history](images/image-72.png)
![kubectl-status](images/image-73.png)

#### Plik sprawdzający wykonanie deploymentu

Utworzenie pliku `check_deployment.sh`

![deployment-check-file](images/image-74.png)

Nadanie mu uprawnień i wykonanie go

![check-file-on](images/image-75.png)

#### Zmiana strategii 

- RollingUpdate
![rolUp1](images/image-76.png)
![rolUp2](images/image-77.png)
![rolUp3](images/image-78.png)

- Recreate
![recr1](images/image-79.png)
![recr2](images/image-80.png)

#### Stworzenie wdrożenia Canary Deployment

Utworzenie pliku `canary-nginx.yaml`
![canary-nginx](images/image-81.png)

Apply: 

![canary-apply](images/image-82.png)

Sprawdzenie działania wszystkich podów:

![pods-chack](images/image-83.png)

Deploymenty: 

![depl-check](images/image-84.png)

### Wnioski

#### Podsumowując działanie strategii wdrożeń w Kubernetesie, można wyciągnąć następujące wnioski:

- `Rolling Update` jest standardowym, zrównoważonym podejściem. Wnioskujemy, że sprawdza się najlepiej, gdy priorytetem jest utrzymanie ciągłości działania, a organizacja jest przygotowana na szybkie wycofanie błędnej wersji.
- `Recreate`, mimo swojej prostoty, ma ograniczone zastosowanie. Jej implementacja oznacza przerwę w działaniu, co prowadzi do wniosku, że jest odpowiednia głównie dla środowisk deweloperskich lub aplikacji, których chwilowa niedostępność jest akceptowalna.
- Zastosowanie `Canary Deployment` świadczy o dojrzałości procesu CI/CD. Konieczność rozbudowy monitoringu i konfiguracji oznacza, że to metoda dla kluczowych systemów. Wniosek jest taki, że minimalizacja ryzyka biznesowego jest tu ważniejsza niż prostota techniczna.


