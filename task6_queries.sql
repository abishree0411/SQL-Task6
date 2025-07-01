-- Customers table
CREATE TABLE Customers (
    CustomerID INTEGER PRIMARY KEY,
    Name TEXT,
    City TEXT
);

-- Orders table
CREATE TABLE Orders (
    OrderID INTEGER PRIMARY KEY,
    CustomerID INTEGER,
    OrderDate DATE,
    Amount DECIMAL(10,2),
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID)
);

-- 1. Subquery in SELECT clause (Scalar Subquery)
SELECT 
    Name,
    (SELECT Amount 
     FROM Orders 
     WHERE Orders.CustomerID = Customers.CustomerID 
     ORDER BY OrderDate DESC LIMIT 1) AS LatestOrderAmount
FROM Customers;

-- 2. Subquery in WHERE clause (IN)
SELECT * 
FROM Customers
WHERE CustomerID IN (SELECT DISTINCT CustomerID FROM Orders);

-- 3. Subquery in WHERE clause (EXISTS)
SELECT * 
FROM Customers C
WHERE EXISTS (
    SELECT 1 FROM Orders O 
    WHERE O.CustomerID = C.CustomerID
);

-- 4. Correlated Subquery in WHERE clause
SELECT * 
FROM Orders O1
WHERE Amount > (
    SELECT AVG(Amount) 
    FROM Orders O2 
    WHERE O2.CustomerID = O1.CustomerID
);

-- 5. Subquery in FROM clause
SELECT C.Name, OrderStats.TotalAmount
FROM Customers C
JOIN (
    SELECT CustomerID, SUM(Amount) AS TotalAmount
    FROM Orders
    GROUP BY CustomerID
) AS OrderStats
ON C.CustomerID = OrderStats.CustomerID;

-- Bonus: Nested Subquery Example
SELECT Name
FROM Customers
WHERE CustomerID = (
    SELECT CustomerID 
    FROM Orders 
    WHERE Amount = (SELECT MAX(Amount) FROM Orders)
    LIMIT 1
);
