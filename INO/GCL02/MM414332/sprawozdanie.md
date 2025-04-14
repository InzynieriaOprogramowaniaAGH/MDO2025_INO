Sprawozdanie 1

Laboratorium1
Po zainstalowaniu koniecznego oprogramowania czyli w moim przypadku Ubuntu Server na VirtualBox przystąpiłem do wykonywania zadania.
Skopiowałem repozytorium za pomocą HTTPS, przełączyłem się na gałąź main, następnie na GCL02, czyli na brancha mojej grupy: 

<img width="452" alt="image" src="https://github.com/user-attachments/assets/e166bbd6-e8d8-459c-a0ac-1f8cd27a860e" />

Następnie utworzyłem brancha z moimi inicjałami czyli MM414332:

 <img width="408" alt="image" src="https://github.com/user-attachments/assets/ee5ce9ee-dd3e-4a49-8e7b-a1aeb6ebf5e1" />


Następnym krokiem, który wykonałem było utworzenie katalogu z moimi inicjałami. Po utworzeniu napisałem skrypt, weryfikujący, że każdy mój commit message musi zaczynać się od moich inicjałów:  

<img width="385" alt="image" src="https://github.com/user-attachments/assets/818528dd-3a71-4b84-b241-4e9f6ded2001" />

 
Jego treść:

<img width="398" alt="image" src="https://github.com/user-attachments/assets/ff2f8d1a-bd48-4ec0-b094-2012af960a99" />

Jak widać na załączonym obrazku skrypt działa poprawnie: 

 <img width="457" alt="image" src="https://github.com/user-attachments/assets/ae3931a6-d25c-4fb8-abc6-3feac1263b15" />


Po wykonaniu poleceń utworzyłem plik sprawozdanie.md, gdzie streściłem wykonane kroki. Następnie dodałem plik do repo, zrobiłem commit i wypushowałem:

<img width="473" alt="image" src="https://github.com/user-attachments/assets/9a052802-3846-4b50-825a-3adcbd8a2e52" />

 


Laboratorium 2
W pierwszym kroku drugiej instrukcji pobrałem repozytorium z oficjalnej dokumantecji Dockera:

<img width="459" alt="image" src="https://github.com/user-attachments/assets/80f35690-4870-46b4-915a-69d52a26e84d" />

Następnie zainstalowałem pakiety Dockera:
 
<img width="482" alt="image" src="https://github.com/user-attachments/assets/fd507216-540e-4efd-b4ba-c5c966a67a5b" />

Przetestowałem zainstalowanego Dockera:

<img width="439" alt="image" src="https://github.com/user-attachments/assets/5e1c9606-f616-4a84-91e8-2c85f219065b" />

Następnie pobrałem podane w instrukcji obrazy:

<img width="319" alt="image" src="https://github.com/user-attachments/assets/5d7ff2a0-4851-4036-9fec-4c6191ea7f03" />

Uruchomiłem oraz przetestowałem frazą „Hello” obraz Busybox:

<img width="453" alt="image" src="https://github.com/user-attachments/assets/090c97eb-0ea7-4598-a209-44c5135c411a" />

Obraz uruchomiony interaktywnie oraz wywołana w nim wersja obrazu:
 
<img width="429" alt="image" src="https://github.com/user-attachments/assets/74b2f98b-1807-4b6f-93aa-945500da0591" />

Uruchomiony kontener ubuntu oraz PID 1:
 
<img width="351" alt="image" src="https://github.com/user-attachments/assets/97569124-6647-4000-a106-c29c46d671e4" />

Procesy dockera na hoście:

 <img width="501" alt="image" src="https://github.com/user-attachments/assets/9ea625db-66dd-4ced-8669-e86e3bc84f99" />

Zaktualizowałem pakiety:

<img width="478" alt="image" src="https://github.com/user-attachments/assets/1d5129b9-7bc5-4d59-bcc2-e1b056e75f88" />

Stworzyłem nowy Dockerfile:

 <img width="487" alt="image" src="https://github.com/user-attachments/assets/e2e629eb-9833-45e9-b7a5-7852f7aa2e01" />

Zbudowałem obraz:

<img width="452" alt="image" src="https://github.com/user-attachments/assets/b04c5775-3a4f-4fea-873a-a99335ee9b1e" />

Następnie uruchomiłem kontener interaktywnie:

 <img width="377" alt="image" src="https://github.com/user-attachments/assets/bf6317ca-6a91-465f-9e1f-2dc73d20965d" />

Wyświetliłem  kontenery:
 
<img width="496" alt="image" src="https://github.com/user-attachments/assets/0dddbce0-930a-4ab1-a907-6273e440f9fe" />

Usunąłem wszystkie niedziałające kontenery:
 
<img width="428" alt="image" src="https://github.com/user-attachments/assets/1a52688a-b7e2-4322-b47a-61db2b6d7aa2" />

Oraz obrazy:

<img width="452" alt="image" src="https://github.com/user-attachments/assets/ef34fad6-73ea-43f0-9ce3-42d070ff0fb5" />


Laboratorium 3
Pracę rozpocząłem od sklonowania wybranego repozytorium, zainstalowałem npm:
 
<img width="452" alt="image" src="https://github.com/user-attachments/assets/ea66dd27-2ccb-4e03-88e2-aae11450e7b2" />

Następnie skompilowałem kod TypeScript Do JS:
 
<img width="452" alt="image" src="https://github.com/user-attachments/assets/78a228e7-b87c-4504-ad54-a59bfff53629" />

Uruchomiłem testy i otrzymałem pozytywny rezultat:
 
<img width="452" alt="image" src="https://github.com/user-attachments/assets/4e9e4fd3-de0a-4169-9e4d-e2be050cb85a" />

W następnym kroku stworzyłem dwa pliki Dockerfile – jeden builduje, drugi testuje:
 
 <img width="452" alt="image" src="https://github.com/user-attachments/assets/5f013c3f-dd86-4a8e-8c2d-7a7506207c7c" />

<img width="452" alt="image" src="https://github.com/user-attachments/assets/fb6f19c9-5385-43f1-a948-f6969b43a421" />

Zbudowałem pierwszego z nich i otrzymałem następujące rezultaty:
 
<img width="452" alt="image" src="https://github.com/user-attachments/assets/90acc415-6319-4c19-9486-329dcb7c3253" />

Następnie zbuildowałem Dockerfile odpowiedzialnego za testy:

 <img width="452" alt="image" src="https://github.com/user-attachments/assets/9c92ba83-6a77-414c-b9b3-456d4f520e9f" />

Uruchomiłem kontener testowy i testy zostały przeprowadzone:

 <img width="452" alt="image" src="https://github.com/user-attachments/assets/55d5a7f8-d374-488b-ba4e-5c6d48d56a1c" />

Podsumowując do sprawozdania przygotowałem dwa pliki Dockerfile. Pierwszy odpowiada za cały proces do momentu zbudowania aplikacji – pobiera repozytorium, instaluje zależności i uruchamia build. Drugi obraz bazuje na tym pierwszym i służy tylko do uruchamiania testów, bez ponownego budowania projektu.
Kontenery zostały uruchomione lokalnie i wszystko działa poprawnie – testy przechodzą. Obraz to tylko wzorzec, a właściwa praca (build i test) odbywa się w działającym kontenerze.
W zakresie rozszerzonym utworzyłem plik docker-compose, by wykonać powyższe czynności w jednym poleceniu:

 <img width="393" alt="image" src="https://github.com/user-attachments/assets/4a13371a-1e9c-4d50-94ad-c559d75ad4a9" />

Jak widać jednym poleceniem uruchomiłem dwa pliki naraz:
 
<img width="452" alt="image" src="https://github.com/user-attachments/assets/b4d4b046-abee-4732-aeac-462755e476a2" />

Dyskusja do sprawozdania:
Ten projekt nie jest gotową aplikacją do uruchomienia, więc nie ma sensu publikować go jako kontener. Kontenery są tu przydatne tylko do budowania i testowania.
Gdyby projekt miał być publikowany jako kontener, trzeba by go najpierw oczyścić z niepotrzebnych plików. Można też przygotować osobny Dockerfile tylko do wdrożenia.
Lepszym rozwiązaniem byłoby wypuszczenie gotowej paczki, np. jako biblioteka na npm. Można to zrobić w dodatkowym kroku, np. w osobnym kontenerze.


Laboratorium 4.
Pierwszym krokiem, który wykonałem jest utworzenie dwóch woluminów:
 
<img width="452" alt="image" src="https://github.com/user-attachments/assets/e06a629b-cb81-471f-935b-2133e5927ecf" />

Następnie uruchomiłem kontener z Node I podłączyłem woluminy:
 
<img width="452" alt="image" src="https://github.com/user-attachments/assets/9f590e46-f7e2-4858-b5a4-d936c3a027f5" />

Sklonowanie repozytorium zostało wykonane wewnątrz kontenera na zamontowany wolumin vol_input:
 
<img width="452" alt="image" src="https://github.com/user-attachments/assets/d6cf973e-92bb-4989-9766-273fd38ce740" />

Zainstalowałem npm oraz uruchomiłem builda:
 
 <img width="452" alt="image" src="https://github.com/user-attachments/assets/7467cd89-6379-444e-91bc-6c63f1b14374" />

 <img width="452" alt="image" src="https://github.com/user-attachments/assets/d9bdcc76-e8d7-4682-bc2c-b3f7487c61d7" />

Przeprowadziłem build I skopiowałem pliki do katalogu wyjściowego:
 
<img width="411" alt="image" src="https://github.com/user-attachments/assets/cbfb4d46-e06d-4a04-b9a4-0c009e30ae31" />

Posłużyłem się alpine do wyświetlenia zawartościu woluminu wyjściowego jako /data. Po zakończeniu alpine zostało usunięte:
 
<img width="459" alt="image" src="https://github.com/user-attachments/assets/f95126e5-328a-4edb-9d27-9dd1151f8519" />

Z racji, że w początkowych krokach od razu sklonowałem repozytorium do woluminu teraz wykonam scenariusz pierwotny.
Usunąłem woluminy oraz skopiowałem repo na pomocniczy wolumin alpine:
 
<img width="441" alt="image" src="https://github.com/user-attachments/assets/551ccadf-807c-470b-b9c4-9228945c830f" />

Uruchomiłem kontener interaktywnie:

 <img width="383" alt="image" src="https://github.com/user-attachments/assets/c8220b81-5b77-4949-88fc-4e8e4c0b9a87" />

Wewnątrz kontenera uruchomiłem builda I skopiowałem wyniki do folderu output:
 
<img width="411" alt="image" src="https://github.com/user-attachments/assets/77b21760-5b48-4717-820b-228603e99ad8" />

Wyniki zostały zapisane na woluminie:
 
<img width="433" alt="image" src="https://github.com/user-attachments/assets/5dbf6acb-1475-4ce5-bc74-2249d5ce64bc" />

Uruchomiłem wewnątrz kontenera iperf:
 
<img width="442" alt="image" src="https://github.com/user-attachments/assets/a474fb25-810e-49cb-811d-c0a7e1324bad" />

Sprawdziłem adres hosta:
 
<img width="386" alt="image" src="https://github.com/user-attachments/assets/1e43d59d-d057-4a53-bacc-d49ffa0614b8" />

Poprzez sieć my-net połączyłem się z serwerem iperf3 oraz wykonałem test z interaktywnego kontenera:
 
<img width="428" alt="image" src="https://github.com/user-attachments/assets/1bc9bde9-ad94-4418-8d55-97cbbb4cd160" />

Następnie połączyłem się z serwerem poprzez adres hosta:

 <img width="469" alt="image" src="https://github.com/user-attachments/assets/7edba4c8-c54c-411f-ac4e-cf920ab12890" />

Jak widać na załączonych obrazkach transfer osiągnął lepsze wyniki dla dedykowanie utworzonej sieci niż poprzez połączenie po adresie. 

Utworzyłem sieć do połączenia Jenkins – DIND. Następnie uruchomiłem pomocniczy kontener DIND:

 <img width="450" alt="image" src="https://github.com/user-attachments/assets/a426ab88-e507-494a-a655-a1a896e87218" />

Uruchomiłem kontener z Jenkinsem:
 
<img width="400" alt="image" src="https://github.com/user-attachments/assets/90f7bf42-ecae-43e6-9032-995a3cb064c7" />

W ostatnim kroku połączyłem się z Jenkinsem:
 
<img width="384" alt="image" src="https://github.com/user-attachments/assets/8f18b190-ac2a-49da-bb66-c3e9485925f2" />

Zalogowałem się:
 
 <img width="423" alt="image" src="https://github.com/user-attachments/assets/58f4c940-3d5d-4328-a34b-24469a9331b4" />

<img width="452" alt="image" src="https://github.com/user-attachments/assets/0130f743-5cf5-4666-acc6-7d0123796e4d" />






