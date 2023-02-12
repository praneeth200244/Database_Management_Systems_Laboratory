DROP DATABASE Sailors_DB;

CREATE DATABASE IF NOT EXISTS Sailors_DB;

USE Sailors_DB;

CREATE TABLE IF NOT EXISTS Sailors(
	sid INTEGER AUTO_INCREMENT PRIMARY KEY,
	sname VARCHAR(25) NOT NULL,
	rating INTEGER NOT NULL DEFAULT 0,
	age INTEGER NOT NULL
);

CREATE TABLE IF NOT EXISTS Boats(
	bid INTEGER PRIMARY KEY,
	bname VARCHAR(25) NOT NULL,
	color VARCHAR(25) NOT NULL
);

CREATE TABLE IF NOT EXISTS Reserves(
	sid INTEGER NOT NULL,
	bid INTEGER NOT NULL,
	date DATE NOT NULL,
	FOREIGN KEY(sid) REFERENCES Sailors(sid) ON DELETE CASCADE,
	FOREIGN KEY(bid) REFERENCES Boats(bid) ON DELETE CASCADE,
    CONSTRAINT Unique_Reservation_Data UNIQUE(sid,bid,date)
);

INSERT INTO Sailors (sname,rating,age) 
VALUES 
	('Albert', 7, 45),
	('Aravind', 8, 55),
	('Bhojaraj', 5, 41),
	('Arjun', 10, 40),
	('Sachin', 7, 43),
	('Suraj', 10, 19),
	('Devdas', 9, 60),
	('Naveen', 8, 55),
	('Roopesh', 9, 40);

INSERT INTO Boats (bid, bname, color) 
VALUES
	(101,'Storm','Blue'),
	(102,'Miracle','Pink'),
	(103, 'Grace', 'Green'),
	(104,'Marine','Red');

INSERT INTO Reserves (sid, bid, date)
VALUES
	(2, 101, 20231010),
	(2, 102, 20231010),
	(2, 103, 20230810),
	(2, 104, 20230710),
	(1, 102, 20231011),
	(1, 103, 20231012),
	(3, 103, 20230611),
	(3, 104, 20231211),
	(4, 102, 20230509),
	(5, 102, 20230809),
	(4, 103, 20230809),
	(3, 102, 20231211),
	(3, 102, 20231221);

SELECT * FROM Sailors;

SELECT * FROM Boats;

SELECT * FROM Reserves;

-- 1. Find the colours of boats reserved by Albert
SELECT DISTINCT color FROM Boats
INNER JOIN Reserves ON Boats.bid = Reserves.bid
INNER JOIN Sailors ON Sailors.sid = Reserves.sid
WHERE Sailors.sname = 'Albert';


-- 2. Find all sailor id’s of sailors who have a rating of at least 8 or reserved boat 103
SELECT sid FROM Sailors
WHERE rating >= 8
OR 
sid IN
	(SELECT sid FROM Reserves WHERE bid = 103);  

-- 3. Find the names of sailors who have not reserved a boat whose name contains the string “storm”. Order the names in ascending order.
SELECT DISTINCT sname
FROM Sailors
WHERE sid NOT IN (
  SELECT sid FROM Reserves WHERE bid IN  (
	SELECT bid FROM Boats WHERE bname LIKE '%storm%'
  )
)
ORDER BY sname ASC;

-- 4. Find the names of sailors who have reserved all boats.
SELECT Sailors.sid, sname, COUNT(DISTINCT Reserves.bid) AS Total_boats_Reserved FROM Sailors
INNER JOIN Reserves ON Reserves.sid = Sailors.sid
GROUP BY Reserves.sid
HAVING  Total_boats_Reserved = (SELECT COUNT(*) FROM Boats);

SELECT sname
FROM Sailors
WHERE NOT EXISTS (
  SELECT *
  FROM Boats
  WHERE bid NOT IN (
    SELECT bid
    FROM Reserves
    WHERE sid = Sailors.sid
  )
);

-- 5. Find the name and age of the oldest sailor.
SELECT sname, age FROM Sailors 
WHERE age IN (SELECT MAX(age) FROM Sailors);

-- 6. For each boat which was reserved by at least 5 sailors with age >= 40, find the boat id and the average age of such sailors.
SELECT bid, AVG(age) AS 'Averge age' FROM Sailors
INNER JOIN Reserves ON Reserves.sid = Sailors.sid
WHERE age >= 40
GROUP BY Reserves.bid 
HAVING COUNT(DISTINCT Reserves.sid) >= 5;

-- 7. A view that shows names and ratings of all sailors sorted by rating in descending order.
DROP VIEW SNR;

CREATE VIEW SNR
AS
SELECT sname, rating FROM Sailors;

SELECT * FROM SNR ORDER BY rating DESC;

-- 8. Create a view that shows the names of the sailors who have reserved a boat on a given date.
DROP VIEW SRBD;

CREATE VIEW SRBD
AS
SELECT DISTINCT sname FROM Sailors NATURAL JOIN Reserves WHERE date = '20231211';

SELECT * FROM SRBD;

-- 9. Create a view that shows the names and colours of all the boats that have been reserved by a sailor with a specific rating.
DROP VIEW SNBR;

CREATE VIEW SNBR
AS 
SELECT sname, bname FROM Sailors
NATURAL JOIN Reserves
NATURAL JOIN Boats
WHERE rating = 10;

SELECT * FROM SNBR;

-- 10. A trigger that prevents boats from being deleted if they have active reservations.
DROP TRIGGER ARB;
DELIMITER $$
CREATE TRIGGER ARB
	BEFORE DELETE ON Boats
    FOR EACH ROW
    BEGIN 
		IF OLD.bid IN (SELECT bid FROM Reserves NATURAL JOIN Boats WHERE date > DATE(NOW()))
        THEN 
			SIGNAL SQLSTATE '45000'
				SET MESSAGE_TEXT = 'The boat details you want to delete has active reservations....!';
		END IF;
	END;
$$
DELIMITER ;

DELETE FROM Boats WHERE bid = 102;

-- 11. A trigger that prevents sailors with rating less than 3 from reserving a boat.
DELIMITER $$
CREATE TRIGGER PSRRL
	BEFORE INSERT ON Reserves
    FOR EACH ROW
    BEGIN
		IF NEW.sid IN (SELECT sid FROM Sailors WHERE rating < 3)
        THEN
			SIGNAL SQLSTATE '45000'
				SET MESSAGE_TEXT = 'The sailor cannot reserve boat as he rated below 3';
		END IF;
	END;
$$
DELIMITER ;
INSERT INTO Sailors (sname, rating, age) VALUES ('Khalia', 2, 45);
INSERT INTO Reserves (sid, bid, date) VALUES (10, 104, 20230516);

-- 12. A trigger that deletes all expired reservations.
DROP TRIGGER DER;
DELIMITER $$
CREATE TRIGGER DER
	AFTER INSERT ON Reserves
    FOR EACH ROW
    BEGIN
		DELETE FROM Reserves WHERE date < CURRENT_DATE();
	END;
$$
DELIMITER ;

INSERT INTO Reserves (sid, bid, date) VALUES (1, 104, 19980125);
INSERT INTO Reserves (sid, bid, date) VALUES (2, 104, 20230210);

SELECT * FROM Reserves;
        