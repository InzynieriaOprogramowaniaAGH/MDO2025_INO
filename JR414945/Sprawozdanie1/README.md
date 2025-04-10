SPRAWOZDANIE 1

LAB 1

*Utworzenie kluczy SSH i dodanie ich do GitHuba
![image](https://github.com/user-attachments/assets/16bce489-d0c9-4b30-afc2-65a14c01e418)

*Klucze SSH umożliwiły sklonowanie repo i przepchnięcie zmian
![image](https://github.com/user-attachments/assets/de20c429-f61b-485e-80d1-e1521a7db2a5)


LAB 2

*Pobranie dockera na VM i obrazu ubuntu, busybox, mysql(brak screena z tego procesu)

*Włączenie ubuntu w kontenerze 
![image](https://github.com/user-attachments/assets/015f32e8-109d-4419-add8-67a71f483ddd)

*Utworzenie Dockerfile, który tworzy obraz na podstawie Ubuntu, instaluje potrzebne pakiety i klonuje repo (Dockerfile znajduje się w repozytorium)
![image](https://github.com/user-attachments/assets/24635fe6-907d-4402-ae0d-d5c6304859c3)


LAB 3

*Utworzenie katalogu roboczego lab_3 i sklonowanie repo maven-simple
![image](https://github.com/user-attachments/assets/bc4e295b-d822-481c-bbb8-e39393945996)

*Kompilacja programu za pomocą komendy mvn compile
![image](https://github.com/user-attachments/assets/25c5fb0a-63f6-4710-8e29-7a5d92c1ff73)

*Przeprowadzenie testów za pomocą komendy mvn test
![image](https://github.com/user-attachments/assets/b1a22591-0927-49c2-b8e5-9e24168add8f)

*Uruchomienie kontenera ubuntu i sklonowanie repo do niego
![image](https://github.com/user-attachments/assets/f918cf53-b1b0-4165-892a-8199a206c7a3)
![image](https://github.com/user-attachments/assets/e22ceef7-a590-45fe-8ca7-2eb2e75b8e45)

*Kompilowanie programu i przeprowadzanie testów w kontenerze
![image](https://github.com/user-attachments/assets/fc553b3c-ff0a-4a76-aaa4-41be715a5a1c)
![image](https://github.com/user-attachments/assets/5daadabd-1fdc-4f05-a6b3-ee3b88821054)

*Utworzenie pliku Dockerfile.build, który wykonuje wszystkie kroki do kompilacji 
![image](https://github.com/user-attachments/assets/fe3686db-4c96-45eb-9966-949b4ae17b33)
![image](https://github.com/user-attachments/assets/e9a3d627-01a6-4add-a777-a55fb85c8eef)

*Utworzenie Dockerfile.test, ktróy przeprowadza testy
![image](https://github.com/user-attachments/assets/9eb99a77-7fe9-463f-91d4-d105409cd91f)
![image](https://github.com/user-attachments/assets/92769b80-6c5c-44b2-8105-7e2d44fbd989)

*Dowód na poprawnie wykonane zadanie:

![image](https://github.com/user-attachments/assets/d45c5e87-8e7f-450b-913f-e3866f16d343)

W kontenerach widzimy folder target, który świadczy o poprawnej kompilacji


LAB 4

*Utowrzenie katalogu roboczego lab_4, woluminu wyjściowego i wejściowego
![image](https://github.com/user-attachments/assets/bf54fb97-1cfd-4841-955c-9eae207b28b6)

*Podłączenie ich do kontenera
![image](https://github.com/user-attachments/assets/b6a42878-a3bd-4cca-9607-bbbc4abcf98d)

*Napisanie Dockerfile dla kontenera pomocniczego
![image](https://github.com/user-attachments/assets/5ba2fc20-162c-4365-a1e8-5446b654a042)

*Klonowanie do wolumenu wejściowego
![image](https://github.com/user-attachments/assets/3d13e126-7b84-41d6-b392-84f2604e15a0)

*Sprawdzenie poprawności klonowania
![image](https://github.com/user-attachments/assets/97c6e905-2452-43e2-b202-6a6eb500f3b1)

*Zbudowanie aplikacji
![image](https://github.com/user-attachments/assets/94287d60-40cc-4835-b06a-b5155bf50dfd)

*Przeniesienie folderu target do vol_wyj (wolumin wyjściowy)
![image](https://github.com/user-attachments/assets/02ac1052-32c1-4f6a-ba97-73b1ced5d1dc)

*Sprawdzenie, czy pliki znajdują się na woluminie wyjściowym
![image](https://github.com/user-attachments/assets/24e7f77b-2357-48cf-9bd8-5bb5b888b06e)

*Klonowanie repo za pomocą git
![image](https://github.com/user-attachments/assets/fd6b9db4-302a-43a4-86ef-f0ed80430046)

W wersji Dockera 18.09 i wyższych wprowadzono możliwość korzystania z mountów podczas budowania obrazu za pomocą opcji RUN --mount. Używając tej funkcji, można montować wolumeny bez konieczności wstępnego uruchamiania kontenera. Jest to przydatne, gdy chcemy uzyskać dostęp do lokalnych plików systemu plików lub wolumenów podczas budowania obrazu, np. klonowanie repozytoriów bezpośrednio z Dockerfile.

*Utworzenei kontenera iperf3 działającego w tle
![image](https://github.com/user-attachments/assets/924ab087-41bd-49cc-b646-b0470e0acbfe)

*Utworzenie klienta ipref3
![image](https://github.com/user-attachments/assets/6b5281ee-5dd2-45af-8aa2-06e1b9b6221b)

*Tworzenie niestandardowej sieci mostkowej
![image](https://github.com/user-attachments/assets/90d86fd5-5027-4747-85e8-4adc25010dd0)

*Sprawdzenie adresu IP serwera
![image](https://github.com/user-attachments/assets/65e1b8ad-cc40-451b-b39e-2aa47ad37f49)

*Połączenie się z hosta do kontenera, na któym idzie iperf3-server
![image](https://github.com/user-attachments/assets/68413eeb-b5b7-42d5-8a7e-8d9400cd52b8)

Średnia przepustowość wyniosła 19.58 GBit/s

*Uruchomienie DIND
![image](https://github.com/user-attachments/assets/74fa992e-0996-4fd3-9430-d75415573239)

*Uruchomienie Jenkinsa
![image](https://github.com/user-attachments/assets/bd1b6e2c-9826-4e55-9215-c121f45bec84)

*Weryfikacja
![image](https://github.com/user-attachments/assets/8d0f017d-2f0f-4981-8419-25646bcfc4b8)

*Strona logowania Jenkins
![image](https://github.com/user-attachments/assets/2aecfb38-6481-4630-ad1a-7c6e1b5e1893)




















