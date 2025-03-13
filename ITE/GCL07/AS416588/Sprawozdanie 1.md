### **Lab1**
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

### LAB 2
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
