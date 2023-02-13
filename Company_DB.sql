DROP DATABASE Company_DB;

CREATE DATABASE IF NOT EXISTS Company_DB;

USE Company_DB;

CREATE TABLE Department (
	Dno INTEGER AUTO_INCREMENT PRIMARY KEY,
	Dname VARCHAR(25) NOT NULL,
	MGRSSN VARCHAR(25) NOT NULL,
	MGRStartDate DATE NOT NULL
);

CREATE TABLE Employee (
	SSN VARCHAR(25) PRIMARY KEY,
	Ename VARCHAR(25) NOT NULL,
	Address VARCHAR(25) NOT NULL,
	Sex CHAR(1) NOT NULL,
	Salary DOUBLE NOT NULL,
	SUPERSSN VARCHAR(25),
	Dno INTEGER,
	FOREIGN KEY (SUPERSSN) REFERENCES Employee(SSN),
	FOREIGN KEY (Dno) REFERENCES Department(Dno)
);

ALTER TABLE Department ADD FOREIGN KEY (MGRSSN) REFERENCES Employee(SSN);

CREATE TABLE Dlocation (
	Dloc VARCHAR(25) NOT NULL,
	Dno INTEGER NOT NULL,
	FOREIGN KEY (Dno) REFERENCES Department(Dno),
	PRIMARY KEY (Dno, Dloc)
);

CREATE TABLE Project (
	Pno INTEGER AUTO_INCREMENT PRIMARY KEY,
	Pname VARCHAR(25) NOT NULL,
	Plocation VARCHAR(25) NOT NULL,
	Dno INTEGER NOT NULL,
	FOREIGN KEY (Dno) REFERENCES Department(Dno)
);

CREATE TABLE WorksOn (
	Hours INTEGER NOT NULL,
	SSN VARCHAR(25) NOT NULL,
	Pno INTEGER NOT NULL,
	FOREIGN KEY (SSN) REFERENCES Employee(SSN),
	FOREIGN KEY (Pno) REFERENCES Project(Pno),
	PRIMARY KEY (SSN, Pno)
);

INSERT INTO Employee (SSN, Ename, Address, Sex, Salary) VALUES
	('ABC01','BEN SCOTT','Bengaluru','M', 450000),
	('ABC02','HARRY SMITH','Bengaluru','M', 500000),
	('ABC03','LEAN BAKER','Bengaluru','M', 700000),
	('ABC04','MARTIN SCOTT','Mysuru','M', 500000),
	('ABC05','RAVAN HEGDE','Mangaluru','M', 650000),
	('ABC06','GIRISH HOSUR','Mysuru','M', 450000),
	('ABC07','NEELA SHARMA','Bengaluru','F', 800000),
	('ABC08','ADYA KOLAR','Mangaluru','F', 350000),
	('ABC09','PRASANNA KUMAR','Mangaluru','M', 300000),
	('ABC10','VEENA KUMARI','Mysuru','M', 1000000);
	-- ('ABC11','DEEPAK RAJ','Bengaluru','M', 500000);

 SELECT * FROM EMPLOYEE;

INSERT INTO Department (Dname, MgrSSN, MgrStartDate) VALUES 
	('SALES','ABC06', 20160103),
	('IT','ABC09', 20170204),
	('HR','ABC08', 20160405),
	('HELPDESK', 'ABC07', 20170603),
	('ACCOUNTS', 'ABC10', 20170108);

SELECT * FROM Department;

UPDATE Employee SET Dno = 5, SuperSSN = 'ABC10' WHERE SSN = 'ABC01';
UPDATE Employee SET Dno = 5, SuperSSN = 'ABC01' WHERE SSN = 'ABC02';
UPDATE Employee SET Dno = 5, SuperSSN = 'ABC02' WHERE SSN = 'ABC03';
UPDATE Employee SET Dno = 5, SuperSSN = 'ABC03' WHERE SSN = 'ABC04';
UPDATE Employee SET Dno = 5, SuperSSN = 'ABC04' WHERE SSN = 'ABC05';
UPDATE Employee SET Dno = 5, SuperSSN = NULL WHERE SSN = 'ABC10';
UPDATE Employee SET Dno = 1, SuperSSN = NULL WHERE SSN = 'ABC06';
UPDATE Employee SET Dno = 2, SuperSSN = NULL WHERE SSN = 'ABC07';
UPDATE Employee SET Dno = 3, SuperSSN = NULL WHERE SSN = 'ABC08';
UPDATE Employee SET Dno = 4, SuperSSN = NULL WHERE SSN = 'ABC09';

SELECT * FROM Employee;

INSERT INTO Dlocation (Dloc, Dno) VALUES
	('Bengaluru', 1),
	('Bengaluru', 2),
	('Mangaluru', 3),
	('Mysuru', 4),
	('Mysuru', 5);

SELECT * FROM Dlocation;


INSERT INTO Project (PName, Plocation, Dno) 
VALUES 
	('IOT','Bengaluru',1),
	('CLOUD','Bengaluru',2),
	('SENSORS','Bengaluru', 3),
	('BANK MANAGEMENT','Bengaluru',5),
	('SALARY MANAGEMENT','Bengaluru',5),
	('OPENSTACK','Bengaluru',4);

SELECT * FROM Project;

INSERT INTO WorksOn (Hours, SSN, PNo) 
VALUES 
	(4, 'ABC02', 4),
	(6, 'ABC02', 5),
	(8, 'ABC01', 4),
	(10, 'ABC01', 5),
	(3, 'ABC03', 1),
	(4, 'ABC06', 2),
	(5, 'ABC07', 3),
	(6, 'ABC04', 4),
	(7, 'ABC05', 5),
	(5, 'ABC08', 6),
	(6, 'ABC09', 1),
	(4, 'ABC10', 2);

SELECT * FROM WorksOn;

-- 1. Make a list of all project numbers for projects that involve an employee whose last name is ‘Scott’, either as a worker or as a manager of the department that controls the project.

SELECT DISTINCT P.Pno
FROM Project P, Department D, Employee E
WHERE E.Dno = D.Dno
AND D.MGRSSN = E.SSN
AND E.Ename LIKE '%SCOTT'
UNION
SELECT DISTINCT P1.Pno
FROM Project P1, WorksOn W, Employee E1
WHERE P1.Pno = W.Pno
AND E1.SSN = W.SSN
AND E1.Ename LIKE '%SCOTT';

-- 2. Show the resulting salaries if every employee working on the ‘IoT’ project is given a 10 percent raise.
SELECT E.Ename, 1.1*E.SALARY AS INCR_SAL
FROM Employee E, WorksOn W, Project P
WHERE E.SSN = W.SSN
AND W.Pno = P.Pno
AND P.Pname = 'IOT';

-- 3. Find the sum of the salaries of all employees of the ‘Accounts’ department, as well as the maximum salary, the minimum salary, and the average salary in this department
SELECT SUM(E.Salary) AS 'Total Salary', MAX(E.Salary) AS 'Maximum Salary', MIN(E.Salary) AS 'Minimum Salary', AVG(E.Salary) AS 'Average Salary' 
FROM Employee E, Department D
WHERE E.Dno = D.Dno
AND D.Dname = 'ACCOUNTS';

-- 4. Retrieve the name of each employee who works on all the projects controlled by department number 5 (use NOT EXISTS operator).
SELECT E.Ename
FROM Employee E
WHERE NOT EXISTS
	(SELECT Pno FROM Project WHERE Dno = 5 AND Pno NOT IN
		(SELECT Pno FROM WorksOn WHERE E.SSN = SSN)
	);

-- 5. For each department that has more than five employees, retrieve the department number and the number of its employees who are making more than Rs. 6,00,000.
SELECT D.Dno, COUNT(*) AS 'Number of Employees'
FROM Department D, Employee E
WHERE D.Dno = E.Dno
AND E.Salary > 600000
AND D.Dno IN 
	(SELECT E1.Dno
		FROM Employee E1
		GROUP BY E1.Dno
		HAVING COUNT(*) > 5
	)
GROUP BY D.Dno;

-- 7. A trigger that automatically updates manager’s start date when he is assigned.
DROP TRIGGER Update_MGRStartDate;
DELIMITER $$
CREATE TRIGGER Update_MGRStartDate
AFTER INSERT ON Department
FOR EACH ROW 
BEGIN
		UPDATE Department
        SET MGRStartDate = CURDATE()
        WHERE Dno = NEW.Dno AND MGRSSN = NEW.MGRSSN;
END;
$$
DELIMITER ;

-- 8. A trigger that prevents the project from being deleted if currently being worked by any employee
DROP TRIGGER PPDE;
DELIMITER $$
CREATE TRIGGER PPDE
	BEFORE DELETE ON Project
	FOR EACH ROW 
	BEGIN
		DECLARE count INTEGER;
        SELECT COUNT(*) INTO count FROM WorksOn WHERE Pno = OLD.Pno;
        IF (count > 0) 
			THEN 
				SIGNAL SQLSTATE '45000'
					SET MESSAGE_TEXT = 'The project details cannot be deleted as employee(s) is/are working on it';
		END IF;
END;
$$
DELIMITER ;

SHOW TRIGGERS;

SELECT * FROM WorksOn;
DELETE FROM Project WHERE PNo = 1;



