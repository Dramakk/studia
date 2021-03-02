-- zakładam, że wszystkie zadania uruchamiane są w następującej po sobie sekwencji

CREATE SEQUENCE id_seq;

CREATE TABLE Osoba (
    id INTEGER NOT NULL DEFAULT nextval('id_seq') PRIMARY KEY,
    imie TEXT,
    nazwisko TEXT,
    plec VARCHAR(1),
    miasto TEXT,
    pesel VARCHAR(11) NOT NULL
);

ALTER SEQUENCE id_seq
OWNED BY Osoba.id;

CREATE TABLE Osoba (
    id SERIAL PRIMARY KEY NOT NULL,
    imie TEXT,
    nazwisko TEXT,
    plec VARCHAR(1),
    miasto TEXT,
    pesel VARCHAR(11) NOT NULL
);

INSERT INTO Osoba(imie, nazwisko, plec, pesel) VALUES ('Alicja','Majewska','k', '12345678910');
INSERT INTO Osoba(imie, nazwisko, plec, pesel) VALUES ('Alicja','Majewska','k', '12345678910');
INSERT INTO Osoba(imie, nazwisko, plec, pesel, miasto) VALUES ('Alicja','Majewska','k', '12345678910', 'Wrocław');

SELECT * FROM Osoba WHERE miasto = 'Wrocław';
SELECT imie FROM Osoba WHERE plec = 'k';