DROP DATABASE Insurance_DB;

CREATE DATABASE IF NOT EXISTS Insurance_DB;

USE Insurance_DB;

CREATE TABLE IF NOT EXISTS Person (
	did VARCHAR(15) PRIMARY KEY,
	dname VARCHAR(15) NOT NULL,
	address VARCHAR(15) NOT NULL
);

CREATE TABLE IF NOT EXISTS Car (
	regno VARCHAR(15) PRIMARY KEY,
	model VARCHAR(15) NOT NULL,
	year YEAR NOT NULL
);

CREATE TABLE IF NOT EXISTS Accident (
	reportno INTEGER AUTO_INCREMENT PRIMARY KEY,
	acc_date DATE NOT NULL,
	location VARCHAR(25) NOT NULL
);

CREATE TABLE IF NOT EXISTS Owns (
	did VARCHAR(15) NOT NULL,
	regno VARCHAR(15) NOT NULL,
    FOREIGN KEY(did) REFERENCES Person(did) ON DELETE CASCADE,
    FOREIGN KEY(regno) REFERENCES Car(regno) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS Participated (
	did VARCHAR(15) NOT NULL,
	regno VARCHAR(15) NOT NULL,
	reportno INTEGER NOT NULL,
	damage_amount DOUBLE NOT NULL,
	FOREIGN KEY(did) REFERENCES Person(did)ON DELETE CASCADE,
    FOREIGN KEY(regno) REFERENCES Car(regno)ON DELETE CASCADE,
	FOREIGN KEY(reportno) REFERENCES Accident(reportno) ON DELETE CASCADE
);

INSERT INTO Person (did, dname, address) VALUES
	('D111', 'Smith', 'Kuvempunagar'),
	('D222', 'Aravind', 'JP Nagar'),
	('D333', 'Bhojaraj', 'Udaygiri'),
	('D444', 'Devdas', 'Rajivnagar'),
	('D555', 'Naveen', 'Lakshmipuram');

INSERT INTO Car (regno, model, year) VALUES
	('KA-20-AB-4223', 'Swift', 2020),
	('KA-20-BC-5674', 'WagonR', 2017),
	('KA-09-MA-1234', 'Alto', 2015),
	('KA-21-BD-4728', 'Mazda', 2019),
	('KA-19-CA-6374', 'Tiago', 2018),
    ('KA-20-BC-1234', 'Honda', 2016);

INSERT INTO Accident (acc_date, location) VALUES
	(20200405, 'Nazarbad'),
	(20191216, 'Gokulam'),
	(20200514, 'Vijaynagar'),
	(20210830, 'Kuvempunagar'),
    (20210831, 'TK Layout'),
	(20200121, 'JSS Layout');

INSERT INTO Owns (did, regno) VALUES
	('D444', 'KA-20-AB-4223'),
	('D222', 'KA-20-BC-5674'),
	('D333', 'KA-09-MA-1234'),
	('D111', 'KA-21-BD-4728'),
    ('D111', 'KA-20-BC-1234'),
	('D555', 'KA-19-CA-6374');

INSERT INTO Participated (did, regno, reportno, damage_amount) 
VALUES
	('D444', 'KA-20-AB-4223', 1, 20000),
	('D222', 'KA-20-BC-5674', 2, 10000),
	('D333', 'KA-09-MA-1234', 3, 15000),
	('D111', 'KA-21-BD-4728', 4, 5000),
    ('D111', 'KA-20-BC-1234', 5, 25000),
	('D333', 'KA-19-CA-6374', 6, 25000);

SELECT * FROM Person;
SELECT * FROM Car;
SELECT * FROM Accident;
SELECT * FROM Owns;
SELECT * FROM Participated;

-- 1. Find the total number of people who owned cars that were involved in accidents in 2021.
SELECT COUNT(DISTINCT Person.did) AS 'Number of people'
FROM Person 
JOIN Owns  ON Person.did = Owns.did
JOIN Car ON Owns.regno = Car.regno
JOIN Participated ON Owns.regno = Participated.regno
JOIN Accident ON Participated.reportno = Accident.reportno
WHERE YEAR(Accident.acc_date) = 2021;


-- 2. Find the number of accidents in which the cars belonging to “Smith” were involved.
SELECT dname, COUNT(*) AS 'Number of Accidents' FROM Person
INNER JOIN Participated ON Participated.did = Person.did
WHERE Person.dname = 'Smith';

-- 3. Add a new accident to the database; assume any values for required attributes.
INSERT INTO Accident (acc_date, location) VALUES (20210130, 'Hootgalli');
INSERT INTO Participated (did, regno, reportno, damage_amount) VALUES ('D444', 'KA-20-AB-4223', 7, 5000);

-- 4. Delete the Mazda belonging to “Smith”.
DELETE FROM Owns 
WHERE did = (SELECT did FROM Person WHERE dname = 'Smith')
AND regno = (SELECT regno FROM Car WHERE model = 'Mazda'); 

-- 5. Update the damage amount for the car with license number “KA09MA1234” in the accident with report
UPDATE Participated SET damage_amount = 45000 WHERE regno = 'KA-09-MA-1234';

-- 6. A view that shows models and year of cars that are involved in accident.
DROP VIEW CMY;
CREATE VIEW CMY 
AS
SELECT model, year FROM Car
NATURAL JOIN Participated 
GROUP BY model, year;

SELECT * FROM CMY;

-- 7. A trigger that prevents driver with total damage amount >rs.50,000 from owning a car.
DROP TRIGGER PDOC;
DELIMITER $$
CREATE TRIGGER PDOC
	BEFORE INSERT ON Owns
    FOR EACH ROW
    BEGIN
		IF ((SELECT SUM(damage_amount) FROM Participated WHERE did = NEW.did) > 50000)
        THEN 
			SIGNAL SQLSTATE '45000'
				SET MESSAGE_TEXT = 'Drivers with damage amount greater than 50000 cannot own a car....!';
		END IF;
	END;
$$
DELIMITER ;

INSERT INTO Accident (acc_date, location) VALUES (20211130, 'Hootgalli');
INSERT INTO Participated (did, regno, reportno, damage_amount) VALUES ('D444', 'KA-20-AB-4223', 8, 75000);
INSERT INTO Owns(did, regno) VALUES ('D444', 'KA-20-AB-4223');

-- 8. A trigger that prevents a driver from participating in more than 3 accidents in a given year.
DROP TRIGGER PDPMTA;
DELIMITER $$
CREATE TRIGGER PDPMTA
	BEFORE INSERT ON Participated
    FOR EACH ROW
    BEGIN
		IF ((SELECT COUNT(*) FROM Participated NATURAL JOIN Accident WHERE did = NEW.did AND YEAR(acc_date) = 2021) > 3)
		THEN 
			SIGNAL SQLSTATE '45000'
				SET MESSAGE_TEXT = 'A driver cannot participate in more than 3 accidents in 2021';
		END IF;
	END;
$$
DELIMITER ;

INSERT INTO Accident (acc_date, location) VALUES (20210930, 'Hootgalli');
INSERT INTO Participated (did, regno, reportno, damage_amount) VALUES ('D444', 'KA-20-AB-4223', 9, 7000);

INSERT INTO Accident (acc_date, location) VALUES (20210830, 'Hootgalli');
INSERT INTO Participated (did, regno, reportno, damage_amount) VALUES ('D444', 'KA-20-AB-4223', 10, 7500);

INSERT INTO Accident (acc_date, location) VALUES (20210831, 'Hootgalli');
INSERT INTO Participated (did, regno, reportno, damage_amount) VALUES ('D444', 'KA-20-AB-4223', 11, 7500);
            


    
