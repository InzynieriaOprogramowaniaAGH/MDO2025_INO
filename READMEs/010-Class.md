# Zajęcia 10

# Wdrażanie na zarządzalne kontenery: Kubernetes (1)

## Zadania do wykonania
### Instalacja klastra Kubernetes
 * Zaopatrz się w implementację stosu k8s: [minikube](https://minikube.sigs.k8s.io/docs/start/)
 * Przeprowadź instalację, wykaż poziom bezpieczeństwa instalacji
 * Zaopatrz się w polecenie `kubectl` w wariancie minikube, może być alias `minikubctl`, jeżeli masz już "prawdziwy" `kubectl`
 * Uruchom Kubernetes, pokaż działający kontener/worker
 * Zmityguj problemy wynikające z wymagań sprzętowych lub odnieś się do nich (względem dokumentacji)
 * Uruchom Dashboard, otwórz w przeglądarce, przedstaw łączność
 * Zapoznaj się z koncepcjami funkcji wyprowadzanych przez Kubernetesa (*pod*, *deployment* itp)
 
### Analiza posiadanego kontenera
 * Zdefiniuj krok "Deploy" swojego projektu jako "Deploy to cloud":
   * Deploy zbudowanej aplikacji powinien się odbywać "na kontener"
   * Przygotuj obraz Docker ze swoją aplikacją - sprawdź, że Twój kontener Deploy na pewno **pracuje**, a nie natychmiast kończy pracę! 😎
   * Jeżeli wybrana aplikacja nie nadaje się do pracy w kontenerze i nie wyprowadza interfejsu funkcjonalnego przez sieć, wymień projekt na potrzeby tego zadania:
     * Optimum:
       * obraz-gotowiec (czyli po prostu inna aplikacja, np. `nginx`, ale **z dorzuconą własną konfiguracją**)
       * samodzielnie wybrany program i obraz zbudowany na jego bazie, niekoniecznie via *pipeline*
     * Plan max: obraz wygenerowany wskutek pracy *pipeline'u*
   * Wykaż, że wybrana aplikacja pracuje jako kontener
   
### Uruchamianie oprogramowania
 * Uruchom kontener ze swoją aplikacją na stosie k8s
 * Kontener uruchomiony w minikubie zostanie automatycznie "ubrany" w *pod*.
 * ```minikube kubectl run -- <nazwa-jednopodowego-wdrożenia> --image=<obraz-docker> --port=<wyprowadzany port> --labels app=<nazwa-jednopodowego-wdrożenia>```
 * Przedstaw że *pod* działa (via Dashboard oraz `kubectl`)
 * Wyprowadź port celem dotarcia do eksponowanej funkcjonalności
 * ```kubectl port-forward pod/<nazwa-wdrożenia> <LO_PORT>:<PODMAIN_CNTNR_PORT> ```
 * Przedstaw komunikację z eskponowaną funkcjonalnością
 
### Przekucie wdrożenia manualnego w plik wdrożenia (wprowadzenie)
 * Zapisz [wdrożenie](https://kubernetes.io/docs/concepts/workloads/controllers/deployment/) jako plik YML
 * Przeprowadź próbne wdrożenie przykładowego *deploymentu* `nginx`
   * Wykonaj ```kubectl apply``` na pliku
   * Upewnij się, że posiadasz wdrożenie zapisane jako plik
   * Wzbogać swój obraz o 4 repliki
   * Rozpocznij wdrożenie za pomocą ```kubectl apply```
   * Zbadaj stan za pomocą ```kubectl rollout status```
 * Wyeksponuj wdrożenie jako serwis
 * Przekieruj port do serwisu (tak, jak powyżej)  
