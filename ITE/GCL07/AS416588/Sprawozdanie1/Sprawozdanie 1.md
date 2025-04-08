### **LAB1**
Maszyna wirtualna
![](images/Pasted%20image%2020250312165842.png)

Instalacja gita
![](images/Pasted%20image%2020250312170259.png)
Konfiguracja użytkownika:![](images/Pasted%20image%2020250313152523.png)

Uzyskiwanie klucza personalnego (classic), poprzez wykonanie następujących instrukcji zawartych w dokumentacji:
1. [Verify your email address](https://docs.github.com/en/account-and-profile/setting-up-and-managing-your-personal-account-on-github/managing-email-preferences/verifying-your-email-address), if it hasn't been verified yet.
    ![](images/Pasted%20image%2020250312171053.png)
2. In the upper-right corner of any page on GitHub, click your profile photo, then click  **Settings**.
    ![](images/Pasted%20image%2020250312171106.png)
3. In the left sidebar, click  **Developer settings**.
    ![](images/Pasted%20image%2020250312171114.png)
4. In the left sidebar, under  **Personal access tokens**, click **Tokens (classic)**.
    ![](images/Pasted%20image%2020250312171129.png)
5. Select **Generate new token**, then click **Generate new token (classic)**.
    ![](images/Pasted%20image%2020250312171153.png)
6. In the "Note" field, give your token a descriptive name.
    ![](images/Pasted%20image%2020250312171411.png)
7. To give your token an expiration, select **Expiration**, then choose a default option or click **Custom** to enter a date.
    ![](images/Pasted%20image%2020250312171437.png)
8. Select the scopes you'd like to grant this token. To use your token to access repositories from the command line, select **repo**. A token with no assigned scopes can only access public information.
    ![](images/Pasted%20image%2020250312171829.png) + inne potrzebne scope'y
9. Click **Generate token**.
![](images/Pasted%20image%2020250312172129.png) 

Klonowanie repo
![](images/Pasted%20image%2020250312173038.png)

Tworzenie klucza SSH
![](images/Pasted%20image%2020250312175304.png)
![](images/Pasted%20image%2020250312175414.png)
i dołączenie go do githuba:
![](images/Pasted%20image%2020250312175643.png)

Klonowanie repozytorium:
![](images/Pasted%20image%2020250312212704.png)

Konfiguracja 2FA:
![](images/Pasted%20image%2020250312212908.png)
![](images/Pasted%20image%2020250312212921.png)
![](images/Pasted%20image%2020250312213057.png)![](images/Pasted%20image%2020250312213145.png)

Przełączenie się na gałąź main a później na gałąź grupy:
![](images/Pasted%20image%2020250312213859.png)

Utworzenie własnej gałęzi:
![](images/Pasted%20image%2020250312214158.png)

Utworzenie katalogu:
![](images/Pasted%20image%2020250312214931.png)

Git hook i dodanie tego skryptu do stworzonego katalogu:
![](images/Pasted%20image%2020250312215615.png)

Skopiowanie git hooka w do folderu .git/hooks tak, aby wyświetlał się on przy każdym commitcie:
![](images/Pasted%20image%2020250312220313.png)

Dodanie uprawnień do uruchomienia skryptu:
![](images/Pasted%20image%2020250312221123.png)

##### Commitowanie:
![](images/Pasted%20image%2020250313152355.png)

Błąd, ponieważ komentarz commitu nie zaczyna się od ustawionej wiadomości:
![](images/Pasted%20image%2020250313152751.png)

Poprawnie wykonany commit:
![](images/Pasted%20image%2020250313152914.png)

Pushowanie:
![](images/Pasted%20image%2020250313153009.png)

Branch:
![](images/Pasted%20image%2020250313153147.png)

---

### **LAB 2**
Aktualizowanie systemu:
![](images/Pasted%20image%2020250313181204.png)
po to aby zainstalować dockera:![](images/Pasted%20image%2020250313182157.png)

Włączenie dockera:
![](images/Pasted%20image%2020250313183347.png)

Zainstalowany docker:
![](images/Pasted%20image%2020250313193606.png)

Tworzenie konta na dockerHub:
![](images/Pasted%20image%2020250313193703.png)
![](images/Pasted%20image%2020250313193735.png)

Pobranie obrazów docker:
![](images/Pasted%20image%2020250313194109.png)
Zainstalowane obrazy:
![](images/Pasted%20image%2020250313194132.png)

Utworzony kontenera busybox:
![](images/Pasted%20image%2020250313194251.png)

Interaktywne podłączenie się do kontenera busybox i wywołanie jego wersji:
![](images/Pasted%20image%2020250313194443.png)

Uruchomienie fedory i uzyskanie informacji o PTD1 w kontenerze:
![](images/Pasted%20image%2020250313200100.png)

Pokazanie na hostcie procesów dockera:
![](images/Pasted%20image%2020250313200322.png)

Aktualizowanie pakietów:
![](images/Pasted%20image%2020250313200448.png)
i wyjście:
![](images/Pasted%20image%2020250313200515.png)

Plik dockerfile:
![](images/Pasted%20image%2020250313201301.png)

Buildowanie dockerfile'a:
![](images/Pasted%20image%2020250313201627.png)

Stworzony własny obraz:
![](images/Pasted%20image%2020250313201709.png)

Odpalenie kontenera z widocznym sklonowanym repo:
![](images/Pasted%20image%2020250313202026.png)

Wszystkie uruchomione kontenery:
![](images/Pasted%20image%2020250313202331.png)

Wyłączenie kontenerów:
![](images/Pasted%20image%2020250313213036.png)

Usunięciu kontenerów:
![](images/Pasted%20image%2020250313213249.png)![](images/Pasted%20image%2020250313213424.png)

Usunięcie obrazów:
![](images/Pasted%20image%2020250313213324.png)![](images/Pasted%20image%2020250313213343.png)

---

### **LAB3**
#### Budowanie i testowanie projektu na maszynie:
Klonowanie repo:
![](images/Pasted%20image%2020250318201305.png)

Instalowanie zależności:
![](images/Pasted%20image%2020250318201554.png)
![](images/Pasted%20image%2020250318201948.png)

Kompilacja:
![](images/Pasted%20image%2020250318202008.png)
![](images/Pasted%20image%2020250318202040.png)

Testy:
![](images/Pasted%20image%2020250318202818.png)

#### Ręczne budowanie i testowanie w kontenerze:
Uruchomienie konterenra:
![](images/Pasted%20image%2020250326165630.png)

Instalacja zależności:
![](images/Pasted%20image%2020250326170844.png)

Stworzenie folderu:
![](images/Pasted%20image%2020250326172233.png)

Klonowanie repo:
![](images/Pasted%20image%2020250326172435.png)

Kompilacja:
![](images/Pasted%20image%2020250326172517.png)
![](images/Pasted%20image%2020250326172542.png)

Testy:
![](images/Pasted%20image%2020250326174514.png)
#### Automatyzacja budowy i testowania w kontenerze:
Dockerfiles:
![](images/Pasted%20image%2020250318205531.png)
![](images/Pasted%20image%2020250318204521.png)

![](images/Pasted%20image%2020250318210340.png)
![](images/Pasted%20image%2020250318210347.png)

#### Budowa obrazu kontenera z aplikacją:
![](images/Pasted%20image%2020250318211404.png)
![](images/Pasted%20image%2020250318211434.png)

Uruchomienie:
![](images/Pasted%20image%2020250318211529.png)
![](images/Pasted%20image%2020250318211511.png)


### **LAB4**

Przygotowanie woluminów: wejściowy i wyjściowy, i podłączenie ich do kontenera bazowego:
![](images/Pasted%20image%2020250331200229.png)

Uruchomienie kontera i zainstalowanie potrzebnych zależności:
![](images/Pasted%20image%2020250331202021.png)
![](images/Pasted%20image%2020250331201333.png)

Sklonowanie repo na wolumin wejściowy:
![](images/Pasted%20image%2020250331202319.png)

Uruchomienie buildu w kontenerze:
![](images/Pasted%20image%2020250331202436.png)
![](images/Pasted%20image%2020250331202459.png)

Zapisanie plików na woluminie wyjściowym, tak by były dostępne po wyłączniu kontenera:
![](images/Pasted%20image%2020250331202939.png)![](images/Pasted%20image%2020250331203009.png)

Usunięcie plików:
 ![](images/Pasted%20image%2020250331212434.png)
 
 Doinstalowanie gita w kontenerze:
![](images/Pasted%20image%2020250331212541.png)

Ponowne klonowanie w kontenerze:
![](images/Pasted%20image%2020250331212728.png)

Ponowne uruchomienie buildu w kontenerze:
![](images/Pasted%20image%2020250331213908.png)
![](images/Pasted%20image%2020250331213924.png)

Ponowne zapisanie plików na woluminie wyjściowym, tak by były dostępne po wyłączniu kontenera:
![](images/Pasted%20image%2020250331220123.png)

Odpalenie wewnątrz kontenera serwer ipref:
![](images/Pasted%20image%2020250331224544.png)


Sprawdzenie adresu IP kontenera z serwerem:
![](images/Pasted%20image%2020250331222746.png)

Uruchomienie kontenera z klientem i nawiązanie połączenia:
![](images/Pasted%20image%2020250331224649.png)

Tworzenie własnej sieci:
![](images/Pasted%20image%2020250331223154.png)

Usuwanie starych kontenerów:
![](images/Pasted%20image%2020250331223510.png)

Ponowne odpalenie kontenera przy użyciu własnej sieci:
![](images/Pasted%20image%2020250331223538.png)

Nawiązanie połączenia:
![](images/Pasted%20image%2020250331223846.png)

Instalacja iperf3 na host'cie:
![](images/Pasted%20image%2020250331225513.png)

Łączenie się z hosta:
![](images/Pasted%20image%2020250331225637.png)

Zdobycie adresu IP maszyny:
![](images/Pasted%20image%2020250331230227.png)

Połączenie się z komputera z kontenerem działającym na maszynie wirtualnej:
![](images/Pasted%20image%2020250331230345.png)

Uruchomienie z woluminem na logi:
![](images/Pasted%20image%2020250331230824.png)

Po połączeniu nic nie zostało wypisane na serwerze:
![](images/Pasted%20image%2020250331230948.png)

Ponieważ informacje zostały zapisane do logów:
![](images/Pasted%20image%2020250331231027.png)

#### Jenkins:
Stworzenie sieci mostkowej:
![](images/Pasted%20image%2020250331231820.png)

Stworzenie dwóch folderów potrzebnych do Jenkins:
![](images/Pasted%20image%2020250331231938.png)

Tworzenie kontenera Jenkins:
![](images/Pasted%20image%2020250331232205.png)

Stworzenie Dockerfile'a:
![](images/Pasted%20image%2020250331232509.png)

Tworzenie obrazu:
![](images/Pasted%20image%2020250331232626.png)

Uruchomienie Jenkinsa:
![](images/Pasted%20image%2020250331233625.png)

Wnętrze Jenkinsa (pokazanie uruchomionych kontenerów):
![](images/Pasted%20image%2020250331233635.png)

Uruchomiony Jenkins:
![](images/Pasted%20image%2020250331233718.png)

