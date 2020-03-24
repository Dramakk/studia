-- Dawid Żywczak, PGa
-- Zadanie 1
SELECT creationdate FROM posts WHERE body LIKE '%Turing%' ORDER BY 1 DESC;
-- Zadanie 2
SELECT id, title FROM posts WHERE creationdate>'2018-10-10'::date AND EXTRACT(MONTH from creationdate) BETWEEN 9 AND 12 AND title IS NOT NULL AND score>=9 ORDER BY 2;
-- Zadanie 3
SELECT DISTINCT displayname, reputation FROM users JOIN posts ON (users.id=posts.owneruserid) JOIN comments ON (posts.id=comments.postid)
WHERE posts.body LIKE '%deterministic%' AND comments.text LIKE '%deterministic%' ORDER BY 2 DESC;
--Zadanie 4
SELECT DISTINCT WYNIK.displayname FROM
    ((SELECT users.id, users.displayname FROM users JOIN posts ON users.id=posts.owneruserid)
    EXCEPT
    (SELECT users.id, users.displayname FROM users JOIN comments on users.id = comments.userid)) as WYNIK
ORDER BY 1 LIMIT 10;
