# Prawo Conway'a i AWS
- **UWAGA!** Wykonanie ćwiczenia nie jest obowiązkowe. Termin oddania wg. USOS:
    * Podwyższenie oceny wyższej niż 3.0 o pół stopnia dla terminu 1 zaliczenia: 2025-07-10
    * Podwyższenie oceny wyzszej niż 3.0 o pół stopnia dla terminu 2 i 3 zaliczenia (tylko dla oceny 4.5 i 5.0): 2025-09-19
Format sprawozdania jak poprzednio.

## Zadania do wykonania
Celem ćwiczenia jest wdrożenie dowolnej aplikacji webowej na chmurze AWS w formie *three-tier architecture*. Aplikacja powinna składać się co najmniej z następujących komponentów:
- *frontend*, np. React, Vue
- *backend*, np. Nodejs, Django
- baza danych z puli dostępnych na chmurze.
Nie ma wymagań co do funkcjonalności - może to być wyświetlanie treści zwracanej przez jeden *endopoint*, uzupełnianej o dane z bazy danych.

## Polecenia
1. Upewnij się, że wykorzystujesz zasoby regionu `us-east-1`, następnie stwórz trzy [Security Groups](https://docs.aws.amazon.com/vpc/latest/userguide/vpc-security-groups.html), umieszczając je w domyślnym VPC:
    - Dla bazy danych - pozwól na dowolny ruch wychodzący (outbound rules) oraz na _bezpieczny_ przychodzący (inbound rules).
    - Dla aplikacji backendowej - pozwól na dowolny ruch wychodzący (outbound rules) oraz na _bezpieczny_ przychodzący (inbound rules). Testowo należy dodać możliwość komunikacji poprzez SSH.
    - Dla aplikacji frontendowej - pozwól na dowolny ruch wychodzący (outbound rules) oraz _bezpieczny_ przychodzący (inbound rules). Testowo należy dodać możliwość komunikacji poprzez SSH.
2. Stwórz maszyny wirtualne dla aplikacji backendowej oraz frontendowej w ramach usługi EC2. Zalecane parametry:
    - System operacyjny: [Amazon Linux 2](https://aws.amazon.com/amazon-linux-2/)
    - Typ instancji: [`t2.micro`](https://aws.amazon.com/ec2/instance-types/t2/)
    - [VPC](https://docs.aws.amazon.com/vpc/latest/userguide/what-is-amazon-vpc.html): domyślnie stworzone
    - Umieść maszyny we właściwych Security Groupach stworzonych w punkcie 2
3. Skonfiguruj maszyny wirtualne dla aplikacji backendowej oraz frontendowej, by mogły zostać prawidłowo uruchomione.
4. Stwórz bazę danych w dowolnej usłudze bazodanowej. Zalecane parametry:
    - Usługa [RDS](https://aws.amazon.com/rds/)
    - Baza MySQL
    - Template: *free tier*
    - Typ instancji: dowolny `micro` lub `small`
    - Dostęp publiczny ustawić na wyłączony (domyślna wartość)
    - Umieść tworzoną bazę w Security Groupie stworzonej w punkcie 2b
    - Wyłącz [*performance insights*](https://aws.amazon.com/rds/performance-insights/), backup oraz encryption (mogą mieć wpływ na koszty)
5. Zweryfikuj:
    - Połączenie pomiędzy backendem a bazą danych. W razie potrzeby wgraj backup bazy z poziomu maszyny EC2.
    - Połączenie pomiędzy frontendem a backendem.
    - Dostępność frontendu z adresu publicznego.
    - Brak dostępu do backendu oraz bazy danych z adresów publicznych.
	- Po weryfikacji usuń **wszystkie** zasoby, stworzone w ramach ćwiczenia. Udokumentuj to w sprawozdaniu!
