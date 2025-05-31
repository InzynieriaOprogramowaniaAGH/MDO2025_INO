## Zajęcia 7


# Ansible instalacja

Tworzymy nową maszynę wirtualną, w tym wypadku także system Fedora 41.

Nadajemy nazwę komputera.
![ansible](lab7/screenshots/1.png)

Następnie nadajemy nazwę i hasło użytkownika.
![ansible](lab7/screenshots/2.png)

Następnie logujemy się na zainstalowany system.
![ansible](lab7/screenshots/3.png)

Instalujemy tar, oraz upewniamy się czy serwer ssh jest zainstalowany.
![ansible](lab7/screenshots/4.png)

Następnie należy stworzyć checkpoint naszej maszyny.
![ansible](lab7/screenshots/5.png)

Na głównej maszynie instalujemy ansible.
![ansible](lab7/screenshots/6.png)

Upewniamy sie czy instalacja przebiegła pomyślnie.
![ansible](lab7/screenshots/7.png)

Opcjonalnym krokiem jest dodanie serwera i klienta do urządzeń zaufanych w ssh.
![ansible](lab7/screenshots/8.png)

Sprawdzamy połączenie.
![ansible](lab7/screenshots/9.png)

Dla lepszej widoczności ustawiamy nazwy obydwu maszyn.
![ansible](lab7/screenshots/10.png)
![ansible](lab7/screenshots/11.png)

Kolejnym opcjonalnym krokiem jest ustawienie aliasów dla adresów IP, co będzie działało tak samo jak serwer DNS.
![ansible](lab7/screenshots/12.png)
![ansible](lab7/screenshots/13.png)

Testujemy nowy sposób łączenia się.
![ansible](lab7/screenshots/14.png)
![ansible](lab7/screenshots/15.png)

W kolejnym kroku używamy pliku inventory.ini do sprawdzenia połączenia z maszynami w ten sposób.
![ansible](lab7/screenshots/16.png)

Kolejną częścią zadania jest utworzenie pliku playbook1.yaml, odpowiedzialnego za wykonanie ping na maszynach, wysłanie na nie poprzedni plik, wykonanie na wszystkich systemach aktualizacji, oraz restart sshd i rngd.
![ansible](lab7/screenshots/17.png)

Sprawdzamy poprawność pliku.
![ansible](lab7/screenshots/18.png)

Aby sprawdzić zachowanie się maszyny w wypadku problemu, wyłączamy serwer ssh na 2 maszynie.
![ansible](lab7/screenshots/19.png)

Sprawdzamy zachowanie się ansible.
![ansible](lab7/screenshots/20.png)

Tworzymy kolejy plik playbook. Jego zadaniem jest zbudowanie, oraz uruchomienie kontenera z DockerHub, a także połączenie się z nim.
![ansible](lab7/screenshots/21.png)

Testujemy działanie pliku.
![ansible](lab7/screenshots/22.png)


## Zajęcia 8

Nasz plik anaconda-ks.cfg po umieszczeniu w wybranym miejscu na dysku należy przypisać do naszego konta.
![ansible](lab8/screenshots/1.png)

Następnie należy zmodyfikować plik, np. formatowanie całego dysku, zmiana hostname, etc.

Nastepnie tworzymy maszynę, jednak podczas instalacji należy wybrać opcję modyfikacji parametrów jądra. Należy skonfigurowac parametr inst.ks={położenie pliku}.
![ansible](lab8/screenshots/2.png)

Następnie dokonujemy standardowej instalacji.
![ansible](lab8/screenshots/4.png)

Po dokonanej instalacji ukaże się nam system operacyjny.
![ansible](lab8/screenshots/5.png)

Kolejna część zadania polegała na rozszerzeniu możliwości pliku o automatyczne zainstalowanie repozytoriów niezbędnych do uruchomienia pipeline. Całość znajduje się 2 pliku anaconda-ks-2.cfg.

Po uruchomieniu pliku sprawdzamy czy został utwożony kontener z pipeline.
![ansible](lab8/screenshots/6.png)

## Zajęcia 9

Na początku instalujemy minikube.
![ansible](lab9/screenshots/1.png)

Przydatnym narzędziem jest conntrack ułatwiające użytkowanie sieci z minikube.
![ansible](lab9/screenshots/2.png)

Następnie odpalamy minikube.
![ansible](lab9/screenshots/3.png)

Sprawdzamy wynik odpalenia programu.
![ansible](lab9/screenshots/4.png)

Kolejnym krokiem jest odpalenie internetowego dashboardu programu i połączenie się z nim poprzez przeglądarke.
![ansible](lab9/screenshots/5.png)
![ansible](lab9/screenshots/6.png)

Odpalamy następnie naszą aplikację w dockerze.
![ansible](lab9/screenshots/8.png)

Sprawzamy czy działa poprzez przeglądarkę.
![ansible](lab9/screenshots/9.png)

Aby połączyć się z kontenerem, należy przekierować port.
![ansible](lab9/screenshots/10.png)

Następnie sprawdzamy połączenie.
![ansible](lab9/screenshots/11.png)

Kolejnym krokiem jest utworzenie deploymentu, przy pomocy pliku redis-deployment.yaml
![ansible](lab9/screenshots/12.png)

Sprawdzamy status rollout'u aplikacji.
![ansible](lab9/screenshots/13.png)

Następnie eksportujemy port aplikacji w celu korzystanie z niej z zewnątrz.
![ansible](lab9/screenshots/14.png)

Kolejnym krokiem jest przekierowanie aplikacji na odpowiedni port.
![ansible](lab9/screenshots/15.png)

Następnie sprawdzamy połączenie po raz kolejny.
![ansible](lab9/screenshots/16.png)

Te kroki można również zaobserwować na interfejsie przeglądarkowym.
![ansible](lab9/screenshots/17.png)

Deplyments utworzone po wykonaniu tych kroków.
![ansible](lab9/screenshots/18.png)

POdy po wykonaniu tych kroków.
![ansible](lab9/screenshots/19.png)

Kolejnym podpunktem było wytworzenie błędu, w tym celu należy zmodyfikować dockerfile podstawowy, a następnie go zbudować, oraz wyłać go na DockerHub.
![ansible](lab9/screenshots/20.png)
![ansible](lab9/screenshots/21.png)
![ansible](lab9/screenshots/22.png)

Nastepnie sprawdzamy DockerHub, aby upewnić się, że wszystko przebiegło pomyślnie.
![ansible](lab9/screenshots/23.png)

Nastepnym krokiem jest zmienienie ilości replik w deploymencie.
![ansible](lab9/screenshots/23.png)
![ansible](lab9/screenshots/24.png)
![ansible](lab9/screenshots/25.png)
![ansible](lab9/screenshots/26.png)
![ansible](lab9/screenshots/27.png)
![ansible](lab9/screenshots/28.png)

W kolejnym kroku zmieniliśmy wersję programu z 1.0.30, na 1.0.29.

Po zmianie możemy zaobserwować zmianę na witrynie internetowej.
![ansible](lab9/screenshots/29.png)

Sposobem na zaobserwowanie historii deploymentu jest poniższa komenda.
![ansible](lab9/screenshots/30.png)

W kolejnym kroku należało sprawdzić wadliwy deploy programu.
![ansible](lab9/screenshots/31.png)

Jak możemy zaobserwować próby wdrażania wadliwej wersji kończą się niepowodzeniem.
![ansible](lab9/screenshots/32.png)

Sprawdzamy nasze pody, jak można zaobserwować wadliwa wersja deploy'a zwraca błąd.
![ansible](lab9/screenshots/33.png)

Aby naprawić deploy wracamy do poprzedniej wersji programu następującą komendą.
![ansible](lab9/screenshots/34.png)

Po ponownym sprawdzeniu strony widzimy, iż działa na dawnnej wersji.
![ansible](lab9/screenshots/29.png)

Aby uzyskać informację o konkretnym deploy'u możemy użyć następującej funkcji.
![ansible](lab9/screenshots/35.png)

W kolejnym kroku tworzymy plik check-deploy.sh, który sprawdza, czy deploy udał się w przeciągu 60 sekund.
Uruchamiamy go w następujący sposób.
![ansible](lab9/screenshots/36.png)

Ostatnią częscią zadania jest wdrożenie wersji programu w różniący się od siebie sposób.
W tym celu tworzymy kolejny plik yaml, noszący nazwę redis-app-canary.yaml.

Następnie deploy'ujemy go w nasepujący sposób.
![ansible](lab9/screenshots/37.png)

Powstałe deploy'e możemy sprawdzić w przeglądarce.
![ansible](lab9/screenshots/38.png)
