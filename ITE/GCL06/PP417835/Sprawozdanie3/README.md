# sprawko 3

## ansible

nie mam instalacji ansibla bo instalowałem z Panem na zajęciach i nie robiłem screenów w tym czasie


Działająca nowa maszyna do ansible

![](./screeny/ansible/screen1.jpg)

Utworzenie migawki

![](./screeny/ansible/screen2.jpg)

Utworzenie nowego klucza i jego przesłanie do nowej maszyny co zapewni łączność ssh bez użycia hasła

![](./screeny/ansible/screen3.jpg)

![](./screeny/ansible/screen4.jpg)

zmiany w pliku config w katalogu ssh aby wskazać na klucz za pomocą którego mają być ustanawiane połączenia z nową maszyną

![](./screeny/ansible/screen5.jpg)

![](./screeny/ansible/screen6.jpg)

logowanie za pomocą ssh do nowej maszyny bez użycia hasła

![](./screeny/ansible/screen7.jpg)

# inwentaryzacja

zmiana nazwy hosta maszyny głównej i dowód na zmianę po restarcie

![](./screeny/ansible/screen8.jpg)

![](./screeny/ansible/screen9.jpg)


# sass

10

dodanie na maszynie gównej skojarzenia nazwy słownej z adresem IP nowej maszyny dzięki czemu będzie możliwe odnoszenie się do nowej maszyny po nazwie słownej która jest wygodniejsza od adresu IP
![](./screeny/ansible/screen10.jpg)
11

Identycznie skojarzenie słowne tylko w drugą stronę

![](./screeny/ansible/screen11.jpg)
12
Pingowanie dwóch maszyn nawzajem aby sprawdzić czy połączenie zostało poprawnie ustanowione

![](./screeny/ansible/screen12.jpg)
13
utworzenie pliku inventory.ini
```
miejsce na inventor
```

oraz wpisanie klucza publicznego który służy do łączenia się między maszynami do pliku kluczy autoryzowanych oraz nadanie odpowiednich uprawnień plikowi kluczy autoryzowanych aby możliwe było dokonanie pingu ansiblowego
![](./screeny/ansible/screen13.jpg)
14

udany ping ```ansible```, który różni się od "normalnego" pingu 
![](./screeny/ansible/screen14.jpg)
15

Utworzenie playbooka, który ma za zadanie określenie parametrów i wywołanie procedur na nowych maszynach

Przepraszam za wpis po polsku w playbooku ale wspomagałem się AI przy napisaniu tego playbooka i nie zauważyłem aby przetłumaczyć wyrażenie na angielski
![](./screeny/ansible/screen15.jpg)
16

"Uruchomienie" playbooka, który poprawnie skopiował plik inwentarza co jest oznaczone przez napis ```changed=1``` 
![](./screeny/ansible/screen16.jpg)
17

Ponowne uruchomienie nie wykazuje już żadnych zmian co znaczy, że wszystko działa poprawnie
![](./screeny/ansible/screen17.jpg)
18

Połączenie się z nową maszyną i zainstalowanie na niej ```rngd```
![](./screeny/ansible/screen18.jpg)
19

Rozbudowanie playbooka o część odpowiedzialną za aktualizacje i restart usług
![](./screeny/ansible/screen19.jpg)
20

Uruchomienie playbooka po rozbudowaniu, który aktualizuje pakiety i uruchamia usługi co jest znowu potwierdzone wartością change większą od 0
![](./screeny/ansible/screen20.jpg)
21

Zatrzymanie usługi ssh na nowej maszynie
![](./screeny/ansible/screen21.jpg)
22

Po zatrzymaniu usługi nie ma połączenia więc playbook nie "przechodzi" co jest porządanym i logicznym działaniem
![](./screeny/ansible/screen22.jpg)
23

Po ponownym włączeniu ssh wszystko wróciło do normy
![](./screeny/ansible/screen23.jpg)
24

Uruchomienie ```ansible-galaxy init user``` co utworzyło szkielet roli
![](./screeny/ansible/screen24.jpg)
25

Dalsza rozbudowa playbooka mająca za zadanie wdrożenie na nowej maszynie obrazu dockera stworzonego w poprzednim sprawozdaniu

```
miejsce na play booka
```

```
miejsce na playbooka deploy
```

![](./screeny/ansible/screen25.jpg)
26

Błąd działania nowego rozbudowanego playbooka wynikający z tego, że na dockerhubie nie miałem obrazu ```latest``` 
![](./screeny/ansible/screen26.jpg)
27

Dopiero wpisanie konkretnej wersji rozwiązało ten problem. 

Wpisywanie konkretnej wersji jest mieczem obosiecznym ponieważ z jednej strony mamy pewność której wersji aplikacji używamy co uodparnia nas na potencjalne niestabilności w naszych zastosowaniach które mogą pojawić się przy nowych wersjach. Z drugiej jednak strony ręczne zmienianie wiersji może być uciążliwe i może prowadzić do "zapomnienia" o aktualizacjach co w dłuższej perspektywie może mieć znaczące konsekwencje
![](./screeny/ansible/screen27.jpg)
28

Po zmianie na stałą wersję playbook wykonuje się poprawnie
![](./screeny/ansible/screen28.jpg)



## masowe wdrożenia 
1
![](./screeny/lab9/screen1.jpg)

2
![](./screeny/lab9/screen2.jpg)
3
![](./screeny/lab9/screen3.jpg)
4
![](./screeny/lab9/screen4.jpg)

5
![](./screeny/lab9/screen5.jpg)
6
![](./screeny/lab9/screen6.jpg)
7
![](./screeny/lab9/screen7.jpg)


# kubernetes