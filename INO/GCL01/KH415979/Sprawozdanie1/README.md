# Sprawozdanie 1

Pierwszym krokiem było utworzenie maszyny wirtualnej z systemem linuxowym (tutaj jest to Fedora), wraz ze stworzeniem użytkownikia (o nazwie kh). Następnie skonfigurowano środowisko Visual Studio Code, aby możliwe było połączenie się z maszyną przez protokół ssh. Następnie można było przejść do realizacji kroków z instrukcji.

## Ćwiczenie 1

Pierwszym krokiem było pobranie git'a na maszynę wirtualną. Użyto do tego poniższej komendy:

![alt text](image.png)

Następne w katalogu .ssh należało wygenerować 2 klucze (1 zabezpieczony hasłem) oraz dodać je jako metodę weryfikacji.

```
 key-gen -t ed25519
```

Oraz dodać je do githuba, aby móc sklonować repozytorium.

![](image-4.png)

Następnie należało podłączyć się do repozytorium przedmiotu na githubie przy pomocy HTTPS.

![alt text](image-1.png)
Spowodowało to utworzenie folderu `MDO2025_INO`.
![alt text](image-2.png)

Konieczne było też przejście na gałąź grupy, oraz utworzenie własnej gałęzi.

```
git checkout GCL01
git checkout -b KH415979
```
![alt text](image-5.png)

Następnie należało dodać git hook'a, który sprawdza, czu każdy commit zaczyna się od moich inicjałów o numeru indeksu. Hook znajduje się w folderze `.git/hooks/`

![alt text](image-3.png)

