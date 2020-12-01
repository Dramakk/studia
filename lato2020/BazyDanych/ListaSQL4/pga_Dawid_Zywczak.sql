-- Dawid Żywczak, pga
-- Zadanie 1
ALTER TABLE comments ADD COLUMN lasteditdate timestamp NOT NULL DEFAULT now();
UPDATE comments SET lasteditdate=creationdate;
CREATE TABLE commenthistory(id SERIAL PRIMARY KEY, commentid INTEGER, creationdate TIMESTAMP, text TEXT);
-- Zadanie 2
CREATE OR REPLACE FUNCTION check_update()
RETURNS TRIGGER AS $X$
    BEGIN
        IF (NEW.id <> OLD.id OR NEW.postid <> OLD.postid OR NEW.lasteditdate <> OLD.lasteditdate) THEN
            RAISE EXCEPTION 'Zmiana niedozwolonych parametrów' USING HINT = 'Próba zmiany id, postid lub lasteditdate';
        END IF;
        NEW.creationdate = OLD.creationdate;
        IF (NEW.text <> OLD.text) THEN
            BEGIN
                NEW.lasteditdate = now();
                INSERT INTO commenthistory (commentid, creationdate, text)
                VALUES(OLD.id, OLD.lasteditdate, OLD.text);
            END;
        END IF;
        RETURN NEW;
    END
$X$ LANGUAGE plpgsql;
CREATE TRIGGER check_update BEFORE UPDATE ON comments FOR EACH ROW EXECUTE PROCEDURE check_update();
-- Zadanie 3
CREATE OR REPLACE FUNCTION set_date()
RETURNS TRIGGER AS $X$
    BEGIN
        NEW.lasteditdate=NEW.creationdate;
        RETURN NEW;
    END
$X$ LANGUAGE plpgsql;
CREATE TRIGGER set_date BEFORE INSERT ON comments FOR EACH ROW EXECUTE PROCEDURE set_date();
