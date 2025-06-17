###Lab 9###
<img width="452" alt="image" src="https://github.com/user-attachments/assets/35dd8c03-e490-4855-b889-76ce504f15c9" />

 
W pierwszym kroku dokonałem utworzenia nowej maszyny wirtualnej według poleceń. Następnie połączyłem się z nią z głównej maszyny. 
<img width="452" alt="image" src="https://github.com/user-attachments/assets/63d2a34b-502c-4c0f-8080-047a9db2fc65" />

 
Umożliwiłem łączenie się bez podawania hasła 
<img width="452" alt="image" src="https://github.com/user-attachments/assets/ab21dbfa-9bef-47a5-a0cf-b26911c65689" />
<img width="452" alt="image" src="https://github.com/user-attachments/assets/0c37e2c0-8cd9-4358-8ae4-d42ad3da8c9b" />

 
 
Nadałem nazwy hostów
<img width="452" alt="image" src="https://github.com/user-attachments/assets/80cba197-60c3-4f5b-b3e2-a2ebaf8e2408" />
<img width="319" alt="image" src="https://github.com/user-attachments/assets/642bccd0-8c75-4e5a-85d2-7f70bdb59041" />

 
 
Dodałem adresy do etc/hosts na obu maszynach 
<img width="452" alt="image" src="https://github.com/user-attachments/assets/4d06bcfe-46a8-4820-b804-4adeec17ada9" />

 
Utworzyłem plik inventory.ini
<img width="452" alt="image" src="https://github.com/user-attachments/assets/1a3dc605-8e6a-4cf5-83ba-18754382599d" />

 
Przetestowałem połączenie 
<img width="452" alt="image" src="https://github.com/user-attachments/assets/d92122b7-cc06-4b5e-ba63-e7b69f476f87" />

 
Utworzyłem playbook 
<img width="452" alt="image" src="https://github.com/user-attachments/assets/a69a1d48-8e8b-4f9f-8788-3316ad457966" />

 
Uruchomiłem go. Wystąpił błąd z rngd ale został zignorowany przez system
<img width="452" alt="image" src="https://github.com/user-attachments/assets/574b6736-7697-496d-8357-9a1d72d25439" />
<img width="452" alt="image" src="https://github.com/user-attachments/assets/41b407d0-1fdc-465e-af75-9e67c9d57899" />

 
 
W ostatnim kroku ucuhomiłem playbooka z moim artefaktem I został wykonany pomyślnie.










LAB 9
 <img width="452" alt="image" src="https://github.com/user-attachments/assets/5e6426d3-3917-49e2-9b04-4a3b99e077ca" />
<img width="452" alt="image" src="https://github.com/user-attachments/assets/d3dee004-0d31-4b7b-abe0-51140e03459f" />

 
Na początku laboratorium 9 utworzyłem nową maszynę wirtualną Fedora. Utworzyłem użytkownika I ukończyłem instalację. Pobrałem na główną maszynę plik ks.cfg. By to zrobić na nowej maszynie wirtualnej musiałem dodać uprawnienia dla użytkownika.
<img width="452" alt="image" src="https://github.com/user-attachments/assets/f341d10f-9809-4167-8752-001a1da6f5fd" />

 
Edytowałem plik ks.cfg na potrzeby mojej aplikacji 
<img width="452" alt="image" src="https://github.com/user-attachments/assets/10a06e90-a028-40df-b3cb-ef4c56216961" />




 


Po tym jak zedytowałem plik ks.cfg dodając linki do repo fedory, formatując całość dysku komendą: clearpart -all, wywołem mój plik odnosząc się linkiem do repozytorium github uruchomiłem nową maszynę:
 <img width="452" alt="image" src="https://github.com/user-attachments/assets/9b27b7a0-370d-4e18-ba15-ecbc36a17fe4" />
<img width="401" alt="image" src="https://github.com/user-attachments/assets/480ccc08-569c-4418-a493-89983df4cbbf" />


 
Następnie przeszedłem do realizacji planu rozszerzonego.
Przygotowałem rozszerzony plik ks.cfg:  
<img width="452" alt="image" src="https://github.com/user-attachments/assets/57bf1d8e-29fe-4bf5-b1bd-b3edafe22936" />
<img width="452" alt="image" src="https://github.com/user-attachments/assets/9d80fdba-dbfc-4c97-9af2-11dc7f262a3b" />

 
Instalacja systemu Fedora została przeprowadzona w sposób nienadzorowany z wykorzystaniem mechanizmu Kickstart. Przygotowany plik ks.cfg zawierał wszystkie niezbędne dyrektywy do automatycznego skonfigurowania systemu: ustawienia języka (pl_PL.UTF-8), klawiatury (pl), sieci (DHCP z nazwą hosta fedora-mat.local), utworzenia użytkownika mmatyja z uprawnieniami administratora, automatycznego partycjonowania dysku oraz wyboru pakietów serwerowych i narzędzi deweloperskich (takich jak git, gcc, make, wget). Dodatkowo w sekcji %post zawarto skrypt klonujący repozytorium projektu xz, budujący go i tworzący usługę systemd, która kompresuje testowy plik przy starcie systemu. Plik Kickstart został udostępniony z lokalnego serwera HTTP (uruchomionego na Macu za pomocą python3 -m http.server), a jego adres został podany instalatorowi Fedory poprzez parametr inst.ks=... w edytorze GRUB. Dzięki temu cała instalacja przebiegła automatycznie i zakończyła się uruchomieniem w pełni gotowego do pracy systemu.


Lab 10
 <img width="452" alt="image" src="https://github.com/user-attachments/assets/ceffeb7e-4869-415e-bf97-e069d81db680" />

W pierwszym kroku zainstalowałem minikube

 <img width="452" alt="image" src="https://github.com/user-attachments/assets/8a7147ff-a48a-4720-bd90-7f62b63197ed" />

Następnie nadałem sobie uprawnienia I uruchomiłem
 <img width="452" alt="image" src="https://github.com/user-attachments/assets/9e8b5729-4fbb-440d-9dfd-dc83a1a2c9fa" />
<img width="452" alt="image" src="https://github.com/user-attachments/assets/e619b798-e75f-4558-9622-c0ecba5f7da2" />

 
Do tej pory w ramach pracy z Kubernetes wykonałem podstawową konfigurację i uruchomienie środowiska lokalnego za pomocą Minikube na Ubuntu z architekturą ARM. Zainstalowałem klaster Kubernetes i uruchomiłem go z wykorzystaniem drivera Docker. Następnie wdrożyłem aplikację nginx w postaci kontenera, który został automatycznie osadzony w Podzie. Za pomocą kubectl potwierdziłem, że Pod działa, a następnie wystawiłem usługę (Service), dzięki której mogłem uzyskać dostęp do nginx z przeglądarki i zweryfikować działanie aplikacji. Tym samym zrealizowałem pierwszy etap pracy z Kubernetes — wdrożenie, uruchomienie i ekspozycję aplikacji w kontenerze.

 <img width="452" alt="image" src="https://github.com/user-attachments/assets/fc78ee6b-0301-42ff-b555-cf2f22d059aa" />

Utworzyłem wdrożeniowy plik yaml
 <img width="452" alt="image" src="https://github.com/user-attachments/assets/4060a12a-1d56-45b4-8083-aed0f33250d3" />

Uruchomiłem klaster Kubernetes z użyciem Minikube na systemie ARM. Stworzyłem deployment z obrazem nginx, a następnie wystawiłem go jako serwis typu NodePort. Zweryfikowałem działanie aplikacji poprzez curl oraz uzyskany URL. Aplikacja poprawnie odpowiada, co potwierdza, że kontener działa w podzie.
 <img width="452" alt="image" src="https://github.com/user-attachments/assets/11cc9bfe-bafd-4c18-a3a4-fecbf70c99d0" />
<img width="452" alt="image" src="https://github.com/user-attachments/assets/b93b4446-8d26-4402-b37f-78680a77bf51" />

 
W ramach zadania uruchomiłem lokalny klaster Kubernetes za pomocą Minikube z wykorzystaniem drivera Docker. Następnie wdrożyłem aplikację nginx jako kontener, tworząc Deployment z czterema replikami. Eksponowałem aplikację przy użyciu serwisu NodePort, co umożliwiło zewnętrzny dostęp do jej funkcjonalności przez przeglądarkę i curl. Deployment został zapisany jako plik YAML, umożliwiając ponowne odtworzenie środowiska w sposób deklaratywny.
<img width="171" alt="image" src="https://github.com/user-attachments/assets/9f343453-b0d7-4871-ab65-9e87588cfd4d" />

 
 
Wdrożenie serwisu zostało zapisane w pliku YAML i zaktualizowane za pomocą kubectl apply


Lab 11
 <img width="437" alt="image" src="https://github.com/user-attachments/assets/095b0a60-c8e4-4c30-89c8-8bfb53b6fd7b" />
<img width="452" alt="image" src="https://github.com/user-attachments/assets/96cff583-fc56-4337-8484-49b59984986f" />

 
Wypushowałem do Dockerhuba dwie wersje obrazu
<img width="452" alt="image" src="https://github.com/user-attachments/assets/9d02d0c1-451f-46c4-aa22-117d1f940d87" />

 
Wypushowałem również wadliwą wersję
<img width="452" alt="image" src="https://github.com/user-attachments/assets/e053f22d-14f5-46b4-9fee-3bf07fb1ff63" />

 
Ustawiłem 8 replik
 <img width="452" alt="image" src="https://github.com/user-attachments/assets/43ab7089-8fa6-4cff-9676-056f7d0496fa" />

Zrestartowałęm deployment i ustawiłem 1 replikę. Następnie zmniejszyłem do 0 i podniosłem do 4 w taki sam sposób. 
 <img width="157" alt="image" src="https://github.com/user-attachments/assets/e172a1dc-c0af-4567-b833-a05c3c06d438" />

Ustawiłem nową wersję, następnie starszą i na końcu wadliwą. 
 <img width="452" alt="image" src="https://github.com/user-attachments/assets/0aa9ff52-1f6b-477a-97fb-f92890f1a20d" />

Widoczne zmiany wersji.

 <img width="452" alt="image" src="https://github.com/user-attachments/assets/de63edc2-9ac5-438a-a4df-446054ef8c5f" />

Napisałem skrypt weryfikujący, czy wdrożenie "zdążyło" się wdrożyć (60 sekund)
 <img width="398" alt="image" src="https://github.com/user-attachments/assets/445019bd-76b3-4c68-b4c9-0edbca90acf5" />


Następnie utworzyłem wersje wdrożeń:
 <img width="161" alt="image" src="https://github.com/user-attachments/assets/f3570b54-a4a4-4ae3-ab20-2c3c04b63c3f" />

Recreate

 <img width="178" alt="image" src="https://github.com/user-attachments/assets/e6e008a6-06ea-4f8e-b732-e53daa8b4b34" />

Rolling update 

 <img width="238" alt="image" src="https://github.com/user-attachments/assets/4e4a57ec-8695-475e-81e2-8209388eb0c1" />

Canary deployment

 <img width="452" alt="image" src="https://github.com/user-attachments/assets/9a6a02a0-27df-467e-af03-778c973b96a4" />
<img width="452" alt="image" src="https://github.com/user-attachments/assets/73ed70b3-6bd6-44e2-a3bb-f28ffb6ee4b0" />

 

Rolling Update pozwala na płynne aktualizacje bez przerwy w działaniu – pody są aktualizowane jeden po drugim.
Recreate zabija stare pody zanim stworzy nowe – w kubectl get pods -w możesz zaobserwować krótki brak dostępnych podów (downtime).
Canary tworzy pojedynczy nowy pod z nową wersją aplikacji – służy do testowania nowej wersji na części użytkowników.

Ogólne wnioski z realizacji zadań (Lab 9–11)
Realizacja ćwiczeń z zakresu automatyzacji wdrożeń oraz orkiestracji kontenerów pozwoliła mi w praktyce poznać i zrozumieć kluczowe narzędzia i procesy wykorzystywane we współczesnych środowiskach DevOps i CI/CD.
W Lab 9 opanowałem technikę instalacji systemu operacyjnego w sposób nienadzorowany z użyciem mechanizmu Kickstart. Dzięki temu zautomatyzowałem cały proces instalacyjny Fedory, w tym konfigurację użytkownika, sieci, partycjonowania, a także wdrożenie własnej aplikacji i jej automatyczne uruchamianie po starcie systemu. Pozwoliło mi to znacząco skrócić czas konfiguracji nowych maszyn i wyeliminować błędy wynikające z manualnych ustawień.
W Lab 10 zdobyłem doświadczenie w konfiguracji środowiska Kubernetes z wykorzystaniem Minikube. Przeprowadziłem pełny cykl wdrożenia aplikacji w kontenerze (nginx), tworząc deployment, service i eksponując aplikację na zewnątrz. Dzięki temu zrozumiałem model działania Kubernetes, w tym sposób zarządzania Podami i replikacją.
W Lab 11 pogłębiłem wiedzę z zakresu zarządzania wersjami aplikacji w Kubernetes. Przećwiczyłem publikację i aktualizację wersji kontenerów, zmianę liczby replik oraz cofanie się do poprzednich wersji. Poznałem trzy strategie wdrażania: Recreate, Rolling Update i Canary Deployment — każda z nich ma zastosowanie w zależności od wymagań dotyczących dostępności aplikacji i ryzyka zmian.

