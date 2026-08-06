USE Northwind;
GO 


CREATE TABLE OrderDetails (
    OrderID INT,
    ProductID INT,
    Quantity INT,
    UnitPrice MONEY
);

INSERT INTO OrderDetails (OrderID, ProductID, Quantity, UnitPrice)
VALUES
    (10248, 11, 12, 14.99),
    (10249, 42, 10, 23.99),
    (10250, 72, 5, 8.99),
    (10251, 65, 8, 15.99),
    (10252, 12, 15, 5.99),
    (10253, 25, 20, 12.49),
    (10254, 33, 25, 18.99),
    (10255, 47, 10, 21.49),
    (10256, 78, 7, 9.49);

CREATE VIEW OrderDetailsExtendedPA2 AS
SELECT 
    OrderID,
    ProductID,
    Quantity,
    Quantity * UnitPrice AS ExtendedPrice
FROM 
    OrderDetails
WHERE 
    Quantity * UnitPrice > (
        SELECT AVG(Quantity * UnitPrice)
        FROM OrderDetails
    );
	SELECT * FROM OrderDetailsExtendedPA2;

