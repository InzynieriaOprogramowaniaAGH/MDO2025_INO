
### Autor: Kamil Wielgomas, 414502, gr. 8


#### Wykonanie:
1. Sprawdziłem, czy `git` oraz klient `ssh` został pomyślnie zainstalowany razem z obrazem Fedora Server
![git/ssh](1.png)
a następnie połączyłem się z maszyną wirtualną za pomocą klienta ssh na komputerze osobistym.
![polaczenie](1_b.png)

2. Stworzyłem
6. git hook
```bash
MSG=$1
if ! grep -qE "^KW414502" "$MSG";then
    cat "$MSG"
    echo "Commit musi sie zaczynac od KW414502"
    exit 1
fi
```