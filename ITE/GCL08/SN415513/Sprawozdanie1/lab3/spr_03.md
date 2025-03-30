# Zajęcia 03
---
# Dockerfiles, kontener jako definicja etapu
## Zadania do wykonania
### Wybór oprogramowania na zajęcia
* Znajdź repozytorium z kodem dowolnego oprogramowania, które:
	* dysponuje otwartą licencją
	* jest umieszczone wraz ze swoimi narzędziami Makefile tak, aby możliwe był uruchomienie w repozytorium czegoś na kształt ```make build``` oraz ```make test```. Środowisko Makefile jest dowolne. Może to być automake, meson, npm, maven, nuget, dotnet, msbuild...
	* Zawiera zdefiniowane i obecne w repozytorium testy, które można uruchomić np. jako jeden z "targetów" Makefile'a. Testy muszą jednoznacznie formułować swój raport końcowy (gdy są obecne, zazwyczaj taka jest praktyka)




* Sklonuj niniejsze repozytorium, 
- https://github.com/weechat/weechat

```
git clone https://github.com/weechat/weechat.git
```

przeprowadź build programu (doinstaluj wymagane zależności)
```
sudo apt update
sudo apt install -y gcc g++ clang cmake pkgconf libncurses-dev libcurl4-gnutls-dev libgcrypt20-dev libgnutls28-dev zlib1g-dev gettext ca-certificates libcjson-dev libzstd-dev libaspell-dev python3-dev libperl-dev ruby-dev tcl-dev guile-3.0-dev libnode-dev libxml2-dev libargon2-dev libsodium-dev asciidoctor libcpputest-dev
```

build:
```
mkdir build
cd build
cmake .. -DENABLE_PHP=OFF -DENABLE_LUA=OFF -DENABLE_TESTS=ON
make
sudo make install
```

* Uruchom testy jednostkowe dołączone do repozytorium
testy:
```
ctest -V
```

Aplikacja:
img6

### Przeprowadzenie buildu w kontenerze
Ponów ww.  proces w kontenerze, interaktywnie.
1. Wykonaj kroki `build` i `test` wewnątrz wybranego kontenera bazowego. Tj. wybierz "wystarczający" kontener, np ```ubuntu``` dla aplikacji C lub ```node``` dla Node.js
	* uruchom kontener
	```
	docker run -it --name ubuntu ubuntu:latest /bin/bash
	```
	w kontenerze:
	```
	apt update
	apt install -y git gcc g++ clang cmake pkgconf libncurses-dev libcurl4-gnutls-dev libgcrypt20-dev libgnutls28-dev zlib1g-dev gettext ca-certificates libcjson-dev libzstd-dev libaspell-dev python3-dev libperl-dev ruby-dev tcl-dev guile-3.0-dev libnode-dev libxml2-dev libargon2-dev libsodium-dev asciidoctor libcpputest-dev locales
	
	podczas apt-installl należy wskazać strefę czasową. 
	konfiguracja:
	```
	sudo locale-gen en_US.UTF-8

	export LC_ALL=en_US.UTF-8
	export LANG=en_US.UTF-8
	export LANGUAGE=en_US.UTF-8
	```

	``
	git clone https://github.com/weechat/weechat.git
	cd weechat
	mkdir build
	cd build
	cmake .. -DENABLE_PHP=OFF -DENABLE_LUA=OFF -DENABLE_TESTS=ON
	make
	make install
	ctest -V
	```
	aplikacja:

	

2. Stwórz dwa pliki `Dockerfile` automatyzujące kroki powyżej, z uwzględnieniem następujących kwestii:
	* Kontener pierwszy ma przeprowadzać wszystkie kroki aż do *builda*
	```
	FROM ubuntu:latest

	RUN apt-get update && apt install -y git gcc g++ clang cmake pkgconf libncurses-dev libcurl4-gnutls-dev libgcrypt20-dev libgnutls28-dev zlib1g-dev gettext ca-certificates libcjson-dev libzstd-dev libaspell-dev python3-dev libperl-dev ruby-dev tcl-dev guile-3.0-dev libnode-dev libxml2-dev libargon2-dev libsodium-dev asciidoctor libcpputest-dev

	WORKDIR /app
	RUN git clone https://github.com/weechat/weechat.git

	WORKDIR /app/weechat
	RUN mkdir build
	WORKDIR /app/weechat/build

	RUN cmake .. -DENABLE_PHP=OFF -DENABLE_LUA=OFF -DENABLE_TESTS=ON && make && make install

	```

	```
	docker build -t weechat-build -f Dockerfile.build .
	```

	* Kontener drugi ma bazować na pierwszym i wykonywać testy (lecz nie robić *builda*!)
	```
	FROM weechat-build

	WORKDIR /app/weechat/build

	RUN ctest -V
	```

	```
	docker build -t weechat-test -f Dockerfile.test .
	```

3. Wykaż, że kontener wdraża się i pracuje poprawnie. Pamiętaj o różnicy między obrazem a kontenerem. Co pracuje w takim kontenerze?
   

