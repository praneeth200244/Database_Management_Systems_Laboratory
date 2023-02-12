DROP DATABASE StudentEnrollment_DB;

CREATE DATABASE IF NOT EXISTS StudentEnrollment_DB;

USE StudentEnrollment_DB;

CREATE TABLE IF NOT EXISTS Student (
    regno VARCHAR(25) PRIMARY KEY,
    sname VARCHAR(25) NOT NULL,
    major VARCHAR(25) NOT NULL,
    bdate DATE NOT NULL
);

CREATE TABLE IF NOT EXISTS Course (
    cno INTEGER AUTO_INCREMENT PRIMARY KEY,
    cname VARCHAR(50) NOT NULL UNIQUE,
    dept VARCHAR(25) NOT NULL
);

CREATE TABLE IF NOT EXISTS TextBook (
    ISBN INTEGER AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(50) NOT NULL UNIQUE,
    publisher VARCHAR(50) NOT NULL,
    author VARCHAR(50) NOT NULL
);

CREATE TABLE IF NOT EXISTS Enroll (
    regno VARCHAR(25) NOT NULL,
    cno INTEGER NOT NULL,
    sem INTEGER NOT NULL,
    marks DOUBLE NOT NULL,
    FOREIGN KEY(regno) REFERENCES Student(regno) ON DELETE CASCADE,
    FOREIGN KEY(cno)REFERENCES Course(cno)ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS BookAdoption (
    cno INTEGER NOT NULL,
    sem INTEGER NOT NULL,
    ISBN INTEGER NOT NULL,
	FOREIGN KEY(cno) REFERENCES Course(cno)ON DELETE CASCADE,
	FOREIGN KEY(ISBN) REFERENCES TextBook(ISBN)ON DELETE CASCADE
);

INSERT INTO Student(regno, sname, major, bdate)
VALUES
	('S1', 'Aravind Bolar', 'Computer', 20010515),
	('S2', 'Bhojaraj Vamanjoor', 'Automobiles', 20020610),
	('S3', 'Naveen D Padil', 'Electronics', '20000404'),
	('S4', 'Devdas Kapikad', 'Computer', '20031012'),
	('S5', 'Arjun Kapikad', 'Information Technology', 20011010);

SELECT * FROM Student;

INSERT INTO Course(cname,dept)
VALUES
	('Computer Engineering', 'CS'),
	('DBMS', 'CS'),
	('Electric Power', 'EEE'),
	('Sensors', 'ECE'),
	('Graphics', 'MECH');

SELECT * FROM Course;

INSERT INTO TextBook(title, publisher, author)
VALUES
	('Operating Systems', 'Tata', 'Galvin'),
	('Complete JAVA', 'Tata', 'Patrik Naughton'),
	('Computer Networks', 'Tata', 'Tannenbum'),
	('Compiler Design', 'Tata', 'Ullman'),
	('Database Systems', 'Tata', 'Elmasri Navathe'),
    ('DBMS Reference', 'Tata', 'Elmasri Navathe'),
    ('VLSI Design', 'McGrill', 'Morris Mano'),
    ('Sensors', 'Miracle', 'Illman'),
    ('Electric Power', 'Tata', 'Shankar'); 

SELECT * FROM TextBook;

INSERT INTO Enroll(regno, cno, sem, marks)
VALUES
	('S1', 1, 1, 85),
	('S1', 2, 1, 80),
	('S2', 1, 5, 85),
	('S2', 2, 5, 80),
	('S3', 2, 1, 75),
	('S3', 3, 5, 95),
	('S4', 4, 3, 80),
	('S5', 5, 7, 75);

SELECT * FROM Enroll;

INSERT INTO BookAdoption(cno, sem, ISBN)
VALUES
	(1, 1, 1),
	(1, 1, 2),
	(1, 1, 3),
	(1, 1, 4),
	(2, 2, 5),
    (2, 2, 6),
	(3, 3, 7),
	(4, 4, 8),
	(5, 3, 9);
    
SELECT * FROM BookAdoption;

-- 1. To demonstrate how to add a new textbook to the database and make this book be adopted by some department 
INSERT INTO TextBook(title, publisher, author) VALUES ('Data Communication', 'McGraw Hill', 'Andrew Tannanbum');
INSERT INTO BookAdoption(cno, sem, ISBN) VALUES (1, 7, 10);

-- 2. To produce a list of text books in the alphabetical order for course offered by the 'CS' department that uses more or equal to two books;
SELECT c.cname, b.ISBN, t.title FROM Course c, TextBook t, BookAdoption b
WHERE b.cno = c.cno
AND b.ISBN = t.ISBN
AND c.dept = 'CS'
AND c.cno IN 
	(SELECT cno FROM BookAdoption GROUP BY cno HAVING COUNT(*) >= 2)
ORDER BY c.cname DESC;


-- 3. List any department that has all its adopted books published by a specific publisher.
SELECT dept, publisher FROM Course c, TextBook t, BookAdoption b
WHERE c.cno = b.cno AND b.ISBN = t.ISBN AND publisher = 'Tata'
GROUP BY dept; 

-- 4. List the students who have scored maximum marks in ‘DBMS’ course.
SELECT s.regno, sname, marks FROM Student s, Enroll e, Course c 
WHERE e.cno = c.cno AND e.regno = s.regno 
AND cname = 'DBMS' 
AND marks = (SELECT MAX(marks) FROM Enroll NATURAL JOIN Course WHERE cname = 'DBMS');

-- 5. Create a view to display all the courses opted by a student along with marks obtained.
DROP VIEW DCM;
CREATE View DCM
AS
SELECT sname, cname, marks 
FROM Student
NATURAL JOIN Course
NATURAL JOIN Enroll;

SELECT * FROM DCM;

SHOW TRIGGERS;
-- 6. Create a trigger that prevents a student from enrolling in a course if the marks pre_requisit is less than the given threshold 
DROP TRIGGER PSELTM;
DELIMITER $$
CREATE TRIGGER PSELTM
	BEFORE INSERT ON Enroll
    FOR EACH ROW
    BEGIN
		DECLARE pre_req_course_no INTEGER;
        DECLARE pre_req_marks INTEGER;
        SELECT cno INTO pre_req_course_no FROM Course WHERE cno = (SELECT cno FROM Enroll WHERE regno = NEW.regno AND marks <= 40);
		SELECT marks INTO pre_req_marks FROM Enroll WHERE regno = NEW.regno AND cno = pre_req_course_no;
		IF pre_req_marks < 40
		-- IF NEW.marks < 40
        THEN
			SIGNAL SQLSTATE '45000'
				SET MESSAGE_TEXT = 'Student has not met the pre-requisite marks requirement';
		END IF;
	END;
$$
DELIMITER ;

INSERT INTO Enroll (regno, cno, sem, marks)
VALUES
	('S1', 3, 7, 35);
INSERT INTO Enroll (regno, cno, sem, marks)
VALUES
	('S1', 4, 7, 35);

-- 7. Create a trigger such that it Deletes all records from enroll table when course is deleted.
DROP TRIGGER DRFEC;
DELIMITER $$
CREATE TRIGGER DRFEC
	AFTER DELETE ON Course
	FOR EACH ROW 
	BEGIN
		DELETE FROM Enroll WHERE cno = OLD.cno;
	END;
$$
DELIMITER ;

DELETE FROM Course WHERE cno = 2;

