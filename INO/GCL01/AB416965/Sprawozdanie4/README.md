# Sprawozdanie 3

- **Przedmiot: DevOps**
- **Kierunek: Inżynieria Obliczeniowa**
- **Autor: Adam Borek**
- **Grupa 1**

---

## Wdrażanie na zarządzalne kontenery w chmurze (Azure)

### Przygotowanie kontenera

Zanim przystąpiłem do wykonywania zadań upewniłem się czy mój kontener z aplikacją nadal znajduje się na Docker Hubie.

### Zapoznanie z platformą

Korzystjąc z Panelu AGH zalogowałem się do usługi Azure. Zostało utworzone konto studenckie.

Na start otrzymałem 100 USD. Wykonywanie operacji na Azure wykorzystuje te środki.

![Początkowy stan kredytów](zrzuty12/zrzut_ekranu1.png)

Następnie korzystjąc z wbudowanego terminala zalogowałem się do Azure.

![Zalogowanie do Azure](zrzuty12/zrzut_ekranu2.png)

### Wdrożenie aplikacji

Pierwszą komendą którą wykonałem było utworzenie grupy za pomocą polecenia:

```bash
az group create --name MyGroup --location westeurope
```

![Utworzenie grupy](zrzuty12/zrzut_ekranu3.png)

Następnie utworzyłem kontener wykorzystując polecenie:

```bash
az container create \
  --resource-group MyGroup \
  --name moj-nginx-v1 \
  --image index.docker.io/frigzer/my-nginx:v1 \
  --registry-login-server index.docker.io \
  --registry-username frigzer \
  --dns-name-label moj-nginx-v1-adam \
  --ports 80 \
  --location westeurope \
  --os-type Linux \
  --cpu 1 \
  --memory 2
```



## Shift-left: GitHub Actions

GitHub actions: https://github.com/Frigzer/cJSON/blob/ino_dev/.github/workflows/c-cpp.yml