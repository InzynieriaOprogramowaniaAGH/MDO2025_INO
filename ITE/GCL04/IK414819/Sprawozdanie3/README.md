Sprawozdanie 3

Lab 8

Ansible
 Celem tej części laboratorium była : Automatyzacja i zdalne wykonywanie poleceń za pomocą Ansible
 Aby dokonać instalacji Ansible, utworzyłem nową "drugą" maszyne wirtualną z jak najmniejszym zbiorem zainstalowanego oprogramowania. Zastosowałem na niej ten sam system operacyjny co na "głównej maszynie" , czyli Fedorę. Zapewniłem ta również obacność wymaganych programów, tak aby w pełni móc zreazliować pozostałe etapy. Nową maszynę zgodznie z zaleceniem prowadzącego  nazwałem "ansible-target".Nastepnie utowrzyłem użytkownika ansible. Wykonałem mogawkę maszyny. Na mojej głównej maszynie wirtualnej zainstalowałem oprogrmowanie Ansible z repozytorium dystrybucji. Dokonałem wymiany kluczy SSH między użytkownikiem w głównej maszynie a użytkownikiem ansible z nowej tak by logowanie ssh ansible@ansible-target mie wymagało podania hasła. W kolejnym kroku dokonałem inwentaryzacji systemów. Stworzyłem pliki inventory.ini oraz później playbook1.yaml.

![odpalenie_ssh](odpalenie_ssh_ansible.jpg)

![briged_netowrk](briged_network.jpg)

Następnie za pomocą playbooka wykonałem ping do wszystkich maszyn:

![ping_dziala](ping_dziala_ansilbe.jpg)

![playbook1](playbook_run1_ansible.jpg)

![playbook2](playbook_run2_ansible.jpg)

![playbook3](playbook_run3_ansible.jpg)

![playbook4](playbook_run4_ansible.jpg)

![playbook5](playbook_run5_ansible.jpg)




Lab 10

Celem zajęć było Wdrażanie na zarządzalne kontenery: Kubernetes

W tym celu zainstalowałem klastrę Kubernetes. Zaopatrzyłem się w  implementację stosu k8s minikube. Przeszedłem do realizacji zadań, kolejno zapewniając bezpieczeństwo instalacji. Uruchomiłem Kubernetesa a następnie Dashboard. Zapoznałem się również z funkcjami Kubernetesa. Zdefiniowałem w swoim projekcie krok Deploy. W tym celu przygotowałem odpowiedni Dockerfile. W ramach tego sprawozdania w celu ułatwienia sobie pracy, zamieniłem swój poprzedni projekt (irsssi) na tzw. obraz gotowiec , czyli aplikację nginx. Następnie wykazałem,iż wybrana aplikacja pracuje jako kontener.

![uruchomienie minikube](uruchomienie_minikube_lab10.jpg)

![minikube_dashboard](minikube_dashboard_lab10.jpg)

![workloads](workloads_lab10.jpg)

![addons_metrics](addons_metrics_lab10.jpg)


![nginx_deploy](nginx_deploy_dziala_lab10.jpg)

![hello_run](hello_run_lab10.jpg)

![welcome_to_nginx](welcome_to_nginx_lab10.jpg)

![nginx_service](nginx_service_lab10.jpg)
