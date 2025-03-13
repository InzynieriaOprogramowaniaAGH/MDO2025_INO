# Sprawozdanie1

## Laboratorium 1
**1. Instalacja klienta Git:**
Aby zainstalować klienta Git należy użyć polecenia `sudo dnf install git-all`

<div align="center"> 
	<img src="1/1_git.jpg" alt="Zrzut ekranu z wersją Git-a">
</div>

Powyższy zrzut ekranu przedstawia wynik uruchomienia polecenia `git --version`, w wyniku którego wyświetla się wersja zainstalowanego klienta Git. Stanowi to potwierdzenie poprawnego jego zainstalowania.


**2. Obsługa kluczy SSH**
Aby włączyć obsługę kluczy SSH należy:
- uruchomić usługę _**sshd**_ za pomocą polecenia `sudo systemctl enable sshd`, a następnie `sudo systemctl start sshd`
- wygenerować swój klucz SSH za pomocą wybranego algorytmu szyfrującego, używając polecenia `ssh-keygen -t ed25519 -C "adres.email@domena.com"`, a następnie wyświetlić klucz publiczny za pomocą polecenia `cat ~/.ssh/id_ed25519.pub` i go skopiować. Potem należy w ustawieniach konta GitHub wybrać opcję kluczy SSH i dodać skopiowany wcześniej klucz do swojego konta.

<div align="center">
	<img src="1/1_ssh.jpg" alt="Zrzut ekranu pokazujący skonfigurowanego klienta SSH">
</div>
Powyższy zrzut ekranu pokazuje, że autentyfikacja za pomocą publicznego klucza SSH została poprawnie skonfigurowana.

![Zrzut ekranu z wersją gita](1/2_repo.jpg)

![Zrzut ekranu z wersją gita](1/3_git.jpg)

![Zrzut ekranu z wersją gita](1/4_branches.jpg)

![Zrzut ekranu z wersją gita](1/6_1.jpg)

![Zrzut ekranu z wersją gita](1/6_2.jpg)

![Zrzut ekranu z wersją gita](1/6_3.jpg)

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
##Laboratorium 3


***
##Laboratorium 4
