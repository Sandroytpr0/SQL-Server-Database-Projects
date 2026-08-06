SELECT ProductID, ProductName
FROM Products
WHERE UnitPrice > ANY (
    SELECT UnitPrice
    FROM Products
    WHERE SupplierID = 3
);
UPDATE Orders
SET ShippedDate = GETDATE ()
WHERE ShipCountry = 'Brazil';

SELECT OrderID, ShippedDate, ShipCountry
FROM Orders
WHERE ShipCountry = 'Brazil';

SELECT OrderID, ShippedDate, ShipCountry
FROM Orders
WHERE ShipCountry = 'Brazil';

SELECT OrderID, ShippedDate, ShipCountry
FROM Orders
WHERE ShipCountry = 'Brazil';

CREATE TABLE TopCustomersPA2(
CustomerID NVARCHAR(5),
Companyname NVARCHAR(40),
OrderCount INT 
);

INSERT INTO TopCustomersPA2 (CustomerID,CompanyName,OrderCount)
SELECT TOP 10
 c.CustomerID,
 c.CompanyName,
 COUNT (o.OrderID) AS ORDERCOUNT
 FROM Customers c
 JOIN ORDERS o ON c.CustomerID = o.CustomerID
 GROUP BY c.CustomerID , c.CompanyName 
 ORDER BY COUNT(o.OrderID ) DESC; 
 SELECT * FROM TopCustomersPA2;