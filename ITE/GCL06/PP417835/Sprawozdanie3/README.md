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

Plik odpowiedzi pozyskałem kilka tygodni temu ale niestety nie zrobiłem screenów. O prawdziwości moich słów może świadczyć fakt, że w katalogu ITE/GCL06/PP417835/lab9/ ostatni commit jest sprzed miesiąca
1

Kreator nowej maszyny która skorzysta z pliku odpowiedzi
![](./screeny/lab9/screen1.jpg)

2

Początkowo chciałem kożystać z fedory 42 jednak przez...
![](./screeny/lab9/screen2.jpg)

taki oraz inne blędy zdecydowałem się pracować dalej na fedorze 41 
![](./screeny/lab9/screen2_2.jpg)
3


![](./screeny/lab9/screen3.jpg)

Instalacja zakończona sukcesem
5
![](./screeny/lab9/screen5.jpg)
6

plik odpowiedzi dzięki któremu powyższa instalacja się dokonała. Hasło wpisałem tymczasowo na stałe ponieważ zapomniałem starego ale wiem, że to bardzo zła praktyka
![](./screeny/lab9/screen6.jpg)
7

Plik odpowiedzi który od razu przy pierwszym uruchomieniu nowej maszyny wirtualnej zapisuje na niej docker z programem ```curl```, który był celem pipeline z poprzedniego sprawozdania
```
miejsce na ostateczny plik wdrożenia
```

Potwierdzenie, że isntalacja nowej maszyny przebiegła zgodnie z założeniami
![](./screeny/lab9/screen7.jpg)


# kubernetes
1
![](./screeny/kubernetes/screen1.jpg)
2
![](./screeny/kubernetes/screen2.jpg)
3
![](./screeny/kubernetes/screen3.jpg)
4
![](./screeny/kubernetes/screen4.jpg)
5
![](./screeny/kubernetes/screen5.jpg)
6
![](./screeny/kubernetes/screen6.jpg)
7
![](./screeny/kubernetes/screen7.jpg)
8
![](./screeny/kubernetes/screen8.jpg)
9
![](./screeny/kubernetes/screen9.jpg)
10
![](./screeny/kubernetes/screen10.jpg)
11
![](./screeny/kubernetes/screen11.jpg)
12
![](./screeny/kubernetes/screen12.jpg)
13
![](./screeny/kubernetes/screen13.jpg)
14
![](./screeny/kubernetes/screen14.jpg)
15
![](./screeny/kubernetes/screen15.jpg)
16
![](./screeny/kubernetes/screen16.jpg)
17
![](./screeny/kubernetes/screen17.jpg)
18
![](./screeny/kubernetes/screen18.jpg)
19
![](./screeny/kubernetes/screen19.jpg)
20
![](./screeny/kubernetes/screen20.jpg)
21
![](./screeny/kubernetes/screen21.jpg)
22
![](./screeny/kubernetes/screen22.jpg)

