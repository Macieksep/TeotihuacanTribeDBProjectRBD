-- Skrypty DDL wygenerowane za pomocą diagramu związków encji Vertabelo
-- Projekt: Miasto Teotihuacan (Projekt semestralny z przedmiotu RBD)
-- Autor: Maciej Sepeta s30518 19c
-- Baza danych: OracleDB

-- tabele
-- Tabela: Bron
CREATE TABLE Bron (
    ID integer  NOT NULL,
    Nazwa varchar2(20)  NOT NULL,
    Typ varchar2(20)  NOT NULL,
    CONSTRAINT Bron_pk PRIMARY KEY (ID)
) ;

-- Tabela: Dieta
CREATE TABLE Dieta (
    ID integer  NOT NULL,
    Nazwa varchar2(20)  NOT NULL,
    Typ varchar2(20)  NOT NULL,
    CONSTRAINT Dieta_pk PRIMARY KEY (ID)
) ;

-- Tabela: Farmer
CREATE TABLE Farmer (
    Podwladny_ID integer  NOT NULL,
    Pomocnik_ID integer  NULL,
    CONSTRAINT Farmer_pk PRIMARY KEY (Podwladny_ID)
) ;

-- Tabela: Farmer_Skladnik
CREATE TABLE Farmer_Skladnik (
    Farmer_ID integer  NOT NULL,
    Skladnik_ID integer  NOT NULL,
    Produkcja integer  NOT NULL,
    CONSTRAINT Farmer_Skladnik_pk PRIMARY KEY (Skladnik_ID,Farmer_ID)
) ;

-- Tabela: Leczenie
CREATE TABLE Leczenie (
    ID integer  NOT NULL,
    Osoba_ID integer  NOT NULL,
    Medyk_ID integer  NOT NULL,
    Choroba varchar2(40)  NOT NULL,
    CONSTRAINT Leczenie_pk PRIMARY KEY (ID)
) ;

-- Tabela: Medyk
CREATE TABLE Medyk (
    Podwladny_ID integer  NOT NULL,
    Specjalizacja varchar2(40)  NOT NULL,
    CONSTRAINT Medyk_pk PRIMARY KEY (Podwladny_ID)
) ;

-- Tabela: Mieszkanie
CREATE TABLE Mieszkanie (
    ID integer  NOT NULL,
    Nazwa varchar2(30)  NOT NULL,
    Typ varchar2(20)  NOT NULL,
    CONSTRAINT Mieszkanie_pk PRIMARY KEY (ID)
) ;

-- Tabela: Osoba
CREATE TABLE Osoba (
    ID integer  NOT NULL,
    Imie varchar2(30)  NOT NULL,
    Nazwisko varchar2(30)  NOT NULL,
    Przydomek varchar2(30)  NOT NULL,
    Plec char(1)  NOT NULL,
    Wiek integer  NOT NULL,
    Wzrost integer  NOT NULL,
    Waga integer  NOT NULL,
    Dieta_ID integer  NOT NULL,
    Mieszkanie_ID integer  NOT NULL,
    CONSTRAINT Plec CHECK (Plec IN ('M', 'F')),
    CONSTRAINT Osoba_pk PRIMARY KEY (ID)
) ;

-- Tabela: Podwladny
CREATE TABLE Podwladny (
    Osoba_ID integer  NOT NULL,
    CONSTRAINT Podwladny_pk PRIMARY KEY (Osoba_ID)
) ;

-- Tabela: Przywodca
CREATE TABLE Przywodca (
    Osoba_ID integer  NOT NULL,
    Ranga varchar2(30)  NOT NULL,
    Pomocnik_ID integer  NULL,
    CONSTRAINT Przywodca_pk PRIMARY KEY (Osoba_ID)
) ;

-- Tabela: Przywodca_Podwladny
CREATE TABLE Przywodca_Podwladny (
    Przywodca_ID integer  NOT NULL,
    Podwladny_ID integer  NOT NULL,
    CONSTRAINT Przywodca_Podwladny_pk PRIMARY KEY (Przywodca_ID,Podwladny_ID)
) ;

-- Tabela: Skladnik
CREATE TABLE Skladnik (
    ID integer  NOT NULL,
    Nazwa varchar2(40)  NOT NULL,
    CONSTRAINT Skladnik_pk PRIMARY KEY (ID)
) ;

-- Tabela: Skladnik_Dieta
CREATE TABLE Skladnik_Dieta (
    Dieta_ID integer  NOT NULL,
    Skladnik_ID integer  NOT NULL,
    Ilosc integer  NOT NULL,
    CONSTRAINT Skladnik_Dieta_pk PRIMARY KEY (Skladnik_ID,Dieta_ID)
) ;

-- Tabela: Wojownik
CREATE TABLE Wojownik (
    Podwladny_ID integer  NOT NULL,
    Doswiadczenie integer  NOT NULL,
    CONSTRAINT Wojownik_pk PRIMARY KEY (Podwladny_ID)
) ;

-- Tabela: Wojownik_Bron
CREATE TABLE Wojownik_Bron (
    Wojownik_ID integer  NOT NULL,
    Bron_ID integer  NOT NULL,
    CONSTRAINT Wojownik_Bron_pk PRIMARY KEY (Bron_ID,Wojownik_ID)
) ;

-- Klucze obce
-- Odnosnik: Bron_Wojownik (tabela: Wojownik_Bron)
ALTER TABLE Wojownik_Bron ADD CONSTRAINT Bron_Wojownik
    FOREIGN KEY (Bron_ID)
    REFERENCES Bron (ID);

-- Odnosnik: Dieta_Skladnik (tabela: Skladnik_Dieta)
ALTER TABLE Skladnik_Dieta ADD CONSTRAINT Dieta_Skladnik
    FOREIGN KEY (Dieta_ID)
    REFERENCES Dieta (ID);

-- Odnosnik: Farmer_Farmer (tabela: Farmer)
ALTER TABLE Farmer ADD CONSTRAINT Farmer_Farmer
    FOREIGN KEY (Pomocnik_ID)
    REFERENCES Farmer (Podwladny_ID);

-- Odnosnik: Farmer_Skladnik (tabela: Farmer_Skladnik)
ALTER TABLE Farmer_Skladnik ADD CONSTRAINT Farmer_Skladnik
    FOREIGN KEY (Farmer_ID)
    REFERENCES Farmer (Podwladny_ID);

-- Odnosnik: Medyk_Leczenie (tabela: Leczenie)
ALTER TABLE Leczenie ADD CONSTRAINT Medyk_Leczenie
    FOREIGN KEY (Medyk_ID)
    REFERENCES Medyk (Podwladny_ID);

-- Odnosnik: Osoba_Dieta (tabela: Osoba)
ALTER TABLE Osoba ADD CONSTRAINT Osoba_Dieta
    FOREIGN KEY (Dieta_ID)
    REFERENCES Dieta (ID);

-- Odnosnik: Osoba_Leczenie (tabela: Leczenie)
ALTER TABLE Leczenie ADD CONSTRAINT Osoba_Leczenie
    FOREIGN KEY (Osoba_ID)
    REFERENCES Osoba (ID);

-- Odnosnik: Osoba_Mieszkanie (tabela: Osoba)
ALTER TABLE Osoba ADD CONSTRAINT Osoba_Mieszkanie
    FOREIGN KEY (Mieszkanie_ID)
    REFERENCES Mieszkanie (ID);

-- Odnosnik: Osoba_Podwladny (tabela: Podwladny)
ALTER TABLE Podwladny ADD CONSTRAINT Osoba_Podwladny
    FOREIGN KEY (Osoba_ID)
    REFERENCES Osoba (ID);

-- Odnosnik: Osoba_Przywodca (tabela: Przywodca)
ALTER TABLE Przywodca ADD CONSTRAINT Osoba_Przywodca
    FOREIGN KEY (Osoba_ID)
    REFERENCES Osoba (ID);

-- Odnosnik: Podwladny_Farmer (tabela: Farmer)
ALTER TABLE Farmer ADD CONSTRAINT Podwladny_Farmer
    FOREIGN KEY (Podwladny_ID)
    REFERENCES Podwladny (Osoba_ID);

-- Odnosnik: Podwladny_Medyk (tabela: Medyk)
ALTER TABLE Medyk ADD CONSTRAINT Podwladny_Medyk
    FOREIGN KEY (Podwladny_ID)
    REFERENCES Podwladny (Osoba_ID);

-- Odnosnik: Podwladny_Wojownik (tabela: Wojownik)
ALTER TABLE Wojownik ADD CONSTRAINT Podwladny_Wojownik
    FOREIGN KEY (Podwladny_ID)
    REFERENCES Podwladny (Osoba_ID);

-- Odnosnik: Przywodca_Podwladny_Przywodca (tabela: Przywodca_Podwladny)
ALTER TABLE Przywodca_Podwladny ADD CONSTRAINT Przywodca_Podwladny_Przywodca
    FOREIGN KEY (Przywodca_ID)
    REFERENCES Przywodca (Osoba_ID);

-- Odnosnik: Przywodca_Przywodca (tabela: Przywodca)
ALTER TABLE Przywodca ADD CONSTRAINT Przywodca_Przywodca
    FOREIGN KEY (Pomocnik_ID)
    REFERENCES Przywodca (Osoba_ID);

-- Odnosnik: Przywodca_Przywodca_Podwladny (tabela: Przywodca_Podwladny)
ALTER TABLE Przywodca_Podwladny ADD CONSTRAINT Przywodca_Przywodca_Podwladny
    FOREIGN KEY (Podwladny_ID)
    REFERENCES Podwladny (Osoba_ID);

-- Odnosnik: Skladnik_Dieta (tabela: Skladnik_Dieta)
ALTER TABLE Skladnik_Dieta ADD CONSTRAINT Skladnik_Dieta
    FOREIGN KEY (Skladnik_ID)
    REFERENCES Skladnik (ID);

-- Odnosnik: Skladnik_Farmer (tabela: Farmer_Skladnik)
ALTER TABLE Farmer_Skladnik ADD CONSTRAINT Skladnik_Farmer
    FOREIGN KEY (Skladnik_ID)
    REFERENCES Skladnik (ID);

-- Odnosnik: Wojownik_Bron (tabela: Wojownik_Bron)
ALTER TABLE Wojownik_Bron ADD CONSTRAINT Wojownik_Bron
    FOREIGN KEY (Wojownik_ID)
    REFERENCES Wojownik (Podwladny_ID);