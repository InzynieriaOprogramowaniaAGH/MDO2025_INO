# Sprawozdanie 1
#### Wojciech Zacharski ITE gr. 10

<br>

## Laboratorium nr 1

**1. Instalacja klienta Git i obługi kluczy SSH**

Bez hasła
![s1](../Sprawozdanie1/Sprawozdanie1_img/s1_1.png)

Z hasłem
![s2](../Sprawozdanie1/Sprawozdanie1_img/s1_2.png)

Potwierdzenie sprarowania kluczy z gitem
![s3](../Sprawozdanie1/Sprawozdanie1_img/s1_3.png)

Konfiguracja klucza SSH na GitHubie
![s3](../Sprawozdanie1/Sprawozdanie1_img/s1_4.png)

Konfiguracja 2FA
![s3](../Sprawozdanie1/Sprawozdanie1_img/s1_5.png)

**Sklonowanie repozytorium za pomocą HTTPS**

![s3](../Sprawozdanie1/Sprawozdanie1_img/s1_6.png)

**Przełączenie na gałąź main**

![s3](../Sprawozdanie1/Sprawozdanie1_img/s1_7.png)


**Utworzenie lokalnej gałęzi**

![s3](../Sprawozdanie1/Sprawozdanie1_img/s1_8.png)

Utworzenie katalogu

![s3](../Sprawozdanie1/Sprawozdanie1_img/s1_9.png)


**Praca na lokalnej gałęzi**
Utworzenie nowego git hooka
![s3](../Sprawozdanie1/Sprawozdanie1_img/s1_10.png)

Treść git hooka
```bash
#!/bin/sh
if ! grep -q "WZ417828" "$1"; then
  echo "Commit message must start with WZ417828"
  exit 1
fi
```

