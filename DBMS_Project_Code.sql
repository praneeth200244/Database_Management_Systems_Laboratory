CREATE DATABASE IF NOT EXISTS GOODS_TRANSPORT_SERVICE_MANAGEMENT_SYSTEM;

USE GOODS_TRANSPORT_SERVICE_MANAGEMENT_SYSTEM;

CREATE TABLE IF NOT EXISTS Login (
	User_ID VARCHAR(35) PRIMARY KEY,
    LPassword VARCHAR(35) NOT NULL,
    Type_of_User VARCHAR(8) NOT NULL,
    Secret_Key VARCHAR(50) NOT NULL,
    Last_Login_Date DATE,
    Last_Login_Time TIME 
);

INSERT INTO Login (User_ID,LPassword, Type_of_User, Secret_Key, Last_Login_Date, Last_Login_Time) VALUES
	('balachandran1111', 'bala@12chandra34#', 'Driver', 'CAT', 20221129, '18:09:01'), 
	('ravichandran2222', 'ravi@67#chandral', 'Driver', 'DOG', 20221204, '18:30:32'),
	('shettybharath4004', 'bharATh@ShETTY', 'Driver', 'TEACHER', 20221104, '18:45:45'), 
	('poojarysuresh4052', 'surESH#@$%P', 'Driver', 'POSTMAN', 20221109, '18:59:58'),
	('anvsehjain2000', 'jaIN200@', 'Driver', 'AUDI', 20221201, '19:06:35'),
	('abdulfaizal100', 'abFaiZAL@$%', 'Driver','TATA', 20221201, '15:06:32'),
	('mohammedrehman4512', 'rehman@2154', 'Driver', 'MAHINDRA', 20221125,  '16:06:06'),  
	('balakrishna52568', 'KRISHNA568Bala', 'Driver', 'MARUTI SUZUKI', 20221202, '15:06:05'),
	('surendrakumar3452', 'KumaranaSurendra@888', 'Driver', 'COW', 20221201, '16:25:38'),
	('sumanthkjain256397', 'KSUMjain@6789', 'Driver', 'ANT', 20221201, '16:52:36'),
	('decorations1111', 'deco1@34#12', 'Company', 'POSTMAN', 20221104, '18:45:45'), 
	('srinidhiIndus@45621', 'sriNidHI#@1', 'Company', 'ROSE', 20221201, '16:25:38'),
	('ashokglass@4563', 'ah#!@@#glass', 'Company', 'JASMINE', 20221109, '18:59:58'),
	('shubhaPack@sheets', 'sh%^@pack@', 'Company', 'ROSE', 20221129, '18:09:01'),
	('varsha@123#cables', 'asha@#$#123', 'Company', 'CAT',  20221201, '15:06:32'),
	('kamadhenu@coconut125', 'coc@123$nut', 'Company', 'COW', 20221201, '16:25:38'), 
	('reckittBenckiser@#24', 'ben@786ISER', 'Company', 'DOG', 20221109, '18:59:58'), 
	('electric@kirloskar', 'el@123#TRIC', 'Company', 'CAT', 20221125, '16:06:06'), 
	('flavorsltd@#1234', 'varLtd#2%', 'Company', 'COW', 20221204, '18:30:32'), 
	('Iqbal@456#', 'G0@134al', 'Company', 'ROSE', 20221201, '19:06:35');

SELECT * FROM Login;

CREATE TABLE IF NOT EXISTS Driver (
	Driver_ID VARCHAR(15) PRIMARY KEY,
    User_ID VARCHAR(35) NOT NULL,
    D_Name VARCHAR(25) NOT NULL,
    DL_No VARCHAR(18) NOT NULL,
    DOB DATE NOT NULL,
    Age INTEGER NOT NULL,
    Contact_Number LONG NOT NULL,
    Area VARCHAR(35),
    City VARCHAR(35),
    State VARCHAR(25) NOT NULL,
    Pincode INTEGER NOT NULL,
    FOREIGN KEY (User_ID) REFERENCES Login(User_ID) ON DELETE CASCADE 
);

INSERT INTO Driver (Driver_ID, User_ID, D_Name, DL_No, DOB, Age, Contact_Number, Area, City, State, Pincode) VALUES
	('D302734004', 'balachandran1111', 'Balachandran R ', 'KA03 20110006847',19820925, 40, 9856321470, 'Vijayanagar', 'Bangalore', 'Karnataka', 560052),
	('D302734005', 'ravichandran2222', 'Ravichandran R', 'KA32 204500069845', 19860625, 36, 9586321472, 'Jevergi', 'Kalaburgi', 'Karnataka', 587369),
	('D302734006', 'shettybharath4004', 'Bharath Shetty', 'KA11 203658974123', 19800926, 42, 9845632147, 'Pandavpura', 'Mandya', 'Karnataka', 563214),
	('D302734007', 'poojarysuresh4052', 'Suresh Poojary', 'KA21 203695412369', 19850922, 37, 9523146520, 'Kabaka Puttur', 'Puttur', 'Karnataka', 567814),
	('D302734008', 'anvsehjain2000', 'Anvesh Jain', 'KA20 203659874215', 20000112, 20, 9621453012, 'Belvai','Karkala', 'Karnataka', 576214),
	('D302734009', 'abdulfaizal100', 'Abdul', 'KA25 203659874521', 19790525, 43, 9654782130, 'Keshwapur', 'Hubli', 'Karnataka', 580009),
	('D302734010', 'mohammedrehman4512', 'Mohammed Rehman', 'KA25 203659875361', 19800526, 42, 9632145870, 'Byahatti', 'Hubli', 'Karnataka', 580012),
	('D302734011', 'balakrishna52568', 'Balakrishna Jain', 'KA19 203698456321', 19850530, 37, 9654123870, 'Ujire', 'Belthangady', 'Karnataka', 574240),
	('D302734012', 'surendrakumar3452', 'Surendra Kumar', 'KA19 203698453215', 19900531, 32, 9875632140, 'Hosmar', 'Naravi', 'Karnataka', 574242),
	('D302734013', 'sumanthkjain256397', 'Sumanth K', 'KA20 203698756321', 19920626, 30, 9856321470, 'Kota', 'Kundapura', 'Karnataka', 574201);

SELECT * FROM Driver;

CREATE TABLE IF NOT EXISTS Company (
    C_ID VARCHAR(15) PRIMARY KEY,
    User_ID VARCHAR(35) NOT NULL,
    C_Name VARCHAR(50) NOT NULL,
    C_Timings VARCHAR(25),
    C_WebsiteLink VARCHAR(50),
    Contact_Number LONG NOT NULL,
    Area VARCHAR(35),
    City VARCHAR(35),
    State VARCHAR(25) NOT NULL,
    Pincode INTEGER NOT NULL,
    FOREIGN KEY (User_ID) REFERENCES Login(User_ID) ON DELETE CASCADE
); 


INSERT INTO Company (C_ID, User_ID, C_Name, C_Timings, C_WebsiteLink, Contact_Number, Area, City, State, Pincode) VALUES
	('C901652369','decorations1111', 'Decorations Furniture Manufacturers', '09:00 a.m - 06:00 p.m', 'decorations@osiyafurniture.com', 9542368120, 'Hootgalli', 'Mysore', 'Karnataka', 570018),
	('C901652370', 'srinidhiIndus@45621', 'Srinidhi Industries', '09:00 a.m - 05:00 p.m', 'srinidhiIndustries.com', 9456321452, 'Koteshwara', 'Kundapura', 'Karnataka', 576201),
	('C901652371','ashokglass@4563', 'Ashok Glass House', '24/7', 'ashokglassdealers.com', 9632541870, 'Peenya', 'Bangalore', 'Karnataka', 560081),
	('C901652372','shubhaPack@sheets', 'Shubha Plywood Sheets Manufacturers','9:00 a.m - 06:00 p.m','shubhapvtltd.com', 6325987410, 'Belvai', 'Moodbidri', 'Karnataka', 576214),
	('C901652373','varsha@123#cables', 'Varsha Cables Private Limited', '9:00 a.m - 05:00 p.m', 'varshacablespltd.com', 6985236540, 'Parkala', 'Manipal', 'Karnataka', 576104),
	('C901652374','kamadhenu@coconut125', 'Kamadhenu Coconut Industries', '6:30 a.m - 10:30 p.m', 'kamadhenuindustries.com', 6985321470, 'Uppunda', 'Byndoor', 'Karnataka', 576219),
	('C901652375','reckittBenckiser@#24', 'Reckitt And Benckiser Of India Limited', '24/7', 'reckittAndbenckiserpvtld.com', 9563214560, 'Dabhol', 'Ratnagiri', 'Maharashtra', 415612),
	('C901652376','electric@kirloskar', 'Kirloskar Electric Company Limited', '9:00 a.m - 06:00 p.m', 'electricKirloskar.com', 9632587562, 'Mira Road', 'Thane', 'Maharashtra', 400080),
	('C901652377', 'flavorsltd@#1234', 'Flavors And Essences Private Limited', '9:00 a.m - 06:00 p.m', 'essenceFlavorspvtltd.com', 6832594230, 'Alampur', 'Gandhinagar', 'Gujarat', 382002),
	('C601652378','Iqbal@456#', 'Iqbal Packing Industries', '9:00 a.m - 05:00 p.m', 'iqbalPackings.com', 6932865231, 'Sencheri', 'Chennai', 'Tamil Nadu', 600001); 

SELECT * FROM Company;

CREATE TABLE IF NOT EXISTS Vehicle (
	V_RegNo VARCHAR(15) PRIMARY KEY,
    Driver_ID VARCHAR(15) NOT NULL,
    V_Type VARCHAR(25) NOT NULL,
    Permit VARCHAR(15) ,
    No_of_Drivers INTEGER,
    Load_Capacity INTEGER NOT NULL,
    FOREIGN KEY (Driver_ID) REFERENCES Driver(Driver_ID) ON DELETE CASCADE
);


INSERT INTO Vehicle (V_RegNo, Driver_ID, V_Type, Permit, No_of_Drivers, Load_Capacity) VALUES
	('KA 19 P 8488', 'D302734004', 'Tipper', 'AIP', 1, 18),
	('KA 14 A 1478', 'D302734005', 'Truck', 'AIP', 2, 15),
	('MH 10 DV 3465', 'D302734006', 'Tractor Truck', 'AIP', 2, 12),
	('KL 07 CP 7235', 'D302734007', 'Mini Truck', 'Kerala', 2, 15),
	('DL 20 DV 2366', 'D302734008', 'Pickup', 'AIP', 2, 6),
	('MH 12 DV 4353', 'D302734009', 'Container', 'AIP', 2, 22),
	('MH 09 DV 5346', 'D302734010', 'Truck', 'AIP', 1, 15),
	('MH 04 DV 4321', 'D302734011', 'Tipper', 'Maharashtra', 1, 18),
	('TN 26 DQ 5551', 'D302734012', 'Container', 'AIP', 1, 22),
	('GJ 01 XX 1234', 'D302734013', 'Pickup', 'Gujarat', 2, 6);

SELECT * FROM Vehicle;

CREATE TABLE IF NOT EXISTS Orders(
	Order_ID VARCHAR(15) PRIMARY KEY,
    C_ID VARCHAR(15) REFERENCES Company(C_ID),
    V_RegNo VARCHAR(15) REFERENCES Vehicle(V_RegNo),
    Driver_ID VARCHAR(15) REFERENCES Driver(Driver_ID),
    Billing_ID VARCHAR(20),
    Source_Address VARCHAR(30) NOT NULL,
    Destination_Address VARCHAR(30) NOT NULL,
    Load_Size INTEGER NOT NULL,
    Order_Status VARCHAR(10) NOT NULL,
    Via VARCHAR(70)
);


 CREATE TABLE IF NOT EXISTS Bill(
	Billing_ID VARCHAR(20) PRIMARY KEY,
    Transaction_ID VARCHAR(25),
    C_ID VARCHAR(15) REFERENCES Company(C_ID),
    V_RegNo VARCHAR(15) REFERENCES Vehicle(V_RegNo),
    Driver_ID VARCHAR(15) REFERENCES Driver(Driver_ID),
    Order_ID VARCHAR(15) REFERENCES Orders(Order_ID), 
    Hiring_Charges INTEGER NOT NULL,
    Advance_Payment INTEGER
);


CREATE TABLE IF NOT EXISTS Transaction_Details(
	Transaction_ID VARCHAR(25) PRIMARY KEY,
    T_Date DATE NOT NULL,
    T_Time TIME NOT NULL,
    Recipient_Name VARCHAR(25) NOT NULL,
    Recipient_Bank_Name VARCHAR(20) NOT NULL,
    T_Status VARCHAR(10) NOT NULL
);


ALTER TABLE Orders ADD FOREIGN KEY(Billing_ID) REFERENCES Bill(Billing_ID); 
ALTER TABLE Bill ADD FOREIGN KEY(Transaction_ID) REFERENCES Transaction_Details(Transaction_ID);


INSERT INTO Orders(Order_ID, C_ID, V_RegNo, Driver_ID, Source_Address, Destination_Address, Load_Size, Order_Status, Via) VALUES 
	('0123456789O', 'C901652369', 'KA 19 P 8488', 'D302734004', 'Bangalore', 'Baroda', 17, 'IN TRANSIT', 'Hubli-Mumbai'),
	('1234567890O', 'C901652370', 'KA 14 A 1478', 'D302734005','Shimoaga', 'Chennai', 15, 'Completed', 'Mysore'),
	('2345678901O', 'C901652371', 'MH 10 DV 3465', 'D302734006','Thane', 'Trivandrum', 12, 'IN TRANSIT', 'Ratnagiri-Goa-Mangalore'),
	('3456789012O', 'C901652372', 'KL 07 CP 7235', 'D302734007','Ernakulum', 'Kannur', 15, 'Completed', 'Kozhikode'),
	('4567890123O', 'C901652373', 'DL 20 DV 2366', 'D302734008','Delhi_NCR', 'Agra', 6, 'Completed', 'Faridabad'),
	('5678901234O', 'C901652374', 'MH 12 DV 4353', 'D302734009','Khurda', 'Chennai', 22, 'Completed', 'Vishakapattanam'),
	('6789012345O', 'C901652375', 'MH 09 DV 5346', 'D302734010','Mangalore', 'Bangalore', 15, 'Completed', 'Shiradi Ghat'), 
	('7890123456O', 'C901652376', 'MH 04 DV 4321', 'D302734011','Mumbai', 'Thane', 18, 'Completed', 'Borivali'),
	('8901234567O', 'C901652377', 'TN 26 DQ 5551', 'D302734012','Kundapura', 'Mumbai', 22,  'Completed', 'Hubli-Pune'),
	('9012345678O', 'C901652378', 'GJ 01 XX 1234', 'D302734013','Gandhinagar', 'Surat', 6, 'Completed', 'Ahmedabad');


SELECT * FROM Orders;


INSERT INTO Bill (Billing_ID, C_ID, V_RegNo, Driver_ID, Order_ID, Hiring_Charges, Advance_Payment) VALUES
	('B9876543210',  'C901652369', 'KA 19 P 8488', 'D302734004', '0123456789O', 40000, 0),
	('B8765432109',  'C901652370', 'KA 14 A 1478', 'D302734005', '1234567890O', 22000, 12000),
	('B7654321098',  'C901652371', 'MH 10 DV 3465', 'D302734006', '2345678901O', 32000, 10000),
	('B6543210987',  'C901652372', 'KL 07 CP 7235', 'D302734007', '3456789012O', 12000, 0),
	('B5432109876',  'C901652373', 'DL 20 DV 2366', 'D302734008', '4567890123O', 15000 , 0),
	('B4321098765',  'C901652374', 'MH 12 DV 4353', 'D302734009', '5678901234O', 52000, 12000),
	('B3210987654',  'C901652375', 'MH 09 DV 5346', 'D302734010', '6789012345O', 18000, 0),
	('B2109876543',  'C901652376', 'MH 04 DV 4321', 'D302734011', '7890123456O', 10000, 0),
	('B1098765432',  'C901652377', 'TN 26 DQ 5551', 'D302734012', '8901234567O', 36000, 15000),
	('B0987654321',  'C901652378', 'GJ 01 XX 1234', 'D302734013', '9012345678O', 10000, 0);

SELECT * FROM Bill;


INSERT INTO Transaction_details (Transaction_ID, T_Date, T_Time, Recipient_Name, Recipient_Bank_Name, T_Status)VALUES
('TRAN116133', '2022-12-01','16:25:38','Surendra Kumar', 'State Bank of India','Successful'),
('TRAN141161', '2022-11-25','16:06:06','Mohammed Rehman','Union Bank of India','Successful'),
('TRAN151546', '2022-12-02','15:06:05','Balakrishna Jain','Karnataka Bank','Successful'),
('TRAN314113', '2022-12-01','16:52:36','Sumanth K', 'State Bank of India','Successful'),
('TRAN325256', '2022-11-09','18:59:58','Suresh Poojary', 'Karnataka Bank','Successful'),
('TRAN365336', '2022-12-01','19:06:35','Anvesh Jain',  'Union Bank of India','Successful'),
('TRAN369841', '2022-12-01','15:06:32','Abdul', 'State Bank of India','Successful'),
('TRAN582369', '2022-11-29','18:09:01','Balachandran R', 'Karnataka Bank','Successful'),
('TRAN851254', '2022-11-04','18:45:45','Bharath Shetty', 'Union Bank of India','Successful'),
('TRAN856932', '2022-12-04','18:30:32','Ravichandran R', 'State Bank of India','Successful');


SELECT * FROM Transaction_Details;


UPDATE Orders SET Billing_ID = 'B9876543210' WHERE Order_ID = '0123456789O';
UPDATE Orders SET Billing_ID = 'B8765432109' WHERE Order_ID = '1234567890O';
UPDATE Orders SET Billing_ID = 'B7654321098' WHERE Order_ID = '2345678901O';
UPDATE Orders SET Billing_ID = 'B6543210987' WHERE Order_ID = '3456789012O';
UPDATE Orders SET Billing_ID = 'B5432109876' WHERE Order_ID = '4567890123O';
UPDATE Orders SET Billing_ID = 'B4321098765' WHERE Order_ID = '5678901234O';
UPDATE Orders SET Billing_ID = 'B3210987654' WHERE Order_ID = '6789012345O';
UPDATE Orders SET Billing_ID = 'B2109876543' WHERE Order_ID = '7890123456O';
UPDATE Orders SET Billing_ID = 'B1098765432' WHERE Order_ID = '8901234567O';
UPDATE Orders SET Billing_ID = 'B0987654321' WHERE Order_ID = '9012345678O';

SELECT * FROM Orders;

UPDATE Bill SET Transaction_ID = 'TRAN582369' WHERE Billing_ID = 'B9876543210';
UPDATE Bill SET Transaction_ID = 'TRAN856932' WHERE Billing_ID = 'B8765432109';
UPDATE Bill SET Transaction_ID = 'TRAN851254' WHERE Billing_ID = 'B7654321098';
UPDATE Bill SET Transaction_ID = 'TRAN325256' WHERE Billing_ID = 'B6543210987';
UPDATE Bill SET Transaction_ID = 'TRAN365336' WHERE Billing_ID = 'B5432109876';
UPDATE Bill SET Transaction_ID = 'TRAN369841' WHERE Billing_ID = 'B4321098765';
UPDATE Bill SET Transaction_ID = 'TRAN141161' WHERE Billing_ID = 'B3210987654';
UPDATE Bill SET Transaction_ID = 'TRAN151546' WHERE Billing_ID = 'B2109876543';
UPDATE Bill SET Transaction_ID = 'TRAN116133' WHERE Billing_ID = 'B1098765432';
UPDATE Bill SET Transaction_ID = 'TRAN314113' WHERE Billing_ID = 'B0987654321';


SELECT * FROM Bill;


-- Simple queries
-- To get details of users who has chosen CAT as secret key
SELECT * FROM Login WHERE Secret_Key = 'CAT';

-- To get details of drivers with address in Karnataka
SELECT * FROM Driver WHERE State = 'Karnataka';

-- To register new user
INSERT INTO Login (User_ID,LPassword, Type_of_User, Secret_Key, Last_Login_Date, Last_Login_Time) VALUES
	('Sumukesh@#mn', 'sumu@1234#', 'Driver', 'CAT', 20221129, '18:09:01');

SELECT * FROM Login;
    
-- To delete details of user with User_ID is Sumukesh@#mn;
DELETE FROM Login WHERE User_ID = 'Sumukesh@#mn';

SELECT * FROM Login;

-- To rename the field in Driver table
DESC Driver;
ALTER TABLE Driver RENAME COLUMN Pincode to Zipcode;
DESC Driver;
ALTER TABLE Driver RENAME COLUMN Zipcode to Pincode;
DESC Driver;


-- Nested queries
-- To get Billing_ID's with Transaction_ID having Recipient_Bank_Name as State Bank of India
SELECT Bill.Billing_ID 
FROM Bill 
WHERE Transaction_ID IN ( 
	SELECT Transaction_details.Transaction_ID
    FROM Transaction_Details
    WHERE Recipient_Bank_Name = 'State Bank Of India'
);  

-- To get driver name who has registered with Secret_Key as CAT
SELECT Driver.D_Name
FROM Driver
WHERE User_ID IN(
	  SELECT Login.User_ID
	  FROM Login
	  WHERE Secret_Key = 'CAT'
);      


-- To find names of companies which have hired vehicles of more than 19 ton passing load
SELECT Company.C_Name
FROM Company
WHERE Company.C_ID IN(
	  SELECT Orders.C_ID
	  FROM Orders
	  WHERE Orders.Load_Size > 19
);  

-- To find names of drivers who have received hiring charges of more than ₹25000
SELECT Driver.D_Name
FROM Driver
WHERE Driver.Driver_ID IN(
	  SELECT Bill.Driver_ID
	  FROM Bill
	  WHERE Bill.Hiring_Charges > 25000
);  

-- To find contact number(s) of companies which have sent goods to Mumbai
SELECT Company.C_Name
FROM Company
WHERE Company.C_ID IN(
	  SELECT Orders.C_ID
	  FROM Orders
	  WHERE Orders.Destination_Address = 'Mumbai'
);  


-- SET Operations
SELECT User_ID FROM Driver
UNION
SELECT User_ID FROM Company;

SELECT User_ID FROM Driver
INTERSECT
SELECT User_ID FROM Login;

SELECT User_ID FROM Login
EXCEPT
SELECT User_ID FROM Driver;


-- GROUP BY Command
SELECT COUNT(Driver_ID), State
FROM Driver
GROUP  BY State
ORDER BY COUNT(Driver_ID) DESC;

SELECT COUNT(C_ID), City
FROM Company
GROUP BY City
ORDER BY COUNT(C_ID);

-- HAVING Command
SELECT COUNT(Transaction_ID), Recipient_Bank_Name
FROM Transaction_details
GROUP BY Recipient_Bank_Name
HAVING COUNT(Transaction_ID) >= 1;

SELECT COUNT(Permit), Load_Capacity
FROM Vehicle
GROUP BY Load_Capacity
HAVING COUNT(Permit) >= 1;

-- like Clause
-- To get details of vehicles registered in Karnataka 
SELECT * FROM Vehicle WHERE V_RegNo like 'KA%'; 

-- To get details of orders which are in 'IN TRANSIT' state
SELECT * FROM Orders WHERE Order_Status like 'IN%';

-- To get transaction details of order in 'Union Bank of India'
SELECT * FROM Transaction_Details WHERE Recipient_Bank_Name like 'UN%';


-- between clause
-- To get details of vehicles with passing load between 10 ton and 17 ton
SELECT * FROM Vehicle WHERE Load_Capacity BETWEEN 10 AND 17;

-- To get details of drivers aged between 35 and 70
SELECT * FROM Driver WHERE AGE BETWEEN 35 AND 70;

-- To get details of hiring charges between 15000 AND 25000
SELECT * FROM Bill WHERE Hiring_Charges BETWEEN 15000 AND 25000;

-- To create views
CREATE VIEW View_1 AS
SELECT Driver_ID, City
FROM Driver
WHERE Age > 30;

SELECT * FROM View_1;

-- Joins
-- To display names of drivers and secret key chosen by them
SELECT d.D_Name, l.Secret_Key
FROM Driver d
INNER JOIN Login l
ON d.User_Id = l.User_ID;

-- To display names of drivers and secret key chosen by them
SELECT d.D_Name, l.Secret_Key
FROM Driver d INNER JOIN Login l ON d.User_Id = l.User_ID AND l.Last_Login_Date = '20221201';

-- To display names of drivers and their vehicle registration number
SELECT v.V_RegNo, d.D_Name
FROM Vehicle v  JOIN Driver d ON v.Driver_Id = d.Driver_Id AND v.Load_Capacity = 22;


-- To get details of number of orders received by each driver
SELECT 
    D_Name,
    COUNT(*) AS 'Number_of_Orders'
FROM Driver
INNER JOIN Orders
	ON Orders.Driver_ID = Driver.Driver_ID
GROUP BY Driver.Driver_ID
ORDER BY "Number_of_Orders" DESC;

SELECT Driver.D_Name, Orders.Order_ID
FROM Driver
LEFT JOIN Orders ON Driver.Driver_ID = Orders.Driver_ID
ORDER BY Driver.D_Name;

SELECT Vehicle.V_RegNo, Orders.Order_ID
FROM Vehicle
RIGHT JOIN Orders ON Vehicle.V_RegNo = Orders.V_RegNo
ORDER BY Vehicle.V_RegNo;


