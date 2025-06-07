
# Sprawozdanie 3 - Amelia Nalborczyk

## Laboratorium 8

1. Utworzenie drugiej maszyny wirtualnej

Maszyna wirtualna została wyposażonna w ten sam system operacyjny i tę samą wersję co "główna" maszyna — Fedora. Podczas instalacji nadano maszynie hostname **ansible-target** oraz utworzono w systemie użytkownika **ansible**.

- Główna maszyna: **amelia@vbox**

- Dodatkowa maszyna: **ansible@vbox**

Na maszynie instaluje narzedzia tar i sshd oraz ansible za pomocą `` sudo dnf install``. Przygotowana maszyma pokazana jest na zdjęciu poniżej

**![](https://lh7-rt.googleusercontent.com/docsz/AD_4nXfLLOUGqZswsCmcSbTysceDduWhQr6mGlbEBcD1ehJxdcDss3PrxCf5CzGjw9wSyAJMTD4pGq_KHK0rEKlqJcocFAPG4ELbB53k_qaMgorty4cHXteQOga9_idgPy2uvC0LZE8UEQ?key=aqMWH6Y7JqkaBE9JZOeZmw)**

2. Wymiana kluczy SSH między użytkownikiem w głównej maszynie wirtualnej, a użytkownikiem `ansible`. Zostało wykonane poprzez wygenerowanie pary kluczy SSH - `ssh-keygen` oraz skopiowanie klucza publicznego na maszynę `ansible-target` wykonano poleceniem`

ssh-copy-id.

` Poprawne połączenie przez ssh bez hasła

**![](https://lh7-rt.googleusercontent.com/docsz/AD_4nXc-xWnlRoGJge6sVHCk2Gyo_bRXCSQzK74BmMDOcxYLJfTo2VBXWGZy5s217NYd9Fs3ATNcoVtAH2kV746q-E0cvv4kb7OPznR-AO1QSJfnmBwlVI5XB7dW2OenrXsGuthTA1QV?key=aqMWH6Y7JqkaBE9JZOeZmw)**

Konfiguracja pliku etc/hosts:

![](https://lh7-rt.googleusercontent.com/docsz/AD_4nXfn8_xVwMTPWZcV5pCe58OrkobB32SgnMvcLb3o94UAtZ6gIY41g6h6EsvSz8sddie9T6UCoNJPm82Bs05Wi_l57kB1u-FBJ_xMBKfldOKX8ag4t-p0-nqk32ZQb9_x91JaXT51eQ?key=aqMWH6Y7JqkaBE9JZOeZmw)

Test połączenia:

**![](https://lh7-rt.googleusercontent.com/docsz/AD_4nXeNY9Py516xruZiRRsXYqkQKWDtGBZ-OZgS0UQKpNTORYLdqrJ2eWeH4ms7XOBfSM03OWJf_KXKGXBipaJZ86jFvE9jOwXkhjZBXV5puJRyZvCVpyQTsu8Y738gjo9BlEK1CQaEWA?key=aqMWH6Y7JqkaBE9JZOeZmw)**

3. Utworzenie migawki jak na załączonym zrzucie ekranu, wybierając migawka:

4. **![](https://lh7-rt.googleusercontent.com/docsz/AD_4nXeONQwPBlWZOj_zyCZMTWarSUS9kjzVZJjHwz2BAIsKoJuh4dWCi-73NOLoeKSGsZ-ONtLA6yl3W1sm6rIuVRyy5WL8WW3RjH2i9bFhvVzqrgPHklp09nCdpWdKj507264ksCgkOA?key=aqMWH6Y7JqkaBE9JZOeZmw)**

5. Inwentaryzacja

Na głównej maszynie zmieniono nazwę hosta na `orchestrator`

**![](https://lh7-rt.googleusercontent.com/docsz/AD_4nXdButu7ridCD6VivNHwQpGEvB3_Bt3tMgfq4DO1y_RDXJbveSKW2HppGA-sLegVpUAz2OouFgXZf-FhgcQW9BnvW0NNE_ndxrtK2vVLVQq8zkTq3ClPIONVy5g3fHhKq7CTjdEDPg?key=aqMWH6Y7JqkaBE9JZOeZmw)**

Konfiguracja nazw DNS (plik `/etc/hosts`), dodano wpisy przypisujące IP do nazw hostów:

**![](https://lh7-rt.googleusercontent.com/docsz/AD_4nXcSzkMDnGCTZdpG0GNh5KZEqv2lVvdA7sjwU-OMTO0YbJGeB12VtQEbcxnCQ5RkvA2pSl1avIrZR3yQdOmbZebD0qgnAkpmvrOy1_FQUY2AA7bMZvqs5XcHfpfL_Qg0jufLAwH-IA?key=aqMWH6Y7JqkaBE9JZOeZmw)**

Test połączenia:

**![](https://lh7-rt.googleusercontent.com/docsz/AD_4nXeNY9Py516xruZiRRsXYqkQKWDtGBZ-OZgS0UQKpNTORYLdqrJ2eWeH4ms7XOBfSM03OWJf_KXKGXBipaJZ86jFvE9jOwXkhjZBXV5puJRyZvCVpyQTsu8Y738gjo9BlEK1CQaEWA?key=aqMWH6Y7JqkaBE9JZOeZmw)**

  
  

7. Utworzono plik `inventory.yml` z podziałem na grupy maszyn:

  

- `Orchestrators` - zawiera maszynę główną

- `Endpoints` - zawiera maszyny docelowe

  

Zawartość pliku `inventory.yml`:

**![](https://lh7-rt.googleusercontent.com/docsz/AD_4nXfC0wM6t-APNkX6wcuKVdQsaE6DNBScUg5AOKKgvag0Ij3Sk9C1a4yhVwWJIQ2cKKJWFuimqOHcIlbHM17hwTEsTDzqMju7wW1blUmBQK3cgii9Rlrkcj71D89soigplUAoGaqlIQ?key=aqMWH6Y7JqkaBE9JZOeZmw)**

Następnie wykonuje ping do wszystkich maszyn:

  

```

ansible all -i inventory.yml -m ping

```

**![](https://lh7-rt.googleusercontent.com/docsz/AD_4nXfBp6NmBwcoEWuLi-rziThRKiIlx0ucyxFvJ7gG-YCWvOl1178JhtOnQ46DRdONDElxAae2jwuoIUAUAwjLWg1rCbgm-UH0jBllkLCgPWIwwYLvn_U_9XHZyQH81SOo5NESgm4FyA?key=aqMWH6Y7JqkaBE9JZOeZmw)**

8. Zdalne wywoływanie procedur. Skopiowanie pliku inwentaryzacji na zdalne maszyny. Utworzono playbook `copy_inventory.yml`, który kopiuje lokalny plik `inventory` do katalogu `/tmp` na wszystkich maszynach docelowych:

**![](https://lh7-rt.googleusercontent.com/docsz/AD_4nXdzunOWZ6pUZAfHUs9UBZZ591Ct_3nqs97oW51d6Hb1fkCJlgB4OC9da5jukG22Jz1vt2Imq-v_mgl8gfaIXiMfBcbn7t3gIrk_m658sAIKgI3FHR2XNvoc-TzRT_M7-lKMZu4p?key=aqMWH6Y7JqkaBE9JZOeZmw)**

Wywołanie procedur:

**![](https://lh7-rt.googleusercontent.com/docsz/AD_4nXcXL3WO6xJOvfOM_aCZ0D2ICZtzyuJzYNS0wspsBP2cDByAbJnKYcec1OGsvdnHDpdtorlAksmTEfPxX1va3EVFm233Feeh_THcpDIXhinijeTkJSiQ1balERm_ptKH5QE1L1Sx4A?key=aqMWH6Y7JqkaBE9JZOeZmw)**

  

9. Ponowne wykonanie operacji kopiowania:

**![](https://lh7-rt.googleusercontent.com/docsz/AD_4nXe1Gdd4nhtHk-P2b24SCQei91j-zsoq-M2jLT8uFV021wdzc9HFN3pj_Z9MzbF5y6Rdd-CImcxhM__KldIJsoyijYsHkr4f2TKvgOFyiboT4N8Hygl3uKtA10Zw14YmnyBgkV8Bvg?key=aqMWH6Y7JqkaBE9JZOeZmw)**

Po pierwszym wykonaniu playbooka `copy_inventory.yml`, plik został skopiowany (status `changed`). Przy ponownym uruchomieniu, Ansible nie wprowadził zmian (status `ok`)

10. Aktualizacja wszystkich pakietów. Stworzono playbook `update_packages.yml`, który używa modułu `apt` z odpowiednimi opcjami:

**![](https://lh7-rt.googleusercontent.com/docsz/AD_4nXeQrq3o6HRluziwP1iUVy670drZFH-w_yNXpcCYq5ncXLTwIT4o7PjHc0oliVH7YgoRwAid1To6NBfhMiEgm24nXT-HkCFpAAI-5ryh9e4HnItAN-p1EyJ1MtHOK6JIcZb-f0WJHw?key=aqMWH6Y7JqkaBE9JZOeZmw)**

11. Restart usług `sshd` i `rngd`. Przygotowano playbook `restart_services.yml`:

**![](https://lh7-rt.googleusercontent.com/docsz/AD_4nXe4ijQKTUwPl6RQ-ReWUoEh9oGK5fy6KVXYil0JoHGPZCJJOAWESDZjyTJ8421yNvHwU35clzjQ5a9PE5XTJbPb_gUiV4FEHBTIBpWUeBSYoVSMflIjolZdZpYdbHvXNXWNwx3_5Q?key=aqMWH6Y7JqkaBE9JZOeZmw)**

12. Test z maszyną niedostępną z wyłączonym serwerem SSH, odpiętą kartą sieciową. Wyłączenie serwera SSH Na maszynie `ansible-target` wykonano

  

```

sudo systemctl stop ssh

```

Efekt działania:

**![](https://lh7-rt.googleusercontent.com/docsz/AD_4nXeh6hRollzt81x8fT9zSzOuLQwrg6ILj_MnJwxKuoCgnleXcO_zI1IRE2PeCNHRVKyHYaQ2NQnP0vwIoUjRa0RJgiPdb9ADaKB90aykV9OU8JHg4W4dtFEdhWzjZMTA_-oHQev8GQ?key=aqMWH6Y7JqkaBE9JZOeZmw)**

Dezaktywacja usługi `sshd`. Podczas kolejnego uruchomienia playbooka, Ansible nie był w stanie nawiązać połączenia z hostem i oznaczył go jako `UNREACHABLE`.

13. Zarządzanie stworzonym artefaktem.

W moim pipeline'ie aplikacji **XZ** budowany był artefakt w postaci pliku binarnego i Dockerfile umożliwiającego uruchomienie aplikacji w kontenerze.

14. Na potrzeby zadania przygotowałam strukturę katalogową roli przy użyciu narzędzia `ansible-galaxy` - ansible-galaxy init manage_artifact. W pliku `tasks/main.yml` zostały zaimplementowane zadania: Instalacja Dockera, Upewnienie się, że Docker działa, Skopiowanie artefaktu `xz.tar.gz`, pliku źródłowego `deploy.c` oraz `Dockerfile`, Budowa obrazu kontenera z aplikacją XZ, Uruchomienie kontenera, Zatrzymanie i usunięcie kontenera po zakończeniu pracy. Treść pliku:

```

- name: Zainstaluj Dockera na Fedorze

  

become: true

  

ansible.builtin.dnf:

  

name: docker

  

state: present

  

  

- name: Upewnij się, że Docker działa

  

service:

  

name: docker

  

state: started

  

enabled: true

  

  

- name: Skopiuj artefakt (plik binarny lub tar.gz)

  

copy:

  

src: xz.tar.gz

  

dest: /home/ansible/xz.tar.gz

  

  

- name: Skopiuj deploy.c

  

copy:

  

src: deploy.c

  

dest: /home/ansible/deploy.c

  

  

- name: Skopiuj Dockerfile

  

copy:

  

src: Dockerfile

  

dest: /home/ansible/Dockerfile

  

  

- name: Zbuduj obraz Docker

  

community.docker.docker_image:

  

name: xz-runtime

  

tag: latest

  

source: build

  

build:

  

path: /home/ansible

  

  

- name: Uruchom kontener

  

community.docker.docker_container:

  

name: xz-app

  

image: xz-runtime:latest

  

state: started

  

  

- name: Zweryfikuj działanie kontenera

  

command: docker ps

  

register: docker_ps

  

  

- name: Pokaż wynik

  

debug:

  

var: docker_ps.stdout_lines

  

  

- name: Zatrzymaj kontener

  

community.docker.docker_container:

  

name: xz-app

  

state: stopped

  

  

- name: Usuń kontener

  

community.docker.docker_container:

  

name: xz-app

  

state: absent

```

15. Tworzę plik inventory:

**![](https://lh7-rt.googleusercontent.com/docsz/AD_4nXfC0wM6t-APNkX6wcuKVdQsaE6DNBScUg5AOKKgvag0Ij3Sk9C1a4yhVwWJIQ2cKKJWFuimqOHcIlbHM17hwTEsTDzqMju7wW1blUmBQK3cgii9Rlrkcj71D89soigplUAoGaqlIQ?key=aqMWH6Y7JqkaBE9JZOeZmw)**

16. Tworze plik playbook:

**![](https://lh7-rt.googleusercontent.com/docsz/AD_4nXcwrwD45PzvA73Qnr4vtRMSeWg0QLI0a3ADOrlNRejhGBLhhSibNP2Cyky6lDBhTlCrjFbiLSgDfriGzZV0Df1Q5bjr-gQo1sHx17ffcX_FDCE5YqtClHA2TEADPEDJpm_bPnQ6?key=aqMWH6Y7JqkaBE9JZOeZmw)**

18. Po uruchomieniu playbooka komendą:

  

`ansible-playbook -i inventory playbook.yml`

  

Ansible wykonał wszystkie kroki z sukcesem. Zrzut ekranu z podsumowaniem:

**![](https://lh7-rt.googleusercontent.com/docsz/AD_4nXevyn41UWUROh2_AXpyFdUM9arPhWmxKU844loC4cnDr2doWO_zHYC5g-94U0Mqi7SLTQiMGIKleoEn-6dU21Skqi0XuVdKDcQQniPgFRDjnkhsb8OzdoqarxOu1KmXedhW-AeTAA?key=aqMWH6Y7JqkaBE9JZOeZmw)**

# Laboratorium 9

1. Przeprowadzenie instalacji nienadzorowanej systemu Fedora z pliku odpowiedzi z naszego repozytorium. Pobranie instalatora sieciowego Fedora NetInstall i zainstalowania maszyny wirtualnej na VirtualBox.

2. Sprawdzenie pliku odpowiedzi Anaconda w katalogu domowym roota:

```

sudo su

ls -l /root

```

**![](https://lh7-rt.googleusercontent.com/docsz/AD_4nXd2pk48qiAVUOXqsaRFOBQ8W8fAgzbAQmgKlOrsMRG0DqjRk6Fb8X2ZEq1k6LjTULrcm7oUjG9nfKgNt9YVPHcr8FRgiFGvJ01FjhwIoE52PyOcm8a2IX7FRzMQtoo-EDFh8uQ8?key=alwe3eVSTx6KlIC6WZ_6dA)**

Plik został dodany do repozytorium, delikatnie go zmodyfikowano: dodano konfigurację źródeł repozytoriów, clearpart --all --initlabel, network --hostname=fedora-mruby.local. Zawartość pliku:

  

3. Automatyczna instalacja korzystając z wcześniej pobranego obrazu ISO Fedora Server. Zamiast standardowego rozpoczęcia instalacji:

- Na ekranie wyboru GRUB naciśnięto klawisz `e` w celu edycji parametrów rozruchu.

- Dodano na końcu linii zaczynającej się od linux parametr:

```

inst.ks=https://raw.githubusercontent.com/InzynieriaOprogramowaniaAGH/MDO2025_INO/AN416663/Sprawozdanie3/anaconda-ks.cfg

```

- Następnie naciśnięto `Ctrl` + `X`, co uruchomiło instalator z podanym plikiem odpowiedzi.

Instalator automatycznie rozpoczął instalację zgodnie z przepisami zawartymi w pliku Kickstart.

4. Utworzono nowy plik `ks.cfg`, który automatyzuje cały proces wdrożenia systemu Fedora oraz kompiluje i uruchamia aplikację stworzoną w ramach projektu xz.

**![](https://lh7-rt.googleusercontent.com/docsz/AD_4nXfGcCRXuZ9pgAh-Bf6CRoqH5ZEJWCyYaDo6ip_OB5MlEiLSo9rxfkxw9FhrYQ_W7ioROcAawVDpZIVhPOS6QicNfQlZRL3N8b0NPlHwokkjruf0hbH1af4E1qEW0e8IZUKadvQT?key=alwe3eVSTx6KlIC6WZ_6dA)**

  

rozszerzono plik odpowiedzi o instalację narzędzi do kompilacji oraz zależności projektu xz, konfigurację użytkownika oraz przygotowanie testowego pliku tekstowego, automatyczne pobranie, zbudowanie i uruchomienie programu `xz` po pierwszym starcie systemu.

5. Instalacja jednostki z XZ:

**![](https://lh7-rt.googleusercontent.com/docsz/AD_4nXfOyMov_FB8YOwl6sQSbiBIrLGJdcTN-9FNlNoKlMGwi5MaRWa-gjwckyoedvArKImYoGC0qqVrKQ2Rb5zvlW21tK2qUhszdci5cygjIiziQdqJcVHFQF7nhyp6ZpMUOyDJQe7spA?key=alwe3eVSTx6KlIC6WZ_6dA)**

**![](https://lh7-rt.googleusercontent.com/docsz/AD_4nXfrfREc4u49W5j7Oy3PLLXwYHnNMhiD3hPU0_Hr-Z_JBhNW2ntCaLdg9wzUmuLuflpNuav5J3D-4gn6hd1xBq43Ox-lC3kT0BX1e84g7fcZiK8SoRTgQ7uXsRHe8qaOzrRChMgZaw?key=alwe3eVSTx6KlIC6WZ_6dA)**

6. Potwierdzenie działania. Usługa zakończyła się bezbłędnie (`status=0/SUCCESS`):

**![](https://lh7-rt.googleusercontent.com/docsz/AD_4nXcpiJQJ1JZbRHXnwBbmYPn9cfgec1DTPWp4biF1lNc2m94cB2adcAkJeA-P7an_l9XCfD_bYdhd8iqy5-eLPr0MWenqF3VYHHIMvAOBqyHew89Y7m9QwvbSKf0-yTcMoWjlEvm6rA?key=alwe3eVSTx6KlIC6WZ_6dA)**

# Laboratorium 10

1. Pobranie i instalacja Minikube za pomocą:

```

curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube_latest_amd64.deb

sudo dpkg -i minikube_latest_amd64.deb

```
**![](https://lh7-rt.googleusercontent.com/docsz/AD_4nXd2Ga5maCycqqoT60Vw1AbSIQErfihWcPXr5cbKSqaTBYhfzq-489I34gWvQHYrdrC4Xq5rfLC91kmez_X-J3wuGrDAFChqdG6yrLqUHPoU7tcuNM88wynLf5acK74wxho9nsrM?key=8a6TqQH7zXhEj00I_c6CFQ)**

2. Uruchomienie klastra Kubernates za pomocą:

```

minikube start

```
**![](https://lh7-rt.googleusercontent.com/docsz/AD_4nXcM9nakyBE7ypDLhD51wV4uJgoVf29nqTnYftprp6UVKsChdMEJ4Whzmu2rQwp2wSHE2aBSYsBVbEtAMX64fx1WUpaAJHZwUFstN0jBP23a2oqOvlk0JkTiGvc8WET-AlLMGMuQKA?key=8a6TqQH7zXhEj00I_c6CFQ)**

Korzystając z Visual Studio Code należy pamiętać o przekierowaniu portów, natomiast z poziomu servera nie jest to potrzebne.

3. Konfiguracja kubectl przy pomocy instrukcji:
```
alias kubectl="minikube kubectl --"
```


**![](https://lh7-rt.googleusercontent.com/docsz/AD_4nXeTcocbw8YwquzLjbjNcBzeOJ9m6JO9uAA1Jt7RwB0ieXOBdPD_OaDEx1Kn-TJIrl_k2mb3wcyA7lTz1SIUZpsyLhnH8y1jlMO-LJM5NvMH1qcA08mrzm9ciJIy2AX3bLzXnxuA0Q?key=8a6TqQH7zXhEj00I_c6CFQ)**

4. Uruchomienie Dashboard:

```

minikube dashboard --url

```
5.  Działanie klastra można potwierdzić poprzez
```
kubectl get nodes
kubectl get pods -A
```

6. Istnieją problemy pochodzące z wymagań sprzętowych. Aby uruchomić klaster Minikube, potrzebne jest podstawowe środowisko wirtualizacyjne oraz odpowiednie zasoby sprzętowe, które zazwyczaj spełniają standardy nowoczesnych komputerów. Według oficjalnej dokumentacji Minikube, minimalne wymagania to:

-   minimum **2 rdzenie procesora**,
    
-   co najmniej **2 GB pamięci operacyjnej (RAM)**,
    
-   około **20 GB wolnej przestrzeni dyskowej**,
    
-   zainstalowany **silnik wirtualizacji lub konteneryzacji**, taki jak:  
    **Docker**, **VirtualBox**, **Podman** albo **KVM**.
7.   Analiza posiadanego kontenera. Zdecydowano się, na potrzeby zadania, wykorzystać prostą stronę internetową w `nginx`.  Dodano własny plik  `index.html` oraz stworzono plik Dockerfile: 
```

FROM nginx:latest
COPY index.html /usr/share/nginx/html/index.html

```

**![](https://lh7-rt.googleusercontent.com/docsz/AD_4nXcyxKSURppHAuB5fbgxahaz5iHMBZuHUAPmlfUsAI2fWIl8iyJY2_Q45HEUucu8qrb7ogeyN0xQsevwF9psFcc7nm-3DM7AVLjBPNjcMFwqiRKLEk_WhaA3DF2VH-FNXU60vX75XQ?key=8a6TqQH7zXhEj00I_c6CFQ)**
8. Obraz został zbudowany: 
 ![](https://lh7-rt.googleusercontent.com/docsz/AD_4nXdbpRmBd56Ldp-C7dL61VVmn0CZkhPuKUFw2PR4qop6DffFCDDO93kP4A-RvBVupFVO3uabQwbIVW7kyPSiq4iOO0E3q0bWwkITQa6FoUrwYsDfQg7rVL0ZFeOJM3hhGso9AS5E_Q?key=BMv5uDomi4pfV7xdbm2aNA)**
9. Uruchomiony został kontener z aplikacją, następnie uruchomiono obraz, oraz potwierdzam działanie przez kubectl:
**![](https://lh7-rt.googleusercontent.com/docsz/AD_4nXdiDecEMLxF5RK8jdT2RtKSdWhmHX3Wa1d5KbgptJWuLiBOU9ukk1hVqkSCKrbDdPds810f-M0b4rzd4ji4_oi6fyjcv-iU1AtaobgcRa5l7rshNutNIn7fP8H4tllM0UnCEoeChA?key=8a6TqQH7zXhEj00I_c6CFQ)**

10.  Działanie 'pod' w Dashbord prezentuje poniżej:
**![](https://lh7-rt.googleusercontent.com/docsz/AD_4nXda2ixyRp4z9Lz7MBMmPfbvJT4WNZ5fuDuKg92K4vgKXfrqmcqD4mlykA5AZv3UihCAc42Bn2OCSgvaFMreYtaG__RZ0IGTrt3fFNNWHoClSn6Gdb-yAPW8cBuERhVpW60cwcluww?key=8a6TqQH7zXhEj00I_c6CFQ)**
11.  Eksponowanie portu. Przekierowano port aplikacji, z portu 80 na port 8081, poleceniem: `minikubctl port-forward pod/nginx-custom-pod 8081:80`. Zrobiono tunel SSH z hosta do maszyny wirtualnej, przekierowując port 8083 lokalnie na porcie 8081 maszyny zdalnej:
**![](https://lh7-rt.googleusercontent.com/docsz/AD_4nXdZ4EZEFHrSPEVEk3zVB-JOvZW51Spul2pqLHeZETXR65JT37R421GUtuz8Qt_6Q7fp3EHF6Xbun77PfSjItNXzrxiSAAq8bBJU2uuIFtvH1a7fw17aHMSbFb6Y8pAyoWZvhuu_?key=BMv5uDomi4pfV7xdbm2aNA)**
12.  Otworzenie aplikacji w witrynie na porcie 8083:
**![](https://lh7-rt.googleusercontent.com/docsz/AD_4nXfEhtgsrNOpY8_I5QTEjdUHvkDfWhGfcPsQcWGX9We69DLFw4Is3A3Z0HYPAnWaEbo0o-e54FMmN9oIIhaJ5uIIC3I4Os-4MVkUOvdeEHLXlm5AY7m0oTm-UFxOZpjZ_1v09KvUzA?key=BMv5uDomi4pfV7xdbm2aNA)**
13. W następnym kroku wykonuje przekucie wdrożenia manualnego w plik wdrożenia. Przygotowano plik wdrożenia `deployment.yaml`:
**![](https://lh7-rt.googleusercontent.com/docsz/AD_4nXcAR8WBlDZb-7257rW55gE6F9j118p1Va14gjc0J2Y9__txPYjaZeNwFakNRVglNpMJ26UiLfIcOTcHNW5hKQ9dlW0LHbjm5Gg2N9HPctotdQjzSrTVYPWmsOZEw9YVySo-CvFcHQ?key=BMv5uDomi4pfV7xdbm2aNA)**
14.  Wdrożono poleceniem `minikubctl apply -f deployment.yaml`, oraz sprawdzono poprawność wdrożenia:
**![](https://lh7-rt.googleusercontent.com/docsz/AD_4nXcc8-30djKC4rH0tqkp4L7otuusXBe-LcBbKt4O3tVwzQgw7WkdIRr8v0gyQFaCtCYqdd32yN2RIVqFlvN6hgQz5P42pZKiCTEmABXTdkng9J0VwgRhZMEFPFIHQFwa_32JzwzjEw?key=BMv5uDomi4pfV7xdbm2aNA)**
15. Tworze w Dashboard za pomocą `scale` 4 repliki dla nginx-custom-deployment:
**![](https://lh7-rt.googleusercontent.com/docsz/AD_4nXdppmCVQGoFGOqlTEzF4-q3sxHpQ7IDyXqxn2mDlizanhmOpfDQb-ekuPPASp7vQ0lg_IdxWTXY-AmRrt3kXoc5wjMQ4MwyfAqCPyTO9YY0Csgc7rC7mNI8OpUrwQgWTxUxaEGA4g?key=BMv5uDomi4pfV7xdbm2aNA)**
16. Wdrożenie aplikacji z pliku YAML
Polecenie użyte do wdrożenia oraz jego wynik:

`kubectl apply -f deployment.yaml` i `kubectl get deployments` oraz `kubectl get pods`

17.  Eksportowanie pliku jako serwis:
**![](https://lh7-rt.googleusercontent.com/docsz/AD_4nXdzVyalesRBaIoYWdsf7C8hZUWvKPoaUNyKgtoh97zLe73D69pCUoOkKTetYXHO2Zc2fNAlcVyqSRAuzWfD6kjFDFq86GXD5dnFWRmY6zWYxrmHomIHxf7sQz_8iKd5jGW3YKrKjg?key=BMv5uDomi4pfV7xdbm2aNA)**
Zawartość pliku service.yaml:
**![](https://lh7-rt.googleusercontent.com/docsz/AD_4nXfsc_ZZJXqi4CtglXrhhld7nuesVRpU7FPHZvExef5P91ry6-XHbBynclVSjSrz1SMnoUmpeRnQfSXed5Bwn6tr_0jPDD75VCb2L1Ntb5-YNF9J1plsTLwUbW5s90gDkmFoDeuXDg?key=BMv5uDomi4pfV7xdbm2aNA)**
18. Przekierowanie portu:
**![](https://lh7-rt.googleusercontent.com/docsz/AD_4nXeuHlSizyDC7MVtA30S7WxZ8kRQ9oqt4V5VomUxLFD-RkeBk9TghoQ5-MUQmz2ElRa7NZddYUiQoZrZcqqHKNDDR1QDyID3VWKBfAc_nTeyJZpYjHaUcAn55RZY-DSLeii3zq6uJg?key=BMv5uDomi4pfV7xdbm2aNA)**


## Laboratorium 11
1. Przygotowanie obrazu. Przygotowano trzy wersje obrazu nginx. w postaci plików index.html oraz plików Dockerfile. 
### Wersja 1:
Plik index.html
```
<!DOCTYPE html>
<html>
<head><title>Wersja 1</title></head>
<body><h1>To jest wersja 1 strony nginx</h1></body>
</html>
```
### Wersja 2:
Plik index.html
```
<!DOCTYPE html>
<html>
<head><title>Wersja 2</title></head>
<body><h1>To jest wersja 2 strony nginx</h1></body>
</html>
```
Plik Dockerfile (identyczny dla Wersji 1 i Wersji 2):
```
ROM nginx
COPY index.html /usr/share/nginx/html/index.html
```
### Wersja 3 - błędem:
Plik Dockerfile:
```
FROM nginx
CMD ["false"]
```
3.  Budowanie wszystkich wersji za pomocą docker build:
**![](https://lh7-rt.googleusercontent.com/docsz/AD_4nXfXsjAqUke19j2Ai9DYB773OMIXFX3MTYwqIMaJFfLZmEpMKrr0sK4Z_u1eRU0i60pVzSc0Zlmu0gnsEHveuKA7GhOLz-YLFCZCoy5H2p2tK7Sy3_9QW_NJPGzou80mIgObMIMcBA?key=PF0mpeeANT5iqxCQxdkEJA)**
**![](https://lh7-rt.googleusercontent.com/docsz/AD_4nXfDdBc9guEQ8-0bbTukWGUT7kr4IhwUfR8LUndsKIa7vGSc81UO91f5Afgog-s9gcSAyFq1TX7V4W5mp3ewxbYQvgwRO9pPmj4qQEFTK6SlKz6550mNP_LXiMbT7-MASpaQA0-MKw?key=PF0mpeeANT5iqxCQxdkEJA)**
**![](https://lh7-rt.googleusercontent.com/docsz/AD_4nXeLh05PCZ8iX26HPNbKbyPZzu9AWO0jzo6jxdnURgW-SWitxMKC7qRsNMvwZlX5CB5F6NhTIqTUmOEd01Y3Ocj0aTAO0hp8-pW4XBF3FVY2uF4x5ctWFnQmZajUNivfmJONGkjWZQ?key=PF0mpeeANT5iqxCQxdkEJA)**
4.  Wypychanie na Docker Hub trzech wersji:
**![](https://lh7-rt.googleusercontent.com/docsz/AD_4nXdGJbDVc03LenWi-6XXTrNdnLv085pf7QeuPSuIDrGFJbvqWsZBLE61HdQSxXVdr11_3Qq8jQqF5ap9UkC3vRPLu7Km9Uqmi1U5TPmS4jsW5hbAiR8menJg3xO8rP0pTsD2Bdf_sQ?key=PF0mpeeANT5iqxCQxdkEJA)**
**![](https://lh7-rt.googleusercontent.com/docsz/AD_4nXdwx-KoS7CfeA8_i5pvFxCO3vBJyh7zQh9b2xnF9nyvq2OehqHWP11dyRMz8sBbiK1xncig8DBrbqDxtu3Z0dJorIgwbdYWybNJWl19IdBRPiDJ_vfohwVNHbDgsmACZHWDYazr?key=PF0mpeeANT5iqxCQxdkEJA)**
**![](https://lh7-rt.googleusercontent.com/docsz/AD_4nXeLAdFh25dbrsPSZ7QftOk7LVr85ESNDBRZXeQhdG5Zhf5Q5ISygiEPc2HcPaJMW55ceQmtxOhHHCu_QfiuTA3VBOmoREqdqvNrj1H8trqn1tawPC-X3wl9NAMPpTF67sQw8_DCdA?key=PF0mpeeANT5iqxCQxdkEJA)**
5.  Modyfikowałam plik nginx-deployment.yaml, by zmieniać ilość replik. Zawartość pliku:
**![](https://lh7-rt.googleusercontent.com/docsz/AD_4nXfL4iRiLuxoMct9ab3DFoScGYP4rBQBs80rF1WQrbGqxTywD3O1EvbHcupbA3lAv_BMZktx-oaPEzWQue-ao-mIrz7dRad1glfBw-XJnDyBY-0rEtkh_6XFk2bZ4KcXaBNQO-REnw?key=PF0mpeeANT5iqxCQxdkEJA)**
Zmieniam wartość `replicas` na: 8, 0, 1, 4 i wdrażam aplikację za pomocą instrukcji: `kubectl apply -f nginx-deployment.yaml`
**![](https://lh7-rt.googleusercontent.com/docsz/AD_4nXfLSWk5liYVmmWZnsDT3ePXZQCPLe_sn6loecSPdJSk0G2N9tpyzjbN0IDWulxTw4ajddWjo861GhNEFjwOa6msuMFpRUSO6mJye03KZZr4dtz_f-3ff1JdYKT4kKWUpj3rZrkN9Q?key=PF0mpeeANT5iqxCQxdkEJA)**
6.  Zastosowanie nowej wersji obrazu - zmieniam parametr `image`, efekt wdrożenia wygląda następująco:
**![](https://lh7-rt.googleusercontent.com/docsz/AD_4nXc8N6VJT-lk1IYlfMqiioY2fhRuhLE54zazZ7Lip1KjyU2DyF-uhl5fD7d0t-JRoBogIO67aRK58ZkpfHqmsU-rS83MB4H0juZn3si92BnaAW2_BFqync097uRf08PIloC8BZ3RHQ?key=PF0mpeeANT5iqxCQxdkEJA)**
7.  W następnym kroku z powrotem zmieniam na pierwszą wersje obrazu, a następnie na wadliwą wersję obrazu:
![](https://lh7-rt.googleusercontent.com/docsz/AD_4nXcAU9BQWyO57THJVEgcPYjMGFQ3emiYSHeWULBU5krjB9bZ8BlOYsgzjc53VWINB9UV-_rxrLdMwZvApYy1rn-9D3C-PemIEdrK6kXn1AcMvYDQkcmUHdR-kWy_xKQIxLRTD5YEhQ?key=PF0mpeeANT5iqxCQxdkEJA)
8. W ramach sprawdzenia historii wdrożeń przeprowadzam rollout:
**![](https://lh7-rt.googleusercontent.com/docsz/AD_4nXfknXIdbvPGyFQ_P-GSbAc9lwIsCdG9_7OAHFcoSlDIW6KtYZ7dfI1kF9BbXXh7LOIJG-JF2iS0PfvCLWWRiwQ4Cm_oQqovUxHguaFKAQuPLVNARkIJUZh_lHk_7jActWIZN4cR?key=PF0mpeeANT5iqxCQxdkEJA)**
9.  W ramach kontroli wdrożenia utworzono weryfikujący, czy wdrożenie "zdążyło" się wdrożyć w 60 sekund. Efekt działania programu:
**![](https://lh7-rt.googleusercontent.com/docsz/AD_4nXeod6Vu1FQMcCFwTpc9C-whi6V565pXU0Ac821AS3Z1NG_jVCKsD6zE8BDP9Rjuz_IeYVfHe_9N_eXYc8J9TKGAgv5zpj4jT6oQbAb6y2rc1gCbmTp8-ULfHn_aSSeSgA-nOP7iVg?key=PF0mpeeANT5iqxCQxdkEJA)**
Kod skryptu:
**![](https://lh7-rt.googleusercontent.com/docsz/AD_4nXcChsIPyHQXFGqAE5CuGBhg3W2QGkG9vhv20cpp8hoTqHiqp3za5d3O6KMr-CkbiFWRK0AN9_EXn-hf786yQgfowfAe86Ou2KqCm0ZsCYHCWr9Ogg6_ohwwkglCwuV2U4_X_ECPtQ?key=PF0mpeeANT5iqxCQxdkEJA)**
11.  Implementacja strategii wdrożenia:
### Plik: `nginx-recreate.yaml` (fragment)
` strategy:
    type: Recreate
`

W tej metodzie stare pody są całkowicie usuwane przed uruchomieniem nowych, co może prowadzić do chwilowej przerwy w działaniu aplikacji.
Plik: `recreate-deployment.yaml`

### Plik: `nginx-rollingupdate.yaml` (fragment)
```
 strategy:
    type: RollingUpdate
    rollingUpdate:
      maxUnavailable: 2
      maxSurge: 30%
 ```

Zastosowano domyślną strategię `RollingUpdate`, która umożliwia stopniowe wdrażanie nowych wersji aplikacji bez przerywania jej działania. Parametr `maxUnavailable: 2` pozwala, by jednocześnie niedostępne były maksymalnie dwa pody, a `maxSurge: 25%` umożliwia tymczasowe utworzenie dodatkowego poda (przy 4 replikach oznacza to jeden dodatkowy pod).
### Plik: `nginx-rollingupdate.yaml` (fragment)
```
 matchLabels:
      app: nginx
      version: stable
  template:
    metadata:
      labels:
        app: nginx
        version: canary
```
W tej strategii równocześnie działają dwie wersje aplikacji – stabilna i testowa. Umożliwia to stopniowe wprowadzanie nowej wersji (v2) poprzez kierowanie części ruchu do nowej instancji, bez zakłócania działania wersji produkcyjnej.
12. Poprawne zakończenie rolloutów:
**![](https://lh7-rt.googleusercontent.com/docsz/AD_4nXfDp6McxnZWd6rwAvkcl8wxGsVwVkHETSrqIh37hQZ9bTnDSpwrfSb1u_lm-slT6ljM8cBIY1FbhG7t_OVNbXWynvNPVg03LZsIO7-NAEY8TtS00DF3Uexb6o4p9YTPw7mivwxHXw?key=PF0mpeeANT5iqxCQxdkEJA)**

