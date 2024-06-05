-- Skrypty DQL, wyszukujace kombinacje warunkowe rekordow
-- Projekt: Miasto Teotihuacan (Projekt semestralny z przedmiotu RBD)
-- Autor: Maciej Sepeta s30518 19c
-- Baza danych: OracleDB

-- Zapytania z WHERE

-- Zapytanie 1:
-- Wyswietl id farmera, id produktu i produkcje skladnika, ktora jest wieksza lub rowna 5000, posortuj produkcja rosnoca i wyswietl 3 rekordy
SELECT 'Farmer nr. ' || FARMER_ID || ' produkuje ' || PRODUKCJA || ' skladnika nr. ' || SKLADNIK_ID
FROM FARMER_SKLADNIK
WHERE PRODUKCJA >= 5000
ORDER BY PRODUKCJA
FETCH FIRST 3 ROWS ONLY;

-- Zapytanie 2:
-- Wyswietl przywodcow, ktorzy maja pomocnikow
SELECT OSOBA_ID AS Przywodca, POMOCNIK_ID AS Pomocnik
FROM PRZYWODCA
WHERE POMOCNIK_ID IS NOT NULL;

-- Zapytanie 3:
-- Wyswietl nieletnich (<18 lat) mezczyzn i posortuj od malejaco
SELECT ID, IMIE, NAZWISKO, PRZYDOMEK, WIEK
FROM OSOBA
WHERE WIEK < 18 AND PLEC = 'M'
ORDER BY WIEK DESC;

-- Zapytanie 4:
-- Wyswietl osoby, ktorych imie i nazwisko koncza sie na te sama litere
SELECT ID, IMIE, NAZWISKO
FROM OSOBA
WHERE SUBSTR(IMIE, -1) = SUBSTR(NAZWISKO, -1);

-- Zapytanie 5:
-- Wyswietl osoby, ktorych imie zaczyna sie na 'H' lub 'A'
SELECT ID, IMIE, NAZWISKO
FROM OSOBA
WHERE IMIE LIKE 'A%' OR IMIE LIKE 'H%';

-- Zapytania z laczeniem tabel

-- Zapytanie 1:
-- Wyswietl imiona osob, ktore sa farmerami
SELECT IMIE
FROM OSOBA
INNER JOIN FARMER ON OSOBA.ID = FARMER.PODWLADNY_ID;

-- Zapytanie 2:
-- Wyswietl osoby, ktore posiadaja proce
SELECT DISTINCT ID, IMIE
FROM OSOBA
INNER JOIN WOJOWNIK_BRON ON ID = (SELECT PODWLADNY_ID
                                  FROM WOJOWNIK
                                  WHERE PODWLADNY_ID = (SELECT WOJOWNIK_ID
                                                        FROM WOJOWNIK_BRON
                                                        WHERE BRON_ID = (SELECT ID
                                                                        FROM BRON
                                                                        WHERE NAZWA = 'Proca')));

-- Zapytanie 3
-- Wyswietl przydomki wszystkich osob, ktore nie sa przywodcami
SELECT PRZYDOMEK
FROM OSOBA
LEFT JOIN PRZYWODCA ON ID = PRZYWODCA.OSOBA_ID
WHERE OSOBA_ID IS NULL;

-- Zapytanie 4
-- Wyswietl medykow, ktorzy lecza sami siebie oraz ich choroby
SELECT OSOBA_ID, CHOROBA
FROM LECZENIE
INNER JOIN MEDYK ON PODWLADNY_ID = LECZENIE.OSOBA_ID;

-- Zapytanie 5
-- Wyswietl ID i imiona osob, typy ich mieszkan oraz diet
SELECT OSOBA.ID, OSOBA.IMIE, MIESZKANIE.TYP, DIETA.TYP
FROM OSOBA
JOIN MIESZKANIE ON MIESZKANIE_ID = MIESZKANIE.ID JOIN DIETA ON DIETA_ID = DIETA.ID;

-- Zapytania z GROUP BY

-- Zapytanie 1:
-- Wyswietl liczbe mieszkancow dla danego miejsca zamieszkania
SELECT MIESZKANIE_ID, COUNT(ID) AS "Liczba mieszkancow"
FROM OSOBA
GROUP BY MIESZKANIE_ID;

-- Zapytanie 2:
-- Wyswietl srednia produkcje dla danego skladnika malejaco,
-- wyswietlajac tylko te, ktorych srednia produkcja przekracza 9000
SELECT SKLADNIK_ID, AVG(PRODUKCJA) AS "Srednia produkcja"
FROM FARMER_SKLADNIK
GROUP BY SKLADNIK_ID
HAVING AVG(PRODUKCJA) > 9000
ORDER BY AVG(PRODUKCJA) DESC;

-- Zapytanie 3:
-- Wyswietl ilosc mezczyzn i kobiet w osadzie i posortuj malejaco
SELECT PLEC, COUNT(PLEC) AS Ilosc
FROM OSOBA
GROUP BY PLEC
ORDER BY COUNT(PLEC) DESC;

-- Zapytanie 4:
-- Wyswietl laczna ilosc produktow (nie rodzajow) w diecie, wyswietl parzyste ilosci i posortuj rosnaco
SELECT DIETA_ID, SUM(ILOSC) AS "Laczna ilosc"
FROM SKLADNIK_DIETA
GROUP BY DIETA_ID
HAVING MOD(SUM(ILOSC), 2) = 0
ORDER BY SUM(ILOSC);

-- Zapytanie 5:
-- Ilu wojownikow ma bron danego typu i posortuj od najmniej popularnej a nastepnie po ID broni malejaco
SELECT BRON_ID, COUNT(WOJOWNIK_ID) AS "Liczba wojownikow"
FROM WOJOWNIK_BRON
GROUP BY BRON_ID
ORDER BY COUNT(WOJOWNIK_ID), BRON_ID DESC;

-- Zapytania zagniezdzone

-- Zapytanie 1:
-- Znajdz produkty, ktorych ilosc w diecie przekracza srednia ilosc w dietach dla danej diety
SELECT sklad.SKLADNIK_ID, sklad.ILOSC
FROM SKLADNIK_DIETA sklad
WHERE sklad.ILOSC > (SELECT AVG(skladWew.ILOSC)
                        FROM SKLADNIK_DIETA skladWew
                        WHERE sklad.SKLADNIK_ID = skladWew.SKLADNIK_ID);

-- Zapytanie 2:
-- Znajdz osoby, ktore maja identyczna diete jak przywodca bez pomocnika
SELECT ID, DIETA_ID
FROM OSOBA
WHERE DIETA_ID = (SELECT DIETA_ID
                  FROM OSOBA
                  WHERE ID = (SELECT OSOBA_ID
                              FROM PRZYWODCA
                              WHERE POMOCNIK_ID IS NULL));

-- Zapytanie 3:
-- Znajdz produkty, ktorych produkcja przekracza srednia produkcje dla danego farmera
SELECT prod.SKLADNIK_ID, prod.PRODUKCJA
FROM FARMER_SKLADNIK prod
WHERE prod.PRODUKCJA > (SELECT AVG(prodWew.PRODUKCJA)
                        FROM FARMER_SKLADNIK prodWew
                        WHERE prod.FARMER_ID = prodWew.FARMER_ID);

-- Zapytanie 4:
-- Znajdz plec, ktorej przedstawicieli jest wiecej niz kazdej z broni
SELECT PLEC, COUNT(PLEC) AS Ilosc
FROM OSOBA
GROUP BY PLEC
HAVING COUNT(PLEC) > ALL (SELECT COUNT(BRON_ID)
                          FROM WOJOWNIK_BRON
                          GROUP BY BRON_ID);

-- Zapytanie 5:
-- Znajdz produkt, ktorego produkcja jest wieksza od dowolnego zuzycia w diecie razy ilosc dni w kwartale (okolo 90)
SELECT SKLADNIK_ID, PRODUKCJA
FROM FARMER_SKLADNIK
WHERE PRODUKCJA > ANY (SELECT SUM(ILOSC) * 90
                       FROM SKLADNIK_DIETA
                       GROUP BY DIETA_ID);