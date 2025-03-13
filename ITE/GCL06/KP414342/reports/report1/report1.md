# Połączono z serwerem poprzez SSH

![alt text](2.png)

# Sklonowano repozytorium za pomocą HTTPS
![alt text](1.png)
# Wygenerowano klucze SSH
![alt text](3.png)
![alt text](4.png)
# Dodano klucz SSH na GitHubie
![alt text](5.png)
# Sklonowano repozytorium poprzez SSH
![alt text](6.png)
# Przełączono na gałąź grupy i utworzono własną gałąź
![alt text](7.png)
# Stworzono Git Hooka
```
#!/bin/sh

COMMIT_MESSAGE=$(cat "$1")

if [[  ! $COMMIT_MESSAGE =~ ^KP414342 ]]; then
    echo "ERROR: Commit message does not start with KP414342"
    exit 1
fi

exit 0
```
# Przetestowano działanie Git Hooka

![alt text](8.png)
![alt text](9.png)

# Wysłano zmiany
![alt text](10.png)