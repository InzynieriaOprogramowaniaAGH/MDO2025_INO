import os
import subprocess

def run(command):
    print(f"\n🟡 Wykonywanie: {command}")
    result = subprocess.run(command, shell=True)
    if result.returncode != 0:
        print(f"🔴 Błąd przy komendzie: {command}")
        exit(1)
    print(f"🟢 Sukces: {command}")

def install_kubectl():
    print("\n===> Instalacja kubectl")
    run('curl -LO "https://dl.k8s.io/release/$(curl -Ls https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"')
    run('chmod +x kubectl')
    run('sudo mv kubectl /usr/local/bin/')

def install_minikube():
    print("\n===> Instalacja Minikube")
    run('curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-latest.x86_64.rpm')
    run('sudo rpm -Uvh minikube-latest.x86_64.rpm')

def start_minikube():
    print("\n===> Start Minikube")
    run('minikube start --driver=docker')

def deploy_sample_app():
    print("\n===> Tworzenie przykładowej aplikacji")
    run('kubectl create deployment hello-minikube --image=kicbase/echo-server:1.0')
    run('kubectl expose deployment hello-minikube --type=NodePort --port=8080')
    run('minikube service hello-minikube')

def launch_dashboard():
    print("\n===> Uruchomienie dashboardu")
    print("🔵 Użyj tej komendy ręcznie w terminalu, jeśli jesteś bez GUI:")
    print("    minikube dashboard --url")
    print("🔵 Lub uruchom w środowisku graficznym:")
    print("    minikube dashboard")

def print_concepts():
    print("\n📘 Zapoznaj się z pojęciami Kubernetes:")
    print(" - Pod: najmniejsza jednostka wykonawcza")
    print(" - Deployment: sposób zarządzania replikami podów")
    print(" - Service: wystawienie aplikacji na zewnątrz")
    print(" - Sprawdź komendy:")
    print("     kubectl get pods")
    print("     kubectl describe pod <nazwa>")
    print("     kubectl get deployments")

if __name__ == "__main__":
    print("🚀 Automatyczna instalacja klastra Kubernetes (Minikube)")
    install_kubectl()
    install_minikube()
    start_minikube()
    deploy_sample_app()
    launch_dashboard()
    print_concepts()
