# Sprawozdanie 3
Autor: Kacper Hyla
---

## Ćwiczenie 8

Tematem ósmych zajęć był `Ansible`, czyli narzędzie służące do automatyzacji instalacji oraz wdrożenia oprogramowania na (najczęściej) wielu urządzeniach.

Pierwszym krokiem było stworzenie drugiej maszyny wirtualnej z tym samym systemem operacyjnym (tutaj jest to fedora 41) z użytkownikiem `ansible`. Zrzut ekranu przedstawiający obydwie maszyny w menu Virtual Box'a przedstawiono poniżej. Znajdują się tam też specyfikacje nowo utworzonej maszyny.
![alt text](image-4.png)
![alt text](image-5.png)

Już na zainstalowanej maszynie nadano jej hostname `ansible-target`, edytując plik `etc/hostname`.

![alt text](image-11.png)

Upewniono się również, że na maszynie pobrany jest `tar`, oraz `OpenSSH`.

![alt text](image-6.png)

Następnie zrobiono migawkę maszyny, czyli jej kopię, dzięki której można ją przywrócić do starej wersji gdy okaże się, że nowo wprowadzona powoduje problemy.

![alt text](image-7.png)
![alt text](image-8.png)

Po tych operacjach konieczne było, tym razem na starej maszynie, zainstalować ansible.

![alt text](image-10.png)
![alt text](image-14.png)

Stworzono również 2 pary kluczy, którymi wymieniły się maszyny, aby móc się łączyć przez protokół ssh bez hasła.

![alt text](<Zrzut ekranu 2025-04-28 185940.png>)

Dodatkowo, edytowano plik `etc.hosts`, aby powiązać adres ip maszyn ansible z nazwą `ansible-target`.

![alt text](image-12.png)
![alt text](image-13.png)


W następnym kroku również nadano nazwę hosta dla orginalnej maszyny fedory (tej z pierwszych zajęć). Również osiągnięto to przez edycję pliku `etc/hostname` i reboot. Poniższe zrzuty ekranu pokazują zastosowanie polecenia `hostnamectl` na obydwu maszynach, celem upewnienia się, jakie są nazwy hostów.

![alt text](image-17.png)
![alt text](image-18.png)

Na maszynie z zainstalowanym ansible utworzono plik inwentaryzacji (zawartość w zrzucie poniżej), a następnie dokonano jego weryfikacji.

![alt text](image-20.png)
![alt text](image-19.png)

W następnym kroku wysłano ping do endpointa. Pojawił się jednak problem, ponieważ ansible starał się połączyć do użytkownika `kh@ansible-target` zamiast `ansible@ansible-target`.

![alt text](image-21.png)

Rozwiązaniem było dodanie do pliku nazwy użytkownika.
![alt text](image-22.png)
![alt text](image-23.png)
Problem ten jednak pozwala przypuszczać, że ansible próbuje się połączyć z użytkownikiem o takiej samej nazwie, jak użytkownik, który wykonał polecenie.

Kolejnym krokiem było stworzenie `playbook'a`, czyli zbioru zadań do wykonania przez Ansible'a. Miał on 2 zadania: ping, oraz wysłanie playbook'a do dziś utworzonej maszyny. Jego treść prezentuje się następująco.

````
- name: MyPlaybook
  hosts: Endpoints

  tasks:
    - name: ping
      ansible.builtin.ping:

    - name: copy
      ansible.builtin.copy:
        src: /home/kh/playbook.yaml
        dest: /home/ansible/playbook.yaml
        mode: '0644'
````
Całość tworzona jest przy użyciu składni `YAML`. Najpierw tworzona jest nazwa playbook'a, a następnie wybierane są hosty, względem których ma zostać wykonana seria zadań. Zadanie `ping` jest self explanatory, lecz `copy` wymaga omówienia. Konieczne jest ustalenie źródła (pliku, który zostanie skopiowany) i destynacji (miejsca i nazwy pliku, do którego przekopiowana zostanie zawartość źródła) oraz mode, będący uprawnieniami do pliku. Tutaj jest to liczba w sysyemie oktalnym (dlatego zaczyna się od 0), w której właścicielowi nadaje się prawa od odczytu i zapisu, a grupie i reszcie tylko do odczytu. 

Uruchomiono zatem playbook. Zrobiono to 2 razy, żeby pokazać, że za drugim razem, kiedy plik już został wysłany nie doszło do żadnej zmiany. Widać to na zrzutach ekranu poniżej.

![alt text](image-24.png)
![alt text](image-26.png)
![alt text](image-25.png)

Następnie do playbook'a dodano kolejne kroki. Było to: 
- zaktualizowanie pakietów przy użyciu `ansible.builtin.dnf` z `update_only` ustawionym na `yes`. Do tej operacji potrzebne były uprawnienia roota, a zatem wykorzystano opcję `become: true`, aby móc korzystać z sudo.

- zrestartowano usługi `sshd` oraz `rngd`(którą to wcześniej porbano zwykłym dnf install), przy pomocy modułu `ansible.builtin.service` z podaną nazwą usługi i stanem ustalonym na `restarted`.

Treść playbooka zamieszczono poniżej.

````
- name: MyPlaybook
  hosts: Endpoints
  
  become: true
  
  tasks:
    - name: ping
      ansible.builtin.ping:

    - name: copy
      ansible.builtin.copy:
        src: /home/kh/playbook.yaml
        dest: /home/ansible/playbook.yaml
        mode: '0644'

    - name: update
      ansible.builtin.dnf:
        name: "*"
        state: latest
        update_only: yes

    - name: restart sshd
      ansible.builtin.service:
       name: sshd
       state: restarted

    - name: restart rngd
      ansible.builtin.service:
       name: rngd
       state: restarted
````
![alt text](image-28.png)

Następnie należało powtózyć tą operację dla maszyny z odpiętą kartą sieciową. do tego celu wyłączono interfejs sieciowy z pomocą poniższej komendy.

````
sudo ip link set enp0s8 down
````
Nazwę interfejsu uzyskano dzięki wpisaniu w terminal `ip addr`.

![alt text](image-29.png)
![alt text](image-30.png)
Operacja oczywiście nie powiodła się, ponieważ ansible nie mógł nawiązać połączenia.

Następnie należało przy pomocy ansible pobrać artefakt będący rezultatem pipelineu z poprzedniego sprawozdania, połączyć się z nim a następnie usunąć. W tym wypadku kontener współpracuje wyłącznie z inputem z klawiatury od użytkownika, a zatem ograniczono się do potwierdzenia, że kontener został utworzony i działa przy pomocy docker ps.

Całe to zadanie opakowano w `rolę`, stworzoną dzięki `ansible galaxy`.

Utworzono rolę `artif_role` oraz zmodyfikowano znajdujący się w katalogu tasks plik `main.yml`.
![alt text](image-31.png) 

W owym pliku wykrozystano wcześniej użyty moduł `dnf` celem pobrania dockera a następnie moduł `service` do jego uruchomienia. Z pomocą `community.docker.docker_container` zbudowano kontener z obrazu, a konendy powłoki były możliwe dzięki użyciu `ansible.builtin.command`. Jego treść zawarto poniżej.

```
---
- name: Artifact_playbook
  become: true
  
  tasks:
    - name: Download docker
      ansible.builtin.dnf:
        name: docker

    - name: Start docker
      ansible.builtin.service:
        name: docker
        state: started
      

    - name: Build
      community.docker.docker_container:
        name: picoc
        image: khan9/pico-c_interactive:1.73
        state: started
        command: sleep infinity

    - name: Test
      ansible.builtin.command: docker ps -a
      register: out

    - name: Print the result of the program
      debug:
        var: out.stdout

    - name: Stop
      ansible.builtin.command: docker stop picoc

    - name: Remove
      ansible.builtin.command: docker rm picoc
      
```


Stworzono też plik `playbook_docker.yaml`, który ową rolę będzie obsługiwał.
```
- name: Deploy docker container
  hosts: Endpoints
  become: true
  roles:
    - artif_role
```
Zrzut ekranu  wykonania zamieszczono poniżej.

![alt text](image-32.png)

---

## Ćwiczenie 9

Na dziewiątych zajęciach omówiony był mechanizm `kickstart`, służący do automatycznego skonfigurowania tworzonej maszyny wirtualnej.

Pierwszym krokiem było wybranie jednej z wcześniej utworzonych maszyn fedory (tutaj padło na maszynę z pierwszych zajęć) i pobranie pliku 'anaconda-ks.cfg' z katalogu root'a. Tutaj pojawiały się już pierwsze przeszkody, ponieważ należało wyjść z katalogu użytkownika i zmienić dostęp katalogu `root` celem odczytania zawartych tam plików. Następnie należało skopiować istniejący tam plik `anaconda-ks.cfg`. Niestety samego procesu dla docelowej maszyny nie udało się uwiecznić na zrzucie ekranu, dlatego kroki te powtórzon na maszynie `ansible`. Przedstawia to poniższy zrzut ekranu.

![alt text](image-33.png)

---
![alt text](image-3.png)
![alt text](image-1.png)
![alt text](image-2.png)
![alt text](image.png)

