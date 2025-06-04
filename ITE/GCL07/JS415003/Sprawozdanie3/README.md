# Sprawozdanie 3

## 008-Class

Pierwszym zadaniem była instalacja zarządcy ansible na głównej maszynie fedory na której były robione wszystkie poprzednie zadania oraz nowej maszyny nie posiadającej zainstalowanego ansible.

Na poniższym zrzucie ekranu widać instalacje wszystkich potrzebnych dependencji do wykonania kolejnych zadań na maszynie ansible-target.
![](008-Class/screens/lab8_1.png)

Tutaj instalacja ansible na maszynie ansible-orchestrator (maszyna główna z fedorą).
![](008-Class/screens/lab8_2.png)

Włączenie migawki dla maszyny ansible-target.

![](008-Class/screens/lab8_25.png)

Tutaj pokazanie końcowego efektu po odpowiednim przydzieleniu rozwiązywania nazw maszyn w DNS oraz połączenie się głównej maszyny z ansible-target. 
![](008-Class/screens/lab8_3.png)

Poniżej komendy użyte do przydzielenia nowych hostname innych niż localhost.
![](008-Class/screens/lab8_4.png)
![](008-Class/screens/lab8_5.png)

Przypisanie odpowiednich ip w pliku etc/hosts.

![](008-Class/screens/lab8_6.png)

Test łączności z ansible-orchestrator do ansible-target.
![](008-Class/screens/lab8_7.png)

Tutaj też test łączności, ale przypadek odwrotny.
![](008-Class/screens/lab8_8.png)

Plik inwentaryzacji [inventory.yml](008-Class/inventory.yml)
![](008-Class/screens/lab8_9.png)

Wykonanie komendy ansible pingall wykonane pomyślnie.
![](008-Class/screens/lab8_10.png)

Tutaj wykonanie komendy pingall ale za pomocą playbooka ansible. [pingall-playbook.yml](008-Class/playbooks/pingall-playbook.yml)
![](008-Class/screens/lab8_11.png)
![](008-Class/screens/lab8_12.png)
![](008-Class/screens/lab8_13.png)

Komenda dokonująca update pakietów za pomocą ansible playbook. [update-playbook.yml](008-Class/playbooks/update-playbook.yml)
![](008-Class/screens/lab8_14.png)

Restart uslugi rngd i sshd. [restartsshd-playbook.yml](008-Class/playbooks/restartsshd-playbook.yml)
![](008-Class/screens/lab8_15.png)
![](008-Class/screens/lab8_16.png)
![](008-Class/screens/lab8_18.png)

Odpięcie karty sieciowej od maszyny.
![](008-Class/screens/lab8_17.png)

Wysłanie żądania do maszyny z wyłączoną kartą sieciową.
![](008-Class/screens/lab8_19.png)

Kolejnym etapem było wysłanie utworzonego artefaktu z pipelina do maszyny ansible-target w moim przypadku dla biblioteki cJSON była spakowana biblioteka, którą musiałem przesłać na maszynę.

Utworzenie szkieletu za pomocą ansible-galaxy.
![](008-Class/screens/lab8_20.png)
![](008-Class/screens/lab8_21.png)

Wszystkie kroki pomyślnie wykonane dla playbooka deploy_cjson.yml. [deploy_cjson.yml](008-Class/deploy_cjson.yml)
![](008-Class/screens/lab8_22.png)
![](008-Class/screens/lab8_23.png)
![](008-Class/screens/lab8_24.png)