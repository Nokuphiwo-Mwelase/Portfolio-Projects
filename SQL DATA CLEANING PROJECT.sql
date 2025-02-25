CREATE DATABASE SQL_DATA_CLEANING_PROJECT;
USE SQL_DATA_CLEANING_PROJECT;

CREATE TABLE SALES(
SaleID INT PRIMARY KEY, 
SaleDate DATETIME, 
CustomerName VARCHAR(100), 
ProductName VARCHAR(100), 
Quantity INT, 
Price DECIMAL(10, 2), 
TotalAmount DECIMAL(10, 2), 
Region VARCHAR(50)
);

INSERT INTO SALES(SaleID, SaleDate, CustomerName, ProductName, Quantity, Price, TotalAmount, Region) VALUES
(1, '2023-01-15 10:30:00', 'John Doe', 'Laptop', 1, 1200.00, 1200.00, 'North'),
(2, '2023-01-16 11:00:00', 'Jane Smith', 'Phone', 2, 800.00, 1600.00, 'South'),
(3, '2023-01-17 12:00:00', NULL, 'Tablet', 1, 500.00, 500.00, 'East'),
(4, '2023-01-18 09:00:00', 'John Doe', 'Laptop', 1, 1200.00, 1200.00, 'North'),
(5, '2023-01-19 14:00:00', 'Alice Brown', 'Monitor', NULL, 300.00, NULL, 'West');

##CHECKING FOR DATA ISSUES##

#MISSING VALUES

SELECT *
FROM SALES
WHERE SaleDate IS NULL
	OR CustomerName IS NULL
    OR Quantity IS NULL
    OR TotalAmount IS NULL;

#DUPLICATES

SELECT SaleID, COUNT(*)
FROM SALES
GROUP BY SaleID
HAVING COUNT(*) > 1;

#INCONSISTANCES

SELECT DISTINCT Region
FROM SALES;

#INVALID DATA

SELECT *
FROM SALES
WHERE Quantity < 0 OR Price < 0;

##DATA CLEANING##

#FILLING IN MISSING VALUES

UPDATE SALES
	SET CustomerName = 'Unknown'
    WHERE CustomerName IS NULL
    AND SaleID > 0;
    
UPDATE SALES
	SET Quantity = 0
    WHERE Quantity IS NULL
    AND SaleID > 0;
    
UPDATE SALES
	SET TotalAmount = Quantity * Price
    WHERE TotalAmount IS NULL
    AND SaleID > 0;
    
SELECT * FROM SALES;

#REMOVING DUPLICATES

SELECT SaleDate, CustomerName, ProductName, COUNT(*)
FROM SALES
GROUP BY SaleDate, CustomerName, ProductName
HAVING COUNT(*) > 1;

#STANDARDIZING DATA

UPDATE SALES
	SET Region = 'North'
    WHERE Region = 'north'
    AND SaleID > 0;
    
#FIXING INVALID DATA

UPDATE SALES
	SET Quantity = 0
    WHERE Quantity < 0
    AND SaleID > 0;
    
    UPDATE SALES
    SET Price = 0
    WHERE Price < 0
    AND SaleID > 0;

##VALIDATION##

SELECT *
FROM SALES
WHERE SaleDate IS NULL
	OR CustomerName IS NULL
    OR Quantity IS NULL
    OR TotalAmount IS NULL;
    
SELECT SaleDate, CustomerName, ProductName, COUNT(*)
FROM SALES
GROUP BY SaleDate, CustomerName, ProductName
HAVING COUNT(*) > 1;

SELECT DISTINCT Region
FROM SALES;

#CLEAN DATA#

CREATE TABLE CLEANED_SALES AS
SELECT *
FROM SALES;