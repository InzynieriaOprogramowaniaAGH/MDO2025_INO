# 1. Zainstaluj klienta Git i obsługę kluczy SSH

## konfiguracja ssh, maszyny wirtualnej oraz srodowiska pracy w VSC
![alt text](<lab1/konfiguracja ssh.png>)

## Utowrzenie folderu przedmiotowego oraz instalacja gita

do zainsatlowania gita nalezy użyc nizej wymienionych polecen:
```sh
mkdir devops
sudo dnf install -y git
git --version
```
![alt text](<lab1/instalacja gita.png>)

![alt text](<lab1/git version.png>)

## sklonowanie repozytorium predmiotowego narazie przez https

uźywamy polecenia:
```sh
git clone https://(adres repozytorium).git
```

![alt text](<lab1/sklonowanie repo.png>)

adres znajdujemy na stronie repozytorium

![alt text](<lab1/https clone.png>)

### historia polecen do tego punktu:
![alt text](<lab1/histroria polecen1.png>)

# 2. Generacja kluczy ssh oraz sklonowanie po SSH

## Wygenerowanie pierwszego klucza ssh
W pierwszej kolejnosci generujemy klucz bez zabezpieczen poleceniem:
```sh
ssh-keygen -t klucz szyfrowania[u nas => ed25519] -C "email konta github"
```
przy czym w kolejnych krokach wybieramy miejsce zapisu kluczy (u nas domysle), a w miejscu gdzie pytaja nas o hasło klikamy enter zostawiajac klucz jako niezabezpieczony

![alt text](<lab1/wygenerowanie klucza 1.png>)

## Wygenerowanie drugiego klucza ssh (zabezpieczonego)

klucz generujemy w ten sam sposob jak pierwszy z roznica ze gdy pytaja nas o haslo to je ustawiamy.

![alt text](<lab1/wygenerowanie klucza 2.png>)

### nalezy pamietac ze w kazdym wypadku generujemy 2 klucze - publiczny i prywatny

## Dodanie klucza do githuba:
aby znalezc miejsce do dodania kluczy ssh na githubie musimy kolejno:
```
Kliknac w profil > settings > SSH and GPG keys > new SSH key
```
![alt text](lab1/sshkeys1.png)
![alt text](lab1/sshkeys2.png)
![alt text](lab1/sshkeys3.png)

nastepnie dodajemy klucz:

![alt text](<lab1/dodanie klucza do githuba.png>)

### historia polecen do tego punktu: 
![alt text](<lab1/historia polecen2.png>)

## Utworzenie agenta ssh
mozna utworzyc agenta ssh by przy kazdym odpaleniu sesji nie trzeba bylo caly czas wpisywac hasła. Mozna go utworzyc następująco:
```sh
eval "$(ssh-agent -s)"
ssh-add ~/.(sciezka do klucza)
```

![alt text](<lab1/agent ssh.png>)

## Sklonowanie repozytorium przez SSH
uzywamy komendy:
```sh
git clone (analogicznie link z githuba)
```
link po ssh znajdujemy:
![alt text](<lab1/ssh clone.png>)

### nalezy pamietac by zrobic to w osobnym folderze

![alt text](<lab1/klon repo ssh.png>)

### historia polecen do tego punktu

![alt text](<lab1/historia polecen3.png>)

# 3. Utworzenie gałęzi lokalnej

## Stworzenie nowej gałęzi lokalnej wraz z nowym folderem na któym będziemy pracować

folder tworzymy analogicznie jak eyżej
do utworzenia nowej galęzi używamy komendy:
```sh
git checckout -b (nazwa brancha)
```
![alt text](<lab1/utworzenie nowegio brancha.png>)

### Historia polecen tego punktu:
![alt text](<lab1/historia polecen4.png>)

# 4. Praca na nowej gałezi

## Utworzenie git hooka
git hook - jest to wymog dla gita by kazdy commit zaczynal sie od okreslonych słów w naszym przypadku sa to inicjały i nr albumu

![alt text](<lab1/utworzenie hooka.png>)
![alt text](<lab1/tresc githooka.png>)

## Dodanie git hooka do configa
w pierwszej kolejnosci musimy dodac naszemu git hookowi uprawninia do wykonywania 
```sh
chmod +x (plik)
```
nastepnie dodajemy do configa naszego nowo utworzonego git hooka

```sh
git config --local core.hooksPath (sciezka do pliku)
```

![alt text](<lab1/dodanie do configa.png>)

## Sprawdzenie dzialania git hooka

![alt text](<lab1/sprawdzenie dzialania.png>)

# 5. Spuszowanie galezi do galezi grupowej 

![alt text](<lab1/spuszowanie commita.png>)