#LAB1
1. Zainstalowanie klienta git i obsługi kluczy SSH
   Pracę rozpoczęto od instalacji klienta git i obsługi kluczy ssh
![image](https://github.com/user-attachments/assets/ff4fa743-ec04-48eb-a77d-9bc8bf06084c)
3. Sklonowanie repozytorium przedmiotowego za pomocą HTTPS i personal access token
   Wygenerowano personal access token na platformie github w odpowiedniej sekcji, skopiowano link z protokołem HTTPS do repozytorium i sklonowano przedstawioną na zrzucie ekranu komendą.
![image](https://github.com/user-attachments/assets/c9151217-9d85-49fe-9d12-05e2f1e22f98)
4. Generacja kluczy SSH
   Wygenerowano 2 klucze SSH: Windows PC i SSH_password, z których jeden został zabezpieczomny hasłem.
![image](https://github.com/user-attachments/assets/3b3a2551-3743-4ade-a959-180eb4037b27)
   Skopiowano zawartość pliku wcześniej wygenerowanego klucza publicznego SSH i następnie wklejono na platformie Github, umożliwiając w ten sposób klonowanie repozytoriów bez potrzeby każdorazowego podawania hasła.
![image](https://github.com/user-attachments/assets/882f6d41-51d9-4ba2-a7f9-07abf03519a4)
![image](https://github.com/user-attachments/assets/6cdc2cff-5de2-4078-b1b0-faa478ea8ee1)
![image](https://github.com/user-attachments/assets/e87ecc54-8bb5-4ca8-a7f0-adceac1b2c17)
![image](https://github.com/user-attachments/assets/2c88ed5a-2293-480e-bfc3-8c2f5853df53)
   Zapewniono uwierzytelnianie dwuskładnikowe2FA (autentykacja dwuetapowa) za pomocą aplikacji na telefon, takiej jak Google Authenticator. Dzięki temu po podaniu hasła jest również konieczność podania jednorazowego kodu generowanego przez aplikację na telefonie, co zwiększa bezpieczeństwo konta.
![image](https://github.com/user-attachments/assets/2db07c9f-c24e-44d2-91ad-6b2633563ebe)
5. Przełączenie na gałęzie.
   Przełączono się na gałąź main, a następnie na gałąź swojej grupy - MDO2025_INO.
![image](https://github.com/user-attachments/assets/eaf8f1bb-21e3-4e36-8cfa-1269c997fdab)
   Utworzono w tym miejscu gałąź o nazwie NI409877 (inicjały i nr indeksu), a niej katalog o tej samej nazwie.
![image](https://github.com/user-attachments/assets/494b18fd-cf9a-4707-8fee-b3d58e9e4f66)
6. Git hook
   Napisano Git hooka - skrypt weryfikujący, że każdy mój "commit message" zaczyna się od NI409877 i dodano go utworzonego katalogu.
![image](https://github.com/user-attachments/assets/406e9c78-006f-494e-bfbf-e0f0343b4c69)
7. Wypchnięcie zmian na githuba
   Gotowe pliki najpierw dodano za pomocą add do staging area, a następnie za pomocą commit zatwierdozno zmiany do lokalnej historii repozytorium. Za pomocą git push origin wypchnięto zmiany na githuba.
![image](https://github.com/user-attachments/assets/e9bdf424-9edb-45bc-ba1c-82f4d06f5661)
![image](https://github.com/user-attachments/assets/1b691d73-cd4f-4bb7-8281-d19d285ca245)


#LAB 2
1. Instalacja Dockera
   Zainstalowano Dockera w systemie linuksowym i zarejestrowano się w DockerHub.
2. Pobranie obrazów
   Obrazy Docker to szablony zawierające wszystkie niezbędne pliki, zależności i konfiguracje potrzebne do uruchomienia aplikacji lub systemu operacyjnego w kontenerze. Pobrano obrazy hello-world, busybox, ubuntu, fedora i mysql.
![image](https://github.com/user-attachments/assets/5325afdb-94a4-479d-bf94-d4fed6ef688d)
3. Uruchomienie kontenera z obrazu busybox
   Kontener to lekkie, izolowane środowisko, które uruchamia aplikację wraz ze wszystkimi jej zależnościami, bez potrzeby instalowania ich bezpośrednio na systemie operacyjnym gospodarza.
   Podłączono się do kontenera busybox, uruchomiono go interaktywnie i pokazano nr wersji.
![image](https://github.com/user-attachments/assets/9120cad9-e396-4dab-88d0-cc05a125f2b6)
![image](https://github.com/user-attachments/assets/ff3297a3-7773-4bc3-bf31-389ecbbdaf89)
4. Uruchomienie kontenera ubuntu
   Uruchomiono kontener z obrazu ubuntu, gdzie zaprezentowano PID1 i procesy dockera.
![image](https://github.com/user-attachments/assets/2fbc8e68-5111-4044-9a94-35edbb99eaab)
5. Dockerfile
   Dockerfile to plik tekstowy zawierający instrukcje do automatycznego tworzenia obrazu Docker, definiujący jego konfigurację, zależności i sposób uruchamiania aplikacji.
   Stworzono nowy plik DOckerfile i zbudowano nowy obraz za pomocą build.
![image](https://github.com/user-attachments/assets/cc148f12-219f-41be-87a2-c3942f7e8655)
6. Czyszczenie
   Pokazano działające kontenery i obrazy, a następnie wyczyszczono je
![image](https://github.com/user-attachments/assets/751b5b3e-5647-408a-8ead-cc87ea87aab3)
![image](https://github.com/user-attachments/assets/c110706f-5e5f-408d-87a2-1098cc72bf0c)


#LAB3
1. Do wykonania ćwiczenia wykorzystano 2 podane przez prowadzącego oprogramowania: irssi i node.js. Irssi to klient IRC działający w terminalu, który pozwala na komunikację w różnych sieciach IRC w systemach Unix/Linux. Jest ceniony za swoją prostotę, rozszerzalność i niskie zużycie zasobów.
Node.js to środowisko uruchomieniowe dla JavaScript, które umożliwia uruchamianie aplikacji serwerowych i umożliwia programowanie po stronie serwera za pomocą JavaScriptu. Jest szeroko używane w tworzeniu nowoczesnych aplikacji webowych i usług internetowych.
Sklonowano repozytorium irssi.
![image](https://github.com/user-attachments/assets/6af57fce-520c-4127-ab15-9bf3bc3b69db)
Następnie wymagane było doinstalowanie wymaganych zależności.
![image](https://github.com/user-attachments/assets/03d1617b-00d0-4963-a1ca-09f1e45b9eb1)
W przypadku Irssi, proces instalacji obejmuje użycie odpowiednich narzędzi, takich jak Meson i Ninja, które są używane do budowy i kompilacji oprogramowania.
Meson to nowoczesne narzędzie do budowania oprogramowania, które jest łatwe w użyciu i szybkie, zapewniając konfigurację i kompilację projektów w sposób bardziej elastyczny niż tradycyjne systemy jak Makefile. Ninja to z kolei narzędzie do samej kompilacji, które współpracuje z Mesonem, przyspieszając proces budowania, dzięki swojej prostocie i szybkości działania.
![image](https://github.com/user-attachments/assets/fd3903f9-c880-4a8e-84fd-aa8d0b7f7e62)
Powyższy zrzut obrazuje, że poprawnie pobrano zarówno Mesona jak i Ninje. Po doinstalowaniu kilku niezbędnych bibliotek przeprowadzono build programu.
![image](https://github.com/user-attachments/assets/ce1ca8b0-2f67-468e-b838-bf7932f944a4)
![image](https://github.com/user-attachments/assets/2f1b117b-27ed-461a-bb76-f071693700bd)
Następnie przeprowadzono testy jednostkowe.
![image](https://github.com/user-attachments/assets/c61c3f2e-ee7c-4f8a-867b-f67d6a530566)

Wszystkie powyższe kroki przeprowadzono także dla oprogramowania Node.js.
![image](https://github.com/user-attachments/assets/737966fa-07b7-4506-9412-139ab5313ef6)
![image](https://github.com/user-attachments/assets/f14c4771-e7a6-4e88-827e-e20b39bac5ee)
Aby przeprowadzić build w projekcie Node.js, przede wszystkim potrzebujemy Node.js i npm (Node Package Manager), które są używane do zarządzania zależnościami i uruchamiania skryptów.
![image](https://github.com/user-attachments/assets/b50e23d2-63b7-469b-aa85-6aefd9ebd792)
![image](https://github.com/user-attachments/assets/208fd169-0525-499f-94dc-e8a207d43818)

2. Przeprowadzenie buildu w kontenerze
   Wykorzystano kontener ubuntu i uruchomiono go. Następnie sklonowano w nim repozytorium irssi.
   ![image](https://github.com/user-attachments/assets/b53543e8-1409-4ffc-a97e-ba8e4c815de3)
Po doinstalowaniu wymaganych zależności przeprowadzono build programu.
![image](https://github.com/user-attachments/assets/8faba540-28b4-4fb7-aaf9-d3c949289f46)
![image](https://github.com/user-attachments/assets/76984cae-962e-4f05-9e06-40a013e388ce)
Na koniec przeprowadzono testy.
![image](https://github.com/user-attachments/assets/302869b7-d172-4775-92d0-6036b7ba5ec4)

3. Dockerfile
Stworzono dwa pliki Dockerfile automatyzujące kroki pozwyżej.
Dockerfile.builder -  jest używany do stworzenia obrazu, który przeprowadza cały proces przygotowania aplikacji, w tym instalację zależności i budowanie projektu. Po sklonowaniu repozytorium, kontener stworzony na bazie tego obrazu instaluje wszystkie wymagane pakiety i uruchamia proces kompilacji, tworząc gotowy obraz aplikacji.
![image](https://github.com/user-attachments/assets/280aae0c-b726-4fe5-b506-9741276c2de1)

Dockerfile.tester - bazuje na obrazie stworzonym w pierwszym pliku, ale nie wykonuje procesu budowania. Jego zadaniem jest uruchomienie testów jednostkowych, które są już zdefiniowane w repozytorium aplikacji, a następnie wykonanie ich w kontenerze. Dzięki temu, kontener ten sprawdza, czy aplikacja działa poprawnie, nie przeprowadzając ponownie kompilacji.
![image](https://github.com/user-attachments/assets/0c70e662-b68a-4c9e-8aaf-4dfecc77ae1f)

Zbudowano nowe obrazy na podstawie powyższych plików.
![image](https://github.com/user-attachments/assets/8d35c983-7758-4ba1-b84e-51f08d159797)

Po wejściu do kontenera automatycznie testy zaczynają się wykonywać.
![image](https://github.com/user-attachments/assets/e96289ff-09e4-4136-b033-06ec37ed34ae)
![image](https://github.com/user-attachments/assets/17fdb1d3-eeb0-4802-b881-3b1b5f7c8dcc)


#LAB4
Do zadania wykorzystano repozytorium irssi podobnie jak na poprzednich laboratoriach.
1. Woluminy
Woluminy (volumes) to sposób przechowywania danych, które powinny być dostępne i trwałe, nawet po wyłączeniu kontenera.
Bind mounts pozwalają na podpięcie lokalnych katalogów z systemu plików do kontenera.
Można także używać mountów w Dockerfile do łączenia woluminów z kontenerem podczas procesu budowania.

Najpierw upewniono się, że Docekr jest zainstalowany i działa. Ponadto dodano użytkownika do grupy Docker, aby nie musieć ciągle używać sudo.
![image](https://github.com/user-attachments/assets/25d8e62b-e267-43e9-958a-3577e1bf309b)

Utworzono woluminy wejściowy i wyjściowy.
![image](https://github.com/user-attachments/assets/a65ef067-9487-4e57-bf03-a49f05ceeabc)

Uruchomiono kontener z zamontowanymi woluminami i doinstalowano wymagane zależności.
![image](https://github.com/user-attachments/assets/03f6ac83-9a8b-4a08-a35d-e2dfad9eaa3b)
![image](https://github.com/user-attachments/assets/0fbee904-5f1c-47d6-a733-b3fc8198db37)

Poza kontenerem sklonowano repozytorium.
![image](https://github.com/user-attachments/assets/af507f68-3c00-4f07-b545-db255e996afc)

Sklonowano repozytorium na wolumin wejściowy za pomocą kopiowania do katalogu z woluminem na hoście. Następnie przeprowadzono build w kontenerze.
![image](https://github.com/user-attachments/assets/2f631daa-62c5-46fb-bdbd-12e8c8ba6a07)
![image](https://github.com/user-attachments/assets/55d69aec-448a-458b-877f-da5e0239cd7f)

Powstałe pliki zapisano na woluminie wyjściowym tak, aby były dostępne po wyłączeniu kontenera.
![image](https://github.com/user-attachments/assets/112e818b-9d63-4fa3-ae2a-22958c57c74e)

Następnie przeprowadzono wyżej wymienione czynności za pomocą gita w kontenerze.
![image](https://github.com/user-attachments/assets/29b602ff-d5c6-4f92-bc91-fd66d9cacce1)
![image](https://github.com/user-attachments/assets/2dc43f32-d248-418a-9ad6-9c8b9a4b497b)
![image](https://github.com/user-attachments/assets/0004fe84-4d7e-4fd9-93ac-17afd4018f28)


2. Eksponowanie portu
   Wewnątrz kontenera uruchomiono serwer iperf3 i doinstalowano wymagane zależności.
![image](https://github.com/user-attachments/assets/61ba9da9-45ba-4b22-b8d5-5300aec67c69)

Sprawdzono adres ip iperf_server, aby móc się z nim połączyć za pomocą drugiego kontenera.
![image](https://github.com/user-attachments/assets/e08c5607-7372-48b2-9846-ca81d2eb17b9)

Następnie na serwerze iperf_client połączono się  z serwerem iperf_server.
![image](https://github.com/user-attachments/assets/52e34cfe-eb33-434e-b944-d6243f466bff)
![image](https://github.com/user-attachments/assets/5e187c2c-f34a-46b3-a0c0-b2f485e840be)

Następnym krokiem było utworzenie dedykowanej sieci mostkowej i za jej pomocą połączenie się z kontenera klienta z kontenerem serwera, nie używając tym razem adresu IP tylko nazwy serwera.
![image](https://github.com/user-attachments/assets/8fbecdb1-dff5-4f8c-9a07-69a21bf2e481)
![image](https://github.com/user-attachments/assets/61ff47b3-6c21-467d-9ebd-1864fb4669ef)
![image](https://github.com/user-attachments/assets/052a332b-98ba-408b-8bc1-d46d761b55bb)


3. Jenkins
   Jenkins to narzędzie do automatyzacji procesów CI/CD (Continuous Integration/Continuous Deployment), które umożliwia budowanie, testowanie i wdrażanie oprogramowania w sposób zautomatyzowany. Instalacja Jenkinsa w kontenerze Docker, wraz z DIND (Docker-in-Docker), pozwala na zarządzanie i uruchamianie kontenerów w ramach pipeline’ów, co jest przydatne w automatyzacji testów i wdrożeń aplikacji w środowisku chmurowym lub lokalnym.
   Ostatnim krokiem była instalacja Jenkinsa. W tym celu utworzono osobną sieć Docker o nazwie "jenkins_network" dla Jenkinsa. Następnie przeprowadzono instalację skonteneryzowanej instancji Jenkinsa z pomocnikiem DIND.
   ![image](https://github.com/user-attachments/assets/4eaf4660-8d21-4ea6-ac1a-c52d846db7de)
Za pomocą poniższej komendy uzyskano hasło do Jenkinsa.
![image](https://github.com/user-attachments/assets/94b3e70c-e3a3-4d95-b7a3-68b01d463010)

Finalnie zalogowano się do Jenkinsa.
![image](https://github.com/user-attachments/assets/b6c01dda-2637-4bbf-a8d0-8a8aaed76b06)
![image](https://github.com/user-attachments/assets/d4029651-db93-4af5-a718-08dd8e84134b)
