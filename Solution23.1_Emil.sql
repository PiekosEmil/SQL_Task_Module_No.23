-- Tworzy bazę danych dla potrzeb zadania.
CREATE SCHEMA employees CHARACTER SET utf8mb4 COLLATE utf8mb4_polish_ci
;

-- Tworzy tabelę pracownik(imie, nazwisko, wyplata, data urodzenia, stanowisko). W tabeli mogą być dodatkowe kolumny, które uznasz za niezbędne.
CREATE TABLE employees.employees (
id INT PRIMARY KEY AUTO_INCREMENT,
forename varchar(20),
surname varchar(20),
salary decimal(6, 2),
birth_date date,
title varchar(20)
)
;

-- Wstawia do tabeli co najmniej 6 pracowników
INSERT INTO employees.employees (forename, surname, salary, birth_date, title)
VALUES ('Marek', 'Marecki', 4000.00, '1996-03-22', 'Engineer'),
('Aleksander', 'Toczek', 5000.00, '1989-06-06', 'Junior Manager'),
('Kamil', 'Wczoraj', 4500.00, '1977-12-12', 'Engineer'),
('Emil', 'Nowak', 7000.00, '1990-04-29', 'Manager'),
('Tomasz', 'Urlop', 6000.00, '1999-01-01', 'Accountant'),
('Piotr', 'Krakowiak', 6500.00, '1988-02-02', 'Accountant')
;

-- Pobiera wszystkich pracowników i wyświetla ich w kolejności alfabetycznej po nazwisku
SELECT * FROM employees.employees
ORDER BY surname
;

-- Pobiera pracowników na wybranym stanowisku
SELECT * FROM employees.employees WHERE title = 'Manager'
;

-- Pobiera pracowników, którzy mają co najmniej 30 lat
SELECT * FROM employees.employees WHERE TIMESTAMPDIFF(YEAR, birth_date, CURDATE()) >= 30
;

-- Zwiększa wypłatę pracowników na wybranym stanowisku o 10%
SET SQL_SAFE_UPDATES = 0;
UPDATE employees.employees
SET salary = (salary * 1.1)
WHERE title = 'Junior Manager';
SET SQL_SAFE_UPDATES = 1;
;

-- Pobiera najmłodszego pracowników (uwzględnij przypadek, że może być kilku urodzonych tego samego dnia)
SELECT *
FROM employees.employees
WHERE birth_date = (SELECT max(birth_date) FROM employees.employees)
;

-- Usuwa tabelę pracownik
DROP TABLE employees.employees;

-- Tworzy tabelę stanowisko (nazwa stanowiska, opis, wypłata na danym stanowisku)
CREATE TABLE employees.titles (
id INT PRIMARY KEY AUTO_INCREMENT,
title varchar(50),
description varchar(200),
salary decimal(6, 2)
)
;

-- Tworzy tabelę adres (ulica+numer domu/mieszkania, kod pocztowy, miejscowość)
CREATE TABLE employees.addresses (
id INT PRIMARY KEY AUTO_INCREMENT,
address varchar(50),
postal_code varchar(6),
city varchar(50)
)
;

-- Tworzy tabelę pracownik (imię, nazwisko) + relacje do tabeli stanowisko i adres
CREATE TABLE employees.employees (
forename varchar(20),
surname varchar(20),
address_id INT,
title_id INT,
FOREIGN KEY (address_id) REFERENCES addresses (id),
FOREIGN KEY (title_id) REFERENCES titles (id)
)
;

-- Dodaje dane testowe (w taki sposób, aby powstały pomiędzy nimi sensowne powiązania)
INSERT INTO employees.titles (title, description, salary)
VALUES ('Engineer', 'A person who creates something from nothing', 4500.00),
('Manager', 'A person who controle whole company', 7000.00),
('Accountant', 'A person who calculating profits and losses', 6500.00)
;

INSERT INTO employees.addresses (address, postal_code, city)
VALUES ('ul. Sezamkowa 13', '12-345', 'Milsko'),
('ul. Komornicza 33/2', '67-890', 'Prusice'),
('ul. Wyborcza 1', '09-876', 'Warszawa'),
('ul. Towarowa 60', '54-321', 'Zgorzelec'),
('ul. Druga 2/2', '22-222', 'Butom')
;

INSERT INTO employees.employees (forename, surname, address_id, title_id)
VALUES ('Marek', 'Marecki', 3, 1),
('Martyna', 'Nowak', 1, 2),
('Kamil', 'Wczoraj', 4, 1),
('Emil', 'Nowak', 1, 2),
('Tomasz', 'Urlop', 2, 3),
('Piotr', 'Krakowiak', 5, 3)
;
-- Pobiera pełne informacje o pracowniku (imię, nazwisko, adres, stanowisko)
SELECT forename, surname, address, postal_code, city, title FROM employees.employees e
JOIN employees.addresses a ON e.address_id = a.id
JOIN employees.titles t ON e.title_id = t.id;

-- Oblicza sumę wypłat dla wszystkich pracowników w firmie
SELECT sum(salary) AS 'Sum salaries' FROM employees.employees e
JOIN employees.titles t ON t.id = e.title_id;

-- Pobiera pracowników mieszkających w lokalizacji z kodem pocztowym 90210 (albo innym, który będzie miał sens dla Twoich danych testowych)
SELECT * FROM employees.employees e
JOIN employees.addresses a ON a.id = e.address_id
WHERE postal_code = '12-345';

DROP SCHEMA employees;