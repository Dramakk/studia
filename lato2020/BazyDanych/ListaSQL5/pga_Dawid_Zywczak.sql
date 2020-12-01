-- Dawid Żywczak, pga
-- Zadanie 1
SELECT badges.name AS odznaka, COUNT(posts.id) AS liczba
FROM badges JOIN posts ON(badges.userid = posts.owneruserid)
GROUP BY badges.name
ORDER BY liczba DESC;
-- Zadanie 2
SELECT DISTINCT regexp_matches(text, '(\w{3,})\s+\1[^\w]') FROM (SELECT text FROM comments) as komentarze ORDER BY 1;
-- Zadanie 3
ALTER TABLE users ADD CONSTRAINT klucz UNIQUE (id);
ALTER TABLE posts ADD CONSTRAINT fk_owneruserid FOREIGN KEY (owneruserid) REFERENCES users(id);
SELECT owneruserid FROM posts;
/*
Jako pierwsze rozwiązanie możemy przyjąć stworzenie użytkownika np. "usunięte" o jakimś ujemnym id (innym niż -1), który
przejmowałby komentarze z owneruserid=NULL (bo jak się domyślam taka sytuacja powstaje gdy użytkownik usunie konto).
1. Wady: dodatkowy użytkownik zajmujący ID (które i tak pewnie nie byłoby używane), trzeba się umówić które ID wybieramy
2. Zalety: przejrzystość, nie tracimy żadnej informacji (podobne rozwiązanie chyba stosują na Reddit)
*/
