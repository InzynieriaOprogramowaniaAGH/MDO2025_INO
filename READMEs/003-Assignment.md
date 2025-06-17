# Sprawozdanie 3

## Format sprawozdania
- Wykonaj opisane w zadaniach ćwiczeniowych 8-11 kroki i udokumentuj ich wykonanie
- Na dokumentację składają się następujące elementy:
  - plik tekstowy ze sprawozdaniem, zawierający opisy z każdego z punktów zadania, zapisany w formacie Markdown
  - zrzuty ekranu przedstawiające wykonane kroki (oddzielny zrzut ekranu dla każdego kroku), osadzone w pliku ze sprawozdaniem
  - listing historii poleceń (cmd/Bash/PowerShell), sformatowany jako blok kodu lub załączony oddzielnie
- Sprawozdanie nie powinno być jedynie enumeracją wykonanych kroków. Powinno umożliwiać **odtworzenie wykonanych kroków** z wykorzystaniem opisu, poleceń i zrzutów.
- Oznacza to, że sprawozdanie powinno zawierać opis czynności w odpowiedzi na (także zawarte) kroki z zadania.
- Przeczytanie dokumentu powinno umożliwiać zapoznanie się z procesem i jego celem bez konieczności otwierania treści zadania.

Kilka dodatkowych uwag:
* Proszę zwrócić uwagę na to, czy dany etap nie jest *„self explanatory”* tylko dla autora: czy zrozumie go osoba czytająca dokument pierwszy raz. Odtwarzalność przeprowadzonych operacji jest kluczowo istotna w przypadku dokumentowania procesu
* Zrzuty ekranu muszą być zgodne z opisem
  * Czy to, co się wydarzyło, naprawdę widać na screenach?
  * Czy wykazano np. po instalacji Kickstart, że system został adekwatnie skonfigurowany, a nie tylko napisał tak instalator?
  * W przypadku Ansible - czy wiadomo, dlaczego coś jest `OK`, a coś `Changed`?
* Napotykane problemy również należy dokumentować. Z punktu widzenia zadania, nie ma sensu ani potrzeby udawać, że przebiegło ono bez problemów.
* Krótko mówiąc, sprawozdanie powinno być sformułowane w sposób, który umożliwi dotarcie do celu i identycznych rezultatów osobie, która nie miała wcześniej kontaktu z używanymi narzędziami
* Można poprosić inną osobę z zespołu o przejrzenie! Na tym polega recenzja kodu 😅


## Ścieżki
- Sprawozdanie proszę umieścić w następującej ścieżce: ```<kierunek>/<grupa>/<inicjały><numerIndeksu>/Sprawozdanie3/README.md```, w formacie Markdown
- Dedykowany katalog na sprawozdanie powinien zawierać wszystkie wymagane pliki wewnątrz:
  - każdy użyty *screenshot*
  - kazdy cytowany plik (np. `Dockerfile`)
- W przypadku stosowania do pomocy narzędzi LLM/AI:
  - proszę podać treść wysłanego zapytania
  - metodę weryfikacji odpowiedzi
- Proszę posprzątać katalogi. Tak, by był możliwy "czysty *merge*"

## Pull Request
- PR musi spełniać kryteria wstępne:
  - Wystawiony do odpowiedniej **gałęzi ćwiczeniowej**
  - Nazwany inicjałami i numerem indeksu, z dopiskiem S3
  - **Nie wywołuje konfliktów podczas próby merge'u!!**

## Oceny
- Oceny będą obecne w systemie USOS, pojawiając się przez okno czasowe oddawania sprawozdań
  - Terminy: do 30 maja: max 5.0
  - Tydzień później: max 4.0
  - Kolejny tydzień później: max 3.0
