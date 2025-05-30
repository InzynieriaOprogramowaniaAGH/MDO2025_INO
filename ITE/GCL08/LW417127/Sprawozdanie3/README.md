## ANSIBLE

![](class8/screens/1.jpg)

![](class8/screens/2.jpg)

![](class8/screens/3.jpg)

![](class8/screens/4.jpg)

![](class8/screens/5.jpg)

![](class8/screens/6.jpg)

![](class8/screens/7.jpg)

![](class8/screens/8.jpg)

![](class8/screens/9.jpg)

![](class8/screens/10.jpg)

![](class8/screens/11.jpg)

![](class8/screens/12.jpg)

![](class8/screens/13.jpg)

![](class8/screens/14.jpg)

![](class8/screens/15.jpg)

![](class8/screens/16.jpg)

![](class8/screens/17.jpg)

![](class8/screens/18.jpg)

## PLIK ODPOWIEDZI (KICKSTART)

![](class9/screens/1.jpg)

![](class9/screens/2.jpg)

![](class9/screens/3.jpg)

![](class9/screens/4.jpg)

![](class9/screens/5.jpg)

![](class9/screens/6.jpg)

## KUBERNETES PART I

![](class10/screens/1.jpg)

![](class10/screens/2.jpg)

![](class10/screens/3.jpg)

![](class10/screens/4.jpg)

![](class10/screens/5.jpg)

![](class10/screens/6.jpg)

![](class10/screens/7.jpg)

![](class10/screens/8.jpg)

![](class10/screens/9.jpg)

![](class10/screens/10.jpg)

![](class10/screens/11.jpg)

![](class10/screens/12.jpg)

![](class10/screens/13.jpg)

![](class10/screens/14.jpg)

![](class10/screens/15.jpg)

![](class10/screens/16.jpg)

![](class10/screens/17.jpg)

![](class10/screens/18.jpg)

![](class10/screens/19.jpg)

![](class10/screens/20.jpg)

![](class10/screens/21.jpg)

![](class10/screens/22.jpg)

![](class10/screens/23.jpg)

## KUBERNETES PART II

![](class11/screens/1.jpg)

![](class11/screens/2.jpg)

![](class11/screens/3.jpg)

![](class11/screens/4.jpg)

![](class11/screens/5.jpg)

![](class11/screens/6.jpg)

![](class11/screens/7.jpg)

![](class11/screens/8.jpg)

![](class11/screens/9.jpg)

![](class11/screens/10.jpg)

![](class11/screens/11.jpg)

![](class11/screens/12.jpg)

![](class11/screens/13.jpg)

![](class11/screens/14.jpg)

![](class11/screens/15.jpg)

![](class11/screens/16.jpg)

![](class11/screens/17.jpg)

![](class11/screens/18.jpg)

![](class11/screens/19.jpg)

![](class11/screens/20.jpg)

![](class11/screens/21.jpg)

![](class11/screens/22.jpg)

 - Recreate: Gwałtowna zmiana, wszystkie stare pody są usuwane przed utworzeniem nowych. Powoduje przerwę w dostępności usługi. Prosta, ale ryzykowna.

 - Rolling Update: Stopniowa wymiana podów. Aplikacja pozostaje dostępna podczas aktualizacji. maxUnavailable kontroluje, ile podów może być jednocześnie niedostępnych, a maxSurge ile dodatkowych podów może zostać utworzonych. Bezpieczniejsza, domyślna strategia.

 - Canary Deployment: Wypuszczanie nowej wersji dla małego podzbioru użytkowników/żądań. Pozwala na testowanie nowej wersji w produkcji na ograniczoną skalę przed pełnym wdrożeniem. Wymaga bardziej zaawansowanej konfiguracji (dwa deploymenty, odpowiedni routing przez serwis/ingress). Najbezpieczniejsza dla krytycznych zmian, ale najbardziej złożona w implementacji w podstawowym Kubernetes.