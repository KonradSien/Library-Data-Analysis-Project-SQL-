1. Wypisz wszystkie dane na temat wszystkich książek
select * from KSIAZKI

2. Wypisz tytuły wszystkich książek.
select tytul from KSIAZKI

3. Wypisz tytuły wszystkich książek w kolejności alfabetycznej.
select tytul from KSIAZKI
order by tytul

4. Wypisz imiona i nazwiska wszystkich autorów. Posortuj według nazwisk i imion.
select imie, nazwisko from autorzy
order by naziwsko + imie

5.Wypisz wszystkie dane autorów, których nazwisko zaczyna się na literę „B”. Uporządkuj
według nazwisk malejąco.
select * from autorzy 
where nazwisko like 'B%'

6.Wypisz tytuły książek, których tytuł zaczyna się na literę „B”.
select tytul from KSIAZKI
where tytul like 'B%'

7. Wypisz tytuły książek, których tytuł zawiera tekst „danych”.
select tytul ksiazki 
where tytul like '%danych%'

8. Wypisz tytuły książek, których drugą literą tytułu jest „a”.
select tytul from ksiazki 
where tytul like '_a%'

9. Wypisz tytuły książek, których tytuł nie zaczyna się na literę „K” lub ich cena przekracza 50,00 zł.
select tytul from ksiazki
where tytul not like 'K%' or cena >50


10. Wypisz tytuły książek, których tytuł zawiera „baz ” i ich cena nie przekracza 50,00 zł.
select tytul from ksiazki
where tytul  like '%baz%' and cena <=50

11. Wypisz tytuły książek, których tytuł zawiera „baz ” i ich cena jest w przedziale od 25,00 do 50,00 zł.
select tytul from ksiazki
where tytul  like '%baz%' and cena>=25 and cena=<50

12. Wypisz tytuły książek, których tytuł zaczyna się na literę „B”, wydane przez wydawnictwo, którego nazwa zaczyna się od litery „M”.
select tytul from ksiazki K
where tytul like 'B%' and id_wydawnictwa in 
(select id_wydawnictwa from wydawnictwa 
where nazwa like 'M%')

13. Wypisz tytuły i nazwiska autorów wszystkich książek.
SELECT k.tytul, a.nazwisko
FROM KSIAZKI k
INNER JOIN AUTOR_KSIAZKI ak ON k.id_ksiazki = ak.id_ksiazki
INNER JOIN AUTORZY a ON ak.id_autora = a.id_autora;

14. Wypisz tytuły (bez powtórzeń) książek, które zostały wypożyczone 19 kwietnia 1998.
select distinct k.tytul  from ksiazki k 
inner join egzemplarze e on k.id_ksiazki=e.id_ksiazki
inner join wypozyczenia w on e.id_egzemplarza=w.id_egzemplarza
where data_wypozyczenia={d'1998-04-19'}

15. Wypisz tytuły (bez powtórzeń) książek, które zostały wypożyczone Fifeckiemu w dniu 27 lutego 1998
select distinct tytul from ksiazki
inner join egzemplarze e on k.id_ksiazki=e.id_ksiazki
inner join wypozyczenia w on e.id_egzemplarza=w.id_egzemplarza
inner join czytelnicy c on w.id_czytelnika=c.id_czytelnika
where nazwisko='Fifecki' and data_wypozyczenia={ d '1998-02-27'}

16. Dla każdej książki zwróć tytuł i liczbę autorów. Uporządkuj po liczbie autorów (malejąco)
a następnie po tytule (rosnąco).
select k.tytul, count(ak.id_autora) AS ilosc_autorow from KSIAZKI k 
LEFT join AUTOR_KSIAZKI ak on k.id_ksiazki=ak.id_ksiazki
GROUP BY k.tytul
ORDER BY ilosc_autorow DESC

17. Wypisz tytuły książek, które mają więcej niż jednego autora.
select k.tytul, count(ak.id_autora) AS ilosc_autorow from KSIAZKI k
LEFT join AUTOR_KSIAZKI ak on k.id_ksiazki=ak.id_ksiazki
GROUP BY k.tytul
 HAVING COUNT(ak.id_autora) > 1
ORDER BY ilosc_autorow DESC


18. Podaj średnią cenę książek dla każdego wydawnictwa.
select w.nazwa, avg(w.cena) from ksiazki k 
inner join wydawnictwa w on k.id_wydawnictwa=w.id_wydawnictwa
groupby

19. Znajdź książki o najniższej cenie.
SELECT tytul, cena
FROM ksiazki
WHERE cena = (SELECT MIN(cena) FROM ksiazki);


20. Znajdź dla każdego wydawnictwa książkę o najniższej cenie (wydanej przez to wydawnictwo).
select w.nazwa, min(k.cena) from ksiazki k
right join wydawnictwa w on k.id_wydawnictwa=w.id_wydawnictwa
group by w.nazwa 



21. Znajdź wydawnictwa, które wydały więcej książek niż wynosi średnia wydanych książek.
select Nazwa,1.0*count(KSIAZKI.id_ksiazki) as średnia_wydawnictwa ,1.0*((select count(*) from KSIAZKI)/(select count(*) from WYDAWNICTWA)) as średnia_ogólna from WYDAWNICTWA
inner join KSIAZKI
on KSIAZKI.id_wydawnictwa=WYDAWNICTWA.id_wydawnictwa
group by WYDAWNICTWA.id_wydawnictwa, WYDAWNICTWA.Nazwa
having count(KSIAZKI.id_ksiazki)> (select count(*) from KSIAZKI)/ (select count(*) from WYDAWNICTWA) 


22. Usuń wszystkie książki, których tytuł zaczyna się na literę „A” przy pomocy instrukcji DELETE.

--zawsze warto wykonać operacje usuwania w transakcji, aby móc cofnąć zmiany w razie potrzeby:
BEGIN TRANSACTION;

DELETE FROM ksiazki
WHERE tytul LIKE 'A%';

-- Sprawdzamy, czy wszystko jest w porządku przed zatwierdzeniem
COMMIT;
-- Lub w przypadku problemów, cofamy zmiany za pomoca:
-- ROLLBACK;

23. Zwiększ cenę wszystkich książek o 10%.
update ksiazki
set cena=cena*1.1