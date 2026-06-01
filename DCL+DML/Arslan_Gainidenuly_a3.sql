
-- CINEMA ASSIGNMENT 3 (DCL + DML)
-- Database: cinema

DROP USER IF EXISTS db_reader_user;
DROP ROLE IF EXISTS cinema_readonly;

DROP USER IF EXISTS db_admin_user;
DROP ROLE IF EXISTS cinema_admin;

DROP TABLE IF EXISTS Ticket, ScreeningSeat, FilmGenre, Screening, Seat, Hall, Genre, Film, Client CASCADE;

CREATE TABLE Film (
    film_id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    title VARCHAR(100) NOT NULL,
    duration INT NOT NULL CHECK (duration > 0),
    release_date DATE NOT NULL
);

CREATE TABLE Genre (
    genre_id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    name VARCHAR(50) NOT NULL UNIQUE
);

CREATE TABLE Hall (
    hall_id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    name VARCHAR(50) NOT NULL,
    capacity INT NOT NULL CHECK (capacity > 0)
);

CREATE TABLE Client (
    client_id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    name VARCHAR(100) NOT NULL
);

CREATE TABLE Seat (
    seat_id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    hall_id INT NOT NULL REFERENCES Hall(hall_id),
    seat_number INT NOT NULL,
    UNIQUE (hall_id, seat_number)
);

CREATE TABLE Screening (
    screening_id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    film_id INT NOT NULL REFERENCES Film(film_id),
    hall_id INT NOT NULL REFERENCES Hall(hall_id),
    screening_date DATE NOT NULL CHECK (screening_date > '2026-01-01'),
    screening_time TIME NOT NULL
);

CREATE TABLE FilmGenre (
    film_id INT REFERENCES Film(film_id),
    genre_id INT REFERENCES Genre(genre_id),
    PRIMARY KEY (film_id, genre_id)
);

CREATE TABLE ScreeningSeat (
    screening_seat_id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    screening_id INT REFERENCES Screening(screening_id),
    seat_id INT REFERENCES Seat(seat_id),
    UNIQUE(screening_id, seat_id)
);

CREATE TABLE Ticket (
    ticket_id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    screening_seat_id INT REFERENCES ScreeningSeat(screening_seat_id),
    client_id INT REFERENCES Client(client_id),
    price DECIMAL(8,2) NOT NULL DEFAULT 0 CHECK(price >= 0)
);

CREATE ROLE cinema_admin;
CREATE ROLE cinema_readonly;

GRANT USAGE ON SCHEMA public TO cinema_admin;
GRANT USAGE ON SCHEMA public TO cinema_readonly;

GRANT SELECT, INSERT, UPDATE, DELETE
ON Film, Genre, Hall, Client, Seat, Screening, FilmGenre, ScreeningSeat, Ticket
TO cinema_admin;

GRANT SELECT
ON Film, Genre, Hall, Client, Seat, Screening, FilmGenre, ScreeningSeat, Ticket
TO cinema_readonly;

REVOKE UPDATE, DELETE
ON Film, Genre, Hall, Client, Seat, Screening, FilmGenre, ScreeningSeat, Ticket
FROM cinema_readonly;

CREATE USER db_admin_user WITH PASSWORD 'admin123';
CREATE USER db_reader_user WITH PASSWORD 'reader123';

GRANT cinema_admin TO db_admin_user;
GRANT cinema_readonly TO db_reader_user;

TRUNCATE TABLE Ticket, ScreeningSeat, FilmGenre, Screening, Seat, Client, Hall, Genre, Film
RESTART IDENTITY CASCADE;

INSERT INTO Film(title,duration,release_date) VALUES
('Avatar',162,'2022-12-16'),
('Oppenheimer',180,'2023-07-21'),
('Dune Part Two',166,'2024-03-01'),
('Inside Out 2',100,'2024-06-14'),
('The Batman',176,'2022-03-04');

INSERT INTO Genre(name) VALUES
('Action'),('Drama'),('Sci-Fi'),('Comedy'),('Animation');

INSERT INTO Hall(name,capacity) VALUES
('Hall A',100),('Hall B',120),('Hall C',80),('Hall D',150),('Hall E',90);

INSERT INTO Client(name) VALUES
('Arslan Gainidenovich'),
('Aruzhan Tolegen'),
('Nursultan Aman'),
('Dana Beket'),
('Alina Omarova');

INSERT INTO Seat(hall_id,seat_number) VALUES
((SELECT hall_id FROM Hall WHERE name='Hall A'),1),
((SELECT hall_id FROM Hall WHERE name='Hall A'),2),
((SELECT hall_id FROM Hall WHERE name='Hall B'),1),
((SELECT hall_id FROM Hall WHERE name='Hall C'),1),
((SELECT hall_id FROM Hall WHERE name='Hall D'),1);

INSERT INTO Screening(film_id,hall_id,screening_date,screening_time) VALUES
((SELECT film_id FROM Film WHERE title='Avatar'),(SELECT hall_id FROM Hall WHERE name='Hall A'),'2026-06-10','18:00'),
((SELECT film_id FROM Film WHERE title='Oppenheimer'),(SELECT hall_id FROM Hall WHERE name='Hall B'),'2026-06-11','19:00'),
((SELECT film_id FROM Film WHERE title='Dune Part Two'),(SELECT hall_id FROM Hall WHERE name='Hall C'),'2026-06-12','20:00'),
((SELECT film_id FROM Film WHERE title='Inside Out 2'),(SELECT hall_id FROM Hall WHERE name='Hall D'),'2026-06-13','17:00'),
((SELECT film_id FROM Film WHERE title='The Batman'),(SELECT hall_id FROM Hall WHERE name='Hall E'),'2026-06-14','21:00');

INSERT INTO FilmGenre VALUES
((SELECT film_id FROM Film WHERE title='Avatar'),(SELECT genre_id FROM Genre WHERE name='Sci-Fi')),
((SELECT film_id FROM Film WHERE title='Oppenheimer'),(SELECT genre_id FROM Genre WHERE name='Drama')),
((SELECT film_id FROM Film WHERE title='Dune Part Two'),(SELECT genre_id FROM Genre WHERE name='Sci-Fi')),
((SELECT film_id FROM Film WHERE title='Inside Out 2'),(SELECT genre_id FROM Genre WHERE name='Animation')),
((SELECT film_id FROM Film WHERE title='The Batman'),(SELECT genre_id FROM Genre WHERE name='Action'));

-- UPDATE 1
SELECT * FROM Client WHERE name='Dana Beket';
UPDATE Client
SET name='Dana Beketova'
WHERE name='Dana Beket';

-- UPDATE 2
SELECT * FROM Ticket WHERE price=3500;
UPDATE Ticket
SET price=4000
WHERE price=3500;

-- UPDATE FROM
SELECT t.ticket_id,t.price,f.title
FROM Ticket t
JOIN ScreeningSeat ss ON t.screening_seat_id=ss.screening_seat_id
JOIN Screening s ON ss.screening_id=s.screening_id
JOIN Film f ON s.film_id=f.film_id;

UPDATE Ticket t
SET price=t.price+500
FROM ScreeningSeat ss
JOIN Screening s ON ss.screening_id=s.screening_id
JOIN Film f ON s.film_id=f.film_id
WHERE t.screening_seat_id=ss.screening_seat_id
AND f.title='Avatar';

-- DELETE TEST
BEGIN;
DELETE FROM Ticket
WHERE price > 5000;
SELECT COUNT(*) FROM Ticket;
ROLLBACK;
