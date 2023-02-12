DROP DATABASE OrderProcessing_DB;

CREATE DATABASE IF NOT EXISTS OrderProcessing_DB;

USE OrderProcessing_DB;

CREATE TABLE IF NOT EXISTS Customer (
    cust INTEGER AUTO_INCREMENT PRIMARY KEY,
    cname VARCHAR(15) NOT NULL,
    city VARCHAR(15) NOT NULL
);


CREATE TABLE IF NOT EXISTS Orders (
    oid INTEGER PRIMARY KEY AUTO_INCREMENT,
    odate DATE NOT NULL,
    order_amt DOUBLE,
    cust INTEGER NOT NULL,
    FOREIGN KEY(cust) REFERENCES Customer(cust) ON DELETE CASCADE    
);

CREATE TABLE IF NOT EXISTS Item (
    iid INTEGER PRIMARY KEY AUTO_INCREMENT,
    unit_price DOUBLE NOT NULL
);

CREATE TABLE IF NOT EXISTS Warehouse (
    wid INTEGER PRIMARY KEY AUTO_INCREMENT,
    city VARCHAR(25) NOT NULL,
    CONSTRAINT unique_id_city UNIQUE(wid,city)
);

CREATE TABLE IF NOT EXISTS Order_item (
    oid INTEGER NOT NULL,
    iid INTEGER NOT NULL,
    qty INTEGER NOT NULL DEFAULT 1,
    FOREIGN KEY(oid) REFERENCES Orders(oid) ON DELETE CASCADE,
	FOREIGN KEY(iid) REFERENCES Item(iid) ON DELETE CASCADE   
);
DROP TABLE Shipment;
CREATE TABLE IF NOT EXISTS Shipment (
    oid INTEGER NOT NULL,
    wid INTEGER NOT NULL,
    shipdate DATE NOT NULL,
    FOREIGN KEY(oid) REFERENCES Orders(oid) ON DELETE CASCADE,
	FOREIGN KEY(wid) REFERENCES Warehouse(wid) ON DELETE CASCADE
);

INSERT INTO Customer(cname,city)
VALUES
	('Ashok', 'Mysuru'),
	('Suresh', 'Bengaluru'),
	('Anand', 'Mumbai'),
	('Pinto', 'Dehli'),
	('Sheetal', 'Bengaluru');
    
SELECT * FROM Customer;

INSERT INTO Orders (odate,cust)
VALUES
	(20200114, 1),
	(20210413, 2),
	(20191002, 5),
	(20190512, 3),
	(20201223, 4);
    
SELECT * FROM Orders;

INSERT INTO Item (unit_price)
VALUES
	(4000),
	(2000),
	(1000),
	(3000),
	(5000);

SELECT * FROM Item;

INSERT INTO Warehouse (city) 
VALUES
	('Mysuru'),
	('Bengaluru'),
	('Mumbai'),
	('Dehli'),
	('Chennai');

SELECT * FROM Warehouse;

INSERT INTO Order_Item (oid,iid,qty)
VALUES 
	(1, 1, 5),
	(2, 5, 1),
	(3, 2, 5),
	(4, 3, 1),
	(5, 4, 12);

SELECT * FROM Order_Item;
SELECT * FROM Orders;

INSERT INTO Shipment (oid, wid,shipdate)
VALUES
	(1, 2, 20200116),
	(2, 1, 20210414),
	(3, 4, 20191007),
	(4, 3, 20190516),
	(5, 5, 20201223);

SELECT * FROM Shipment;


-- 1. List the order# aand ship_date for all orders shipped from warehouse# 'w2'
INSERT INTO Shipment(oid, wid, shipdate) VALUES (5, 2, 20201206);
SELECT oid,shipdate FROM Shipment WHERE wid = 2;

-- 2. List the warehouse information from which the customer named 'Ashok' was supplied his orders. Produce a listing of order#,warehouse#
INSERT INTO Orders (odate, cust) VALUES (20200512, 1 );
INSERT INTO Order_Item (oid, iid, qty) VALUES (6, 5, 15);
INSERT INTO Shipment(oid, wid, shipdate) VALUES (6, 1, 20201206);

SELECT cname, Orders.oid, Warehouse.wid, Warehouse.city FROM Shipment
INNER JOIN Warehouse ON Shipment.wid = Warehouse.wid
INNER JOIN Orders ON Orders.oid = Shipment.oid
INNER JOIN Customer ON Orders.cust = Customer.cust
WHERE cname = 'Ashok';

-- 3. Produce a listing: cname,number of orders,average order amount
SELECT cname, COUNT(Orders.cust) AS 'number of orders', AVG(order_amt) AS 'average order amount' FROM Customer
INNER JOIN Orders ON Orders.cust = Customer.cust
GROUP BY Orders.cust;

-- 4. Find a item with maximum unit price
SELECT CONCAT('Item with id-',iid) AS 'Item with maximum unit price', unit_price FROM Item
WHERE unit_price = (SELECT MAX(unit_price) FROM Item); 

-- 5. Create a view to display orderID and shipment date of all orders shipped from a warehouse 2.
DROP VIEW OSW2;
CREATE VIEW OSW2
AS 
SELECT oid, shipdate FROM Shipment
WHERE wid = 5;

SELECT * FROM OSW2;

-- 6. Delete all records for customer named 'Ashok'
DELETE FROM Customer WHERE cname = 'Ashok';

-- 7. Trigger that prevents warehouse details from being deleted if any item is shipped from that warehouse
DROP TRIGGER PWDS;

DELIMITER $$
CREATE TRIGGER PWDS
	BEFORE DELETE ON Warehouse
    FOR EACH ROW
    BEGIN 
		IF OLD.wid IN (SELECT wid FROM Shipment NATURAL JOIN Warehouse)
			THEN
					SIGNAL SQLSTATE '45000'
					SET MESSAGE_TEXT = 'An item is shipped from this warehouse....!';
		END IF;
	END;
$$
DELIMITER ;

DELETE FROM Warehouse WHERE wid = 2;

-- 8. A tigger that updates order_amount based on quantity and unit price of order_item.
DELIMITER $$
CREATE TRIGGER UOA
	AFTER INSERT ON Order_item
    FOR EACH ROW
    BEGIN
		UPDATE Orders SET order_amt = (SELECT SUM(Item.unit_price * Order_item.qty) FROM Order_item, Item
											WHERE Order_item.iid = Item.iid
                                            AND Order_item.oid = Orders.oid
										)
									WHERE oid = NEW.oid;
	END;
$$
DELIMITER ;

-- 9. A trigger that prevents orders with total value greater than Rs.100000 from being placed
DROP TRIGGER POBP;
DELIMITER $$
CREATE TRIGGER POBP
	BEFORE INSERT ON Orders
    FOR EACH ROW
    BEGIN
		DECLARE total_amount DOUBLE;
        SELECT SUM(unit_price * qty) INTO total_amount FROM Order_item
        WHERE oid = NEW.oid;
        IF (total_amount > 100000)
			THEN
				SIGNAL SQLSTATE '45000'
					SET MESSAGE_TEXT = 'Orders of total amount greater than Rs.100000 cannot be placed....!';
		END IF;
	END;
$$
DELIMITER ;
			

