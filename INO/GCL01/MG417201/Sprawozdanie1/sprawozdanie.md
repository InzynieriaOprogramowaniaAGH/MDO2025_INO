# Sprawozdanie1

## Laboratorium 1
**1. Instalacja klienta Git:**

- Aby zainstalować klienta Git należy użyć polecenia `sudo dnf install git-all`

<div align="center"> 
	<img src="screens1/1_git.jpg" alt="Zrzut ekranu z wersją Git-a">
</div>

Powyższy zrzut ekranu przedstawia wynik uruchomienia polecenia `git --version`, w wyniku którego wyświetla się wersja zainstalowanego klienta Git. Stanowi to potwierdzenie poprawnego jego zainstalowania.


**2. Instalacja obsługi kluczy SSH**

- Aby włączyć obsługę kluczy SSH należy:
  - zainstalować pakiet OpenSSH przy użyciu polecenia `sudo dnf install openssh-server`
  - uruchomić usługę _**sshd**_ za pomocą polecenia `sudo systemctl enable sshd`, a następnie `sudo systemctl start sshd`

<div align="center">
	<img src="screens1/1_ssh.jpg" alt="Zrzut ekranu pokazujący skonfigurowanego klienta SSH">
</div>

Powyższy zrzut ekranu pokazuje, że autentyfikacja za pomocą publicznego klucza SSH została poprawnie skonfigurowana.


**3. Sklonowanie repozytorium za pomocą HTTPS i personal access token**

- Aby sklonować repozytorium za pomocą HTTPS i PAT należy:
  - przejść do ustawień na swoim koncie GitHub, wybrać _**Developer settings**_, następnie _**Personal access tokens**_, wygenerować nowy token i go skopiować
  - w terminalu wpisać polecenie `git clone https://PAT@github.com/user/repo.git`, gdzie `PAT` to wygenerowany uprzednio token, a `user/repo.git` to ścieżka na GitHub do repozytorium, które chcemy sklonować
  - istnieje także możliwość zapamiętania tokena poprzez klient Git. W tym celu należy wpisać polecenie `git config --global credential.helper store`, a następnie sklonować repozytorium wpisując swój token. Po tym sklonowaniu token zostanie zapamiętany i nie będzie już potrzeby wpisywania go podczas klonowania, wystarczy wtedy polecenie `git clone https://github.com/user/repo.git`. Z racji że token jest w wyniku tego działania zapisywany w zwykłym pliku tekstowym bez zabezpieczeń, nie jest to optymalne rozwiązanie ze względów bezpieczeństwa.
 
<div align="center"> 
	<img src="screens1/2_repo.jpg" alt="clone personal access token">
</div>

Powyższy zrzut ekranu pokazuje wykonanie polecenia `git clone` przy użyciu HTTPS oraz PAT.


**4. Ustanowienie połączenia między klientem Git a kontem GitHub za pomocą SSH**

- Aby ustanowić połączenie między klientem Git a kontem GitHub należy:
  - wygenerować swój klucz SSH za pomocą wybranego algorytmu szyfrującego, używając polecenia `ssh-keygen -t ed25519 -C "adres.email@domena.com"` 
  - następnie należy wyświetlić klucz publiczny za pomocą polecenia `cat ~/.ssh/id_ed25519.pub` i go skopiować
  - potem w ustawieniach konta GitHub należy wybrać opcję kluczy SSH i dodać skopiowany wcześniej klucz do swojego konta.
- Aby sklonować repozytorium za pomocą SSH należy:
  - na stronie repozytorium na GitHub skopiować jego adres SSH
  - wpisać w terminalu polecenie `git clone git@github.com:user/repo.git`, gdzie _**git@github.com/user/repo.git**_ to skopiowany adres repozytorium

<div align="center"> 
	<img src="screens1/3_git.jpg" alt="SSH">
</div>

Powyższy zrzut ekranu pokazuje wynik wpisania komendy `ssh -T git@github.com` po poprawnym skonfigurowaniu połączenia SSH między klientem Git, a kontem na GitHub, w wyniku działania którego GitHub zostaje dodany do zaufanych hostów. 


**5. Przełączenie się na gałąź main oraz swojej grupy**

- Aby przełączyć się na gałąź main należy:
  - zmienić katalog w którym się znajdujemy w terminalu na katalog główny sklonowanego repozytorium
  - sprawdzić dostępne gałęzie za pomocą polecenia `git branch -a`
  - przełączyć się na gałąź _**main**_ za pomocą polecenia `git checkout main`, można także pobrać najnowsze zmiany w gałęzi za pomocą polecenia `git pull origin main`
- Aby przełączyć się na gałąź grupy należy:
  - wpisać polecenie `git checkout nazwa_grupy`, gdzie można także pobrać najnowsze zmiany w gałęzi za pomocą polecenia `git pull origin nazwa_grupy`


- Aby utworzyć swoją nową gałąź należy:
  - wpisać polecenie `git checkout -b IN123456`, gdzie _**IN123456**_ to inicjały oraz numer indeksu
  - wpisać polecenie `git branch`, aby upewnić się, czy gałąź została poprawnie utworzona i czy jesteśmy na nią przełączeni

<div align="center"> 
	<img src="screens1/4_branches.jpg" alt="branches">
</div>

Powyższy zrzut ekranu obrazuje wykonanie wszystkich powyższych kroków z tego punktu.


**6. Utworzenie nowego katalogu w katalogu grupy**

- Aby utworzyć swój nowy katalog należy:
  - zmienić obecny katalog na katalog grupy za pomocą polecenia `cd`
  - utworzyć nowy katalog za pomocą polecenia `mkdir`, nazywając go także swoimi inicjałami i numerem indeksu

<div align="center"> 
	<img src="screens1/6_1.jpg" alt="Utworzenie katalogu">
</div>

Powyższy zrzut ekranu obrazuje wykonanie powyższych kroków z tego punktu.


**7. Utworzenie Git hooka**

- Aby utworzyć Git hooka należy:
  - w swoim katalogu utworzyć plik _**commit-msg**_ i otworzyć go w edytorze tekstowym, np. nano
  - dodać treść Git hooka, który będzie sprawdzał, czy commit zaczyna się od inicjałów i numeru albumu

<div align="center"> 
	<img src="screens1/6_2.jpg" alt="Git hook">
</div>

Powyższy zrzut ekranu zawiera treść Git hooka.


**8. Skopiowanie Git hooka do odpowiedniego katalogu**

- Aby Git hook uruchamiał się za każdym razem, gdy wywoływane jest polecenie _**commit**_ należy skopiować go do katalogu `.git/hooks`

<div align="center"> 
	<img src="screens1/6_3.jpg" alt="Kopiowanie Git hook'a">
</div>

Powyższy zrzut ekranu obrazuje wykonanie powyższego podpunktu.


**9. Utworzenie sprawozdania i dodanie zrzutów ekranu jako inline**

- Aby utworzyć sprawozdanie w formacie markdown należy użyć polecenia `nano sprawozdanie.md`, a następnie je zapisać, w wyniku czego zostanie utworzony plik
- Aby dodać zrzut ekranu jako inline należy w sprawozdaniu:
  - napisać kod `![alternatywny opis](sciezka/do/pliku/zrzut_ekranu.jpg)`
  - można też użyć _**HTML**_, aby zrzuty ekranu były wyśrodkowane:
    `<div align="center">
	<img src="sciezka/do/pliku/zrzut_ekranu.jpg alt="alternatywny opis">
     </div>`

<div align="center">
	<img src="screens1/6_4.jpg" alt="zrzuty ekranu inline">
</div>

Powyższy zrzut ekranu zawiera fragment kodu sprawozdania, zawierający kod odpowiedzialny za dodanie zrzutów ekranu jako inline za pomocą _**HTML**_.


**10. Wysłanie zmian do zdalnego źródła**

- Aby wysłać zmiany do zdalnego źródła należy użyć poleceń:
  - `git add .`, które dodaje powstałe we wszystkich plikach w katalogu zmiany do 
  - `git commit -m "message"`, które 
  - `git push origin branch`, które aktualizuje wybraną gałąź o zaistniałe zmiany

<div align="center">
  <img src="screens1/6_5.jpg" alt="wysłanie zmian">
</div>

Powyższy zrzut ekranu obrazuje powyżej opisane polecenia.


**11. Wciągnięcie swojej gałęzi do gałęzi grupowej**

- Aby wciągnąć swoją gałąź do gałęzi grupowej należy użyć poleceń:
  - `git checkout group_branch`, które
  - `git merge own_branch`, które
  - `git push origin group_branch`, które
  
<div align="center">
  <img src="screens1/6_5.jpg" alt="wysłanie zmian">
</div>

Powyższy zrzut ekranu obrazuje powyżej opisane polecenia.


***
## Laboratorium 2
![Zrzut ekranu z wersją gita](2/1.jpg)

![Zrzut ekranu z wersją gita](2/2.jpg)

![Zrzut ekranu z wersją gita](2/3.jpg)

![Zrzut ekranu z wersją gita](2/4.jpg)

![Zrzut ekranu z wersją gita](2/5.jpg)

![Zrzut ekranu z wersją gita](2/6.jpg)

![Zrzut ekranu z wersją gita](2/7.jpg)

![Zrzut ekranu z wersją gita](2/8.jpg)

![Zrzut ekranu z wersją gita](2/9.jpg)

![Zrzut ekranu z wersją gita](2/10.jpg)

![Zrzut ekranu z wersją gita](2/11.jpg)


***
## Laboratorium 3


***
## Laboratorium 4
