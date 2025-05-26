# Zajęcia 09 - Pliki odpowiedzi dla wdrożeń nienadzorowanych

---

###  Cel zadania

Celem zadania było przygotowanie źródła instalacji nienadzorowanej systemu Fedora w środowisku maszyn wirtualnych lub serwerów fizycznych. Instalacja ta miała automatycznie przygotować system operacyjny hostujący oprogramowanie – działające poza kontenerem. 

---

### Modyfikacja pliku kickstart

Po ręcznej instalacji systemu Fedora plik odpowiedzi instalatora (/root/anaconda-ks.cfg) został skopiowany i zmodyfikowany tak, aby umożliwić w pełni zautomatyzowaną instalację systemu, który po uruchomieniu jest gotowy do hostowania aplikacji.

#### Skopiowanie pliku anaconda-ks.cfg

Po zalogowaniu się do systemu, wykonałam polecenia:

```
sudo cp /root/anaconda-ks.cfg /home/amelia/fedora-auto.ks
sudo chown amelia:amelia /home/amelia/fedora-auto.ks

```
W celu dalszej edycji, skopiowano plik instalacyjny `anaconda-ks.cfg` z katalogu `/root` do katalogu domowego użytkownika `amelia` jako `fedora-auto.ks`. Następnie zmieniono właściciela pliku, aby użytkownik `amelia` mógł go modyfikować bez użycia uprawnień administratora.

---


## Github Actions

---

![](https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO/blob/AN417592/ITE/GC_L05/Sprawozdanie3/fork%20TFT.png?raw=true)
![](https://github.com/InzynieriaOprogramowaniaAGH/MDO2025_INO/blob/AN417592/ITE/GC_L05/Sprawozdanie3/forked%20TFT.png)
