-- Dawid Żywczak, pga
-- Zadanie 1 --
SELECT u.id, u.displayname, u.reputation, COUNT(DISTINCT posts.id) FROM users u
JOIN posts ON u.id=owneruserid
JOIN postlinks ON postlinks.postid=posts.id
WHERE linktypeid=3 
AND relatedpostid IN
(SELECT id FROM posts)
GROUP BY u.id, u.displayname, u.reputation
ORDER BY COUNT DESC, displayname
limit 20;

-- Zadanie 2 --
SELECT users.id, users.displayname, users.reputation, count(comments.id), avg(comments.score)
FROM users
    JOIN badges ON users.id = badges.userid
    JOIN posts ON users.id = posts.owneruserid
    LEFT JOIN comments ON posts.id = comments.postid
WHERE badges.name = 'Fanatic'
GROUP BY users.id, users.displayname, users.reputation
HAVING count(comments.id) <= 100
ORDER BY count(comments.id) DESC, users.displayname
LIMIT 20;

-- Zadanie 3 --
ALTER TABLE users ADD PRIMARY KEY (id);
ALTER TABLE badges ADD CONSTRAINT userid_fkey FOREIGN KEY (userid) REFERENCES users (id);
ALTER TABLE posts DROP COLUMN viewcount;
DELETE FROM posts WHERE body='' OR body IS NULL;

-- Zadanie 4 --
CREATE SEQUENCE comment_id;
SELECT setval('comment_id',max(posts.id))
FROM posts;
ALTER TABLE posts ALTER COLUMN id
SET DEFAULT nextval('comment_id');
ALTER SEQUENCE comment_id OWNED BY posts.id;

INSERT INTO posts (posttypeid, parentid, owneruserid, body, score, creationdate)
SELECT 3, postid, userid, text, score, creationdate FROM comments;
