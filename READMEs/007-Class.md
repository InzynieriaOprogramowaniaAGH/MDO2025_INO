# Zajęcia 07
---
## Jenkinsfile: lista kontrolna
Oceń postęp prac na pipelinem - proces ujęty w sposób deklaratywny. Przejdź przez listę kontrolną, tym razem dla samego Jenkinsfile'a: kluczowego elementu Twojego sprawozdania!

### Kroki Jenkinsfile
Zweryfikuj, czy definicja pipeline'u obecna w repozytorium pokrywa ścieżkę krytyczną:

- [ ] Przepis dostarczany z SCM, a nie wklejony w Jenkinsa lub sprawozdanie (co załatwia nam `clone` )
- [ ] Posprzątaliśmy i wiemy, że odbyło się to skutecznie - mamy pewność, że pracujemy na najnowszym (a nie *cache'owanym* kodzie)
- [ ] Etap `Build` dysponuje repozytorium i plikami `Dockerfile`
- [ ] Etap `Build` tworzy obraz buildowy, np. `BLDR`
- [ ] Etap `Build` (krok w tym etapie) lub oddzielny etap (o innej nazwie), przygotowuje artefakt - **jeżeli docelowy kontener ma być odmienny**, tj. nie wywodzimy `Deploy` z obrazu `BLDR`
- [ ] Etap `Test` przeprowadza testy
- [ ] Etap `Deploy` przygotowuje **obraz lub artefakt** pod wdrożenie. W przypadku aplikacji pracującej jako kontener, powinien to być obraz z odpowiednim entrypointem. W przypadku buildu tworzącego artefakt niekoniecznie pracujący jako kontener (np. interaktywna aplikacja desktopowa), należy przesłać i uruchomić artefakt w środowisku docelowym.
- [ ] Etap `Deploy` przeprowadza wdrożenie (start kontenera docelowego lub uruchomienie aplikacji na przeznaczonym do tego celu kontenerze sandboxowym)
- [ ] Etap `Publish` wysyła obraz docelowy do Rejestru i/lub dodaje artefakt do historii builda
- [ ] Ponowne uruchomienie naszego *pipeline'u* powinno zapewniać, że pracujemy na najnowszym (a nie *cache'owanym*) kodzie. Innymi słowy, *pipeline* musi zadziałać więcej niż jeden raz 😎

### *"Definition of done"*
Proces jest skuteczny, gdy "na końcu rurociągu" powstaje możliwy do wdrożenia artefakt (*deployable*).
* Czy opublikowany obraz może być pobrany z Rejestru i uruchomiony w Dockerze **bez modyfikacji** (acz potencjalnie z szeregiem wymaganych parametrów, jak obraz DIND)? Nie chcemy posyłać w świat czegoś, co działa tylko u nas!
* Czy dołączony do jenkinsowego przejścia artefakt, gdy pobrany, ma szansę zadziałać **od razu** na maszynie o oczekiwanej konfiguracji docelowej?

## Przygotowanie do następnych zajęć: Ansible
Będziemy potrzebować drugiej maszyny wirtualnej. Dla oszczędności zasobów, musi być jak najmniejsza i jak najlżejsza.
* Utwórz drugą maszynę wirtualną o **jak najmniejszym** zbiorze zainstalowanego oprogramowania
  * Zastosuj najlepiej ten sam system operacyjny, co "główna" maszyna
  * Zapewnij obecność programu `tar` i serwera OpenSSH (`sshd`), tak, by działały narzędzia zdalne
  * Nadaj maszynie *hostname* `ansible-target`
  * Utwórz w nowym systemie użytkownika `ansible`
  * Zrób migawkę maszyny (i/lub przeprowadź jej eksport)
* Na głównej maszynie wirtualnej (nie na tej nowej!), zainstaluj [oprogramowanie Ansible](https://docs.ansible.com/ansible/2.9/installation_guide/index.html), najlepiej z repozytorium dystrybucji
* Wymień klucze SSH między użytkownikiem w głównej maszynie wirtualnej, a użytkownikiem `ansible` z nowej tak, by logowanie `ssh ansible@ansible-target` nie wymagało podania hasła
