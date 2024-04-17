use classicmodels ; 	

# Question Day3(1)
Select 
customerNumber,customerName,state,creditLimit
from customers
where state is not null and
creditLimit between 50000 and 100000
order by creditLimit desc; 

# Question Day 3(2)
Select  distinct productLine
from products
where productLine like '%cars' ;

# Question Day 4(1)
select orderNumber, status, coalesce(comments, "-") as comments
from orders
where status = "Shipped" ;

# Question Day 4(2)
select employeeNumber, firstName, jobTitle,
CASE 
	when jobTitle = "President" then "P"
    when jobTitle like '%VP%' then 'VP'
    when jobTitle ='Sales Rep'then "SR"
	when jobTitle in ("Sales Manager" or "Sale Manager") then "SM"
    else jobTitle
    end as JobTitleAbbreviation
    from employees;
    
# Question Day5(1)
Select year (paymentDate) as Year, min(amount) as MinAmount
from payments
group by Year
order by Year;

# Question Day5(2)
select concat("Q", Quarter(orderDate)) as Quarter,
year(orderDate) as Year,
count(distinct customerNumber ) as "Unique Customers",
count(*) as TotalOrders 
from orders
group by year, quarter
order by year, quarter;

# Question Day5(3)
select date_format(paymentDate, '%b') as Month,
concat(format(sum(amount)/1000,0),'K') as FormattedAmount
from payments
group by Month
having sum(amount) between 500000 and 1000000
order by sum(amount) desc;

# Question Day6(1)
create table journey (
	Bus_ID int not null,
    Bus_Name varchar(100) not null,
    Source_station varchar(100) not null,
    Destination varchar(100) not null,
    Email varchar(100) unique
    );
    select * from journey;
    
# Question Day6(2)
create table vendor (
	Vendor_ID integer primary key,
    Name varchar(255) not null,
    Email varchar(255) unique,
    Country varchar(255) default 'N/A'
    );
    select * from vendor;
    
# Question Day6(3)
create table movies (
	Movie_ID int primary key,
    Name varchar(255) not null,
    Release_year varchar(10) default '-',
    cast varchar(255) not null,
    Gender enum('Male','Female'),
    No_of_shows integer check (No_of_shows >=0)
    );
    select * from movies;

# Question Day6(4 a)
create table Suppliers (
	Supplier_ID int auto_increment primary key,
    Supplier_name varchar(255),
	Location varchar(255)
    );
    select * from Suppliers;
    
# Question Day6(4 b)
create table Product (
Product_ID int auto_increment primary key,
Product_Name varchar(255) not null unique,
description text,
Supplier_ID int,
foreign key(Supplier_ID) references Suppliers (Supplier_ID)
);
select * from Product;

# Question Day6(4 c)
create table Stock (
	ID int auto_increment primary key,
    Product_ID int,
    Balance_stock int,
    foreign key (Product_ID) references Product (Product_ID)
    );
    select * from Stock;
    
# Question Day7(1)
select employeeNumber,
concat(firstname," ",lastname) as "salesperson",
count(distinct customerNumber) as unique_customers
from employees
left join
customers on 
employeeNumber = salesRepEmployeeNumber
group by
employeeNumber, "salesperson"
order by unique_customers desc ;

# Question Day7(2)
select
customers.customerNumber,
customers.customerName,
products.productCode,
products.productName,
sum(orderdetails.quantityOrdered) as "Order Qty",
sum(products.QuantityInStock) as "Total Inventory",
SUM(products.QuantityInStock - Orderdetails.QuantityOrdered) As 'Left Qty'
FROM
Customers
INNER JOIN
Orders
ON
Customers.CustomerNumber = Orders.CustomerNumber
INNER JOIN
orderdetails
ON Orders.OrderNumber = Orderdetails.OrderNumber
INNER JOIN
Products
ON
Orderdetails.ProductCode = products.productCode
GROUP BY
Customers.CustomerNumber,
Products.ProductCode
ORDER BY
Customers.CustomerNumber asc ;

# Question Day7(3)

create table Laptop(Laptop_Name varchar (30));
INSERT INTO Laptop(Laptop_Name) values
('HP'),
('Acer'),
('Lenovo'),
('Apple'),
('Samsung');

select * from Laptop ;

create table Colours(Colours_Name varchar(30));
insert into Colours (Colours_Name) values
('Black'),
('Gray'),
('White'),
('Red'),
('Blue');

select * from colours;

select Laptop.Laptop_Name, Colours.Colours_Name
from Laptop
cross join colours
order by Colours_Name;

# Question Day7(4)

create table project (
EmployeeID INT PRIMARY KEY,
FullName Varchar (255),
Gender varchar(10),
ManagerID INT 
);
INSERT INTO project (EmployeeID, FullName, Gender, ManagerID)
VALUES
(1, 'Pranaya', 'Male', 3),
(2, 'Priyanka', 'Female', 1),
(3, 'Preety', 'Female', NULL),
(4, 'Anurag', 'Male', 1),
(5, 'Sambit', 'Male', 1),
(6, 'Rajesh', 'Male', 3),
(7, 'Hina', 'Female', 3);

select * from project;    

select p.FullName As 'Manager Name', e.Fullname As 'Emp Name'
from project p
left join project e
ON
p.EmployeeID = e.ManagerID
ORDER BY 'Manager Name' , 'Emp Name';

# Question Day8

CREATE TABLE IF NOT EXISTS facility (
    Facility_ID INT AUTO_INCREMENT PRIMARY KEY,
    Name VARCHAR(255),
    State VARCHAR(255),
    Country VARCHAR(255)
);

ALTER TABLE facility
MODIFY COLUMN Facility_ID INT AUTO_INCREMENT PRIMARY KEY;

ALTER TABLE facility
ADD COLUMN city VARCHAR(255) NOT NULL AFTER Name;

ALTER TABLE facility
DROP COLUMN city;

DESCRIBE facility;

# Question Day 9

drop table University;

CREATE TABLE University (
    ID INT PRIMARY KEY,
    Name VARCHAR(255)
);

INSERT INTO University (ID, Name)
VALUES 
    (1, '       Pune            University     '),
    (2, '   Mumbai      University'),
    (3, '      Delhi  University'),
    (4, 'Madras University'),
    (5, 'Nagpur University');

SELECT * FROM University;

SET sql_safe_updates = 0;

UPDATE University
SET Name = TRIM(BOTH ' ' FROM REGEXP_REPLACE(Name, ' {2,}', ' '))
WHERE ID IS NOT NULL;

SELECT * FROM University;

# Question Day 10

create view products_status As
select
year(O.ORDERDATE) as year ,
concat(
round  (count(od.quantityOrdered *od.priceEach)),
' (',
round ((sum(od.quantityOrdered *od.priceEach) / sum(sum(od.quantityOrdered *od.priceEach)) over ()) *100 ),
'%)' 
) as "total Values"

from orders O
join
orderdetails od
on o.ordernumber = od.ordernumber
group by YEAR(O.ORDERDATE) ;

SELECT * FROM products_status;

# Question Day 11(1)

USE classicmodels;

DELIMITER //

CREATE PROCEDURE GetCustomerLevel (IN cust INT)
BEGIN
    DECLARE lct_credtlimit INT;
    SELECT creditlimit INTO lct_credtlimit FROM Customers WHERE customernumber = cust;
    
    CASE
        WHEN lct_credtlimit > 100000 THEN
            SELECT 'Platinum' AS result;
        WHEN lct_credtlimit BETWEEN 25000 AND 100000 THEN
            SELECT 'Gold' AS result;
        WHEN lct_credtlimit < 25000 THEN
            SELECT 'Silver' AS result;
        ELSE
            SELECT 'Out of range' AS result;
    END CASE;
END //

DELIMITER ;
CALL GetCustomerLevel(103);

# Question Day 11(2)

drop procedure Get_country_payments;
USE classicmodels;

DELIMITER //

CREATE PROCEDURE Get_country_payments (IN inout_year INT, IN input_country VARCHAR(255))
BEGIN
    SELECT
        YEAR(paymentDate) AS Year,
        country AS Country,
        CONCAT(FORMAT(SUM(amount) / 1000, 0), 'k') AS TotalAmount
    FROM Payments
    INNER JOIN Customers ON Payments.customerNumber = Customers.customerNumber
    WHERE YEAR(paymentDate) = inout_year
    AND country = input_country
    GROUP BY Year, Country;
    
END //

DELIMITER ;

CALL Get_country_payments(2003, 'France');

# Question Day 12(1)

WITH X AS (
    SELECT 
        YEAR(ORDERDATE) AS Year,
        MONTHNAME(ORDERDATE) AS Month,
        COUNT(orderdate) AS total_orders
    FROM
        orders
    GROUP BY
        Year, Month
)
SELECT 
    Year,
    Month,
    total_orders AS 'Total Orders',
    CONCAT(
        ROUND(
            100 * ((Total_orders - LAG(Total_orders) OVER (ORDER BY Year)) / LAG(Total_orders) OVER (ORDER BY Year)),
            0
        ),
        '%'
    ) AS "% YoY Changes"
FROM
    X;
    
# Question 12(2)

CREATE TABLE emp_udf (
    Emp_ID INT AUTO_INCREMENT PRIMARY KEY,
    Name VARCHAR(255),
    DOB DATE
);

INSERT INTO emp_udf (Name, DOB)
VALUES 
    ("Piyush", "1990-03-30"),
    ("Aman", "1992-08-15"),
    ("Meena", "1998-07-28"),
    ("Ketan", "2000-11-21"),
    ("Sanjay", "1995-05-21");

SELECT * FROM emp_udf;

DELIMITER //

CREATE FUNCTION calculate_age(date_of_birth DATE) RETURNS VARCHAR(50)
DETERMINISTIC
BEGIN
    DECLARE years INT;
    DECLARE months INT;
    DECLARE age VARCHAR(50);

    SET years = TIMESTAMPDIFF(YEAR, date_of_birth, CURDATE());
    SET months = TIMESTAMPDIFF(MONTH, date_of_birth, CURDATE()) - (TIMESTAMPDIFF(YEAR, date_of_birth, CURDATE()) * 12);

    SET age = CONCAT(years, ' years ', months, ' months');
    RETURN age;
END //

DELIMITER ;

SELECT
    Emp_ID,
    Name,
    DOB,
    calculate_age(DOB) AS age
FROM
    emp_udf;
    
# Question Day 13(1)

SELECT customerNumber, customerName
FROM customers
WHERE customerNumber NOT IN (
SELECT customerNumber
FROM Orders);

# Question Day 13(2)

SELECT c.customerNumber, c.customerName, COUNT(o.ordernumber) AS 'Total Orders'
FROM Customers c
LEFT JOIN Orders o ON c.customerNumber = o.customerNumber
GROUP BY c.customerNumber, c.customerName

UNION
SELECT c.customerNumber, c.customerName, 0 AS 'Total Orders'
FROM Customers c
WHERE c.customerNumber NOT IN (SELECT DISTINCT customerNumber FROM Orders)

UNION
SELECT o.customerNumber, NULL AS customerName, COUNT(o.ordernumber) AS 'Total Orders'
FROM Orders o
WHERE o.customerNumber NOT IN (SELECT DISTINCT customerNumber FROM Customers)
GROUP BY o.customerNumber;

# Question Day 13(3)

SELECT ordernumber , max(quantityOrdered) as quantityOrdered
from orderdetails o
where quantityOrdered <
( select max(quantityOrdered)
from orderdetails od
where od.ordernumber = ordernumber )
group by ordernumber ;

# Question Day 13(4)

select
OrderNumber,
COUNT(OrderNumber) AS Totalproduct
FROM Orderdetails
GROUP BY OrderNumber
Having COUNT(OrderNumber) > 0 ;
SELECT
MAX(Totalproduct) AS 'Max(Total)',
Min(Totalproduct) AS 'Min(Total)'
FROM(
SELECT
OrderNumber,
COUNT(OrderNumber) AS Totalproduct
FROM Orderdetails
GROUP BY OrderNumber
HAVING COUNT(OrderNumber) > 0
) AS ProductCounts;

# Question Day 13(5)

SELECT productLine , count(*) as total
from products
where buyprice
> ( select avg(buyprice)
from products 
)
group by productLine;

# Question Day 14

DELIMITER //

DROP PROCEDURE IF EXISTS Insert_Emp_EH;

CREATE PROCEDURE Insert_Emp_EH (
    IN in_EmpID INT,
    IN in_EmpName VARCHAR(255),
    IN in_EmailAddress VARCHAR(255)
)
BEGIN
    DECLARE error_occurred BOOLEAN DEFAULT FALSE;

    DECLARE CONTINUE HANDLER FOR SQLEXCEPTION
    BEGIN
        SET error_occurred = TRUE;
    END;

    INSERT INTO Emp_EH (EmpID, EmpName, EmailAddress)
    VALUES (in_EmpID, in_EmpName, in_EmailAddress);

    IF error_occurred THEN
        SELECT 'Error occurred' AS Message;
    ELSE
        SELECT 'Values inserted successfully' AS Message;
    END IF;
END //

DELIMITER ;

CALL Insert_Emp_EH(3, 'Yuhangeo', 'geoyuhan8xl@gmail.com');

# Question Day 15

CREATE TABLE Emp_BIT (
    Name VARCHAR(255),
    Occupation VARCHAR(255),
    Working_date DATE,
    Working_hours INT
);

INSERT INTO Emp_BIT VALUES
('Robin', 'Scientist', '2020-10-04', 12),
('Warner', 'Engineer', '2020-10-04', 10),
('Peter', 'Actor', '2020-10-04', 13),
('Marco', 'Doctor', '2020-10-04', 14),
('Brayden', 'Teacher', '2020-10-04', 12),
('Antonio', 'Business', '2020-10-04', 11);

DELIMITER //

CREATE TRIGGER before_insert_Working_hours
BEFORE INSERT ON Emp_BIT
FOR EACH ROW
BEGIN
    IF NEW.Working_hours < 0 THEN
        SET NEW.Working_hours = -NEW.Working_hours;
    END IF;
END //

DELIMITER ;
select * from Emp_BIT;







    



















    
    
    
    



    