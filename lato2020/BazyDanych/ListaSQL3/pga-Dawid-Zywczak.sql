-- Dawid Żywczak, pga
-- Zadanie 1
CREATE VIEW ranking(displayname, liczba_odpowiedzi)
AS
SELECT users.displayname, COUNT(DISTINCT posts1.id)
FROM posts posts1
JOIN posts posts2 ON(posts1.acceptedanswerid = posts2.id)
JOIN users ON (users.id=posts2.owneruserid)
GROUP BY users.id, users.displayname
ORDER BY 2 DESC, 1;
-- Zadanie 2
SELECT users.id, displayname, reputation FROM users JOIN
(SELECT comments.userid as Id, count(comments.id) as Ile
FROM comments JOIN posts ON(posts.id=comments.postid)
WHERE EXTRACT(YEAR FROM posts.creationdate) = 2020
GROUP BY userid HAVING count(comments.id) > 1) as POM ON(users.id=POM.Id)
WHERE upvotes>(SELECT AVG(upvotes) FROM
(SELECT DISTINCT users.id, users.upvotes FROM badges JOIN users ON(badges.userid = users.id)
WHERE badges.name = 'Enlightened') as HE)
AND users.id
NOT IN (SELECT DISTINCT userid from badges WHERE badges.name='Enlightened') ORDER BY creationdate;
-- Zadanie 3
WITH RECURSIVE Uzytkownik(id, displayname) AS (
    (SELECT users.id, displayname FROM users
    JOIN posts ON(users.id=posts.owneruserid)
    WHERE posts.body LIKE '%recurrence%')
    UNION
    (SELECT users.id, users.displayname FROM users
    JOIN comments ON(users.id=comments.userid)
    JOIN posts ON(comments.postid=posts.id)
    JOIN Uzytkownik ON(posts.owneruserid=Uzytkownik.id))
)
SELECT * FROM Uzytkownik;
