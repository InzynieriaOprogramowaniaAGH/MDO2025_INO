## Sprawozdanie

### 1. Instalacja Gita i konfiguracja kluczy SSH
- Zainstalowałem Gita w systemie 
- Wygenerowałem klucze SSH:  
- Klucze publiczne dodałem w ustawieniach GitHuba (zakładka **SSH and GPG keys**).
- Skonfigurowałem 2FA na koncie GitHub.

---

### 2. Klonowanie repozytorium
**Klon przez SSH** (po dodaniu klucza do GitHub i skonfigurowaniu agenta SSH):
![Klonowanie przez SSH](./repo-clone.png)

---

### 3. Przełączanie się na gałęzie
- Przełączyłem się na gałąź `main`, a następnie na gałąź grupową `GCL04`. Następnie utworzyłem gałąź składającą się z moich inicjałów i numeru indeksu:
  ![Zmiana brancha](./switch-branch.png)

---

### 4. Utworzenie katalogu i napisanie Git hooka
1. W katalogu **ITE/GCL04** stworzyłem folder `JW414829`.
2. W tym folderze umieściłem plik **sprawozdanie.md** oraz skrypt hooka `commit-msg`.
3. Następnie skopiowałem skrypt hooka do `.git/hooks/commit-msg`, nadając mu prawa wykonywalne.

#### Treść hooka (`commit-msg`)

```bash
#!/usr/bin/sh
#
# Hook commit-msg: sprawdza, czy commit message zaczyna się od określonego prefiksu

# Wymagany prefiks
required_prefix="JW414829"

# Pobranie pierwszej linii komunikatu z pliku przekazanego jako pierwszy argument
first_line=$(head  -n1  "$1")

# Sprawdzenie, czy pierwsza linia zaczyna się od wymaganego prefiksu
case  "$first_line"  in
"$required_prefix"*)
;;
*)
echo  "Błąd: commit musi zaczynać się od '$required_prefix'." >&2
exit  1
;;

esac
```

![Test hooka](./hook-test.png)

---

### 5. Dodanie sprawozdania, zrzutów ekranu i wysłanie zmian
- Utworzyłem/zmodyfikowałem pliki, dodałem je i zrobiłem commit:
  ```bash
  git add .
  git commit -m 'JW414829 sprawko i pliki'
  git push origin JW414829
  ```
- Wykonałem próbę wciągnięcia mojej gałęzi do gałęzi grupowej aczkolwiek nie pushowalem tego na remote.
![Test merge](./merge.png)

---