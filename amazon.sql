create database amazon_fresh;
select * from customers;
select * from order_details;
select * from orders;
select * from products;
select * from reviews;
select * from suppliers;
select * from customers where city = 'Bryanton';
select ProductID, ProductName from products where Category = 'fruits';

DROP TABLE customers;

select * from customers where age = 38;

SELECT CustomerID, COUNT(*)
FROM Customers
GROUP BY CustomerID
HAVING COUNT(*) > 1;

ALTER TABLE Customers
ADD CONSTRAINT PK_Customers PRIMARY KEY (CustomerID(50));

ALTER TABLE Customers
MODIFY COLUMN Age INT NOT NULL,
ADD CONSTRAINT CHK_Age CHECK (Age > 18);

SELECT * FROM Customers
WHERE Age IS NULL OR Age <= 18;

UPDATE Customers 
SET Age = 19
WHERE Age IS NULL OR Age <= 18;

SET SQL_SAFE_UPDATES = 0;

UPDATE Customers
SET Age = 19
WHERE Age IS NULL OR Age <= 18;

SET SQL_SAFE_UPDATES = 1;

ALTER TABLE Customers
ADD CONSTRAINT UQ_Name UNIQUE (Name(100));

SELECT * FROM Customers
WHERE Name IS NULL;


SET SQL_SAFE_UPDATES = 0;

SELECT Name, COUNT(*)
FROM Customers
GROUP BY Name
HAVING COUNT(*) > 1;


ALTER TABLE Customers
ADD CONSTRAINT UQ_Name UNIQUE (Name(100));



WITH NameRows AS (
    SELECT 
        CustomerID,
        Name,
        ROW_NUMBER() OVER (PARTITION BY Name ORDER BY CustomerID) AS RowNum
    FROM Customers
)
UPDATE Customers c
JOIN NameRows nr ON c.CustomerID = nr.CustomerID
SET c.Name = CONCAT(nr.Name, '_', nr.RowNum)
WHERE nr.RowNum > 1;


ALTER TABLE Customers ADD CONSTRAINT unique_name UNIQUE (Name(100));


select * from customers where city = 'West Steven';

INSERT INTO Products (ProductID, ProductName,  PricePerUnit, StockQuantity, SupplierID)
VALUES 
(1,NULL,NULL,NULL,NULL),
(2,NULL,NULL,NULL,NULL),
(3,NULL,NULL,NULL,NULL);

select * from products;

UPDATE Products
SET StockQuantity = 350
WHERE ProductID = '2aa28375-c563-41b5-aa33-8e2c2e0f4db9';

DELETE FROM Suppliers
WHERE City = 'Schneidermouth';

ALTER TABLE Reviews
ADD CONSTRAINT chk_rating_range
CHECK (Rating >= 1 AND Rating <= 5);

SELECT * FROM Reviews WHERE Rating < 1 OR Rating > 5;

ALTER TABLE Customers
ALTER PrimeMember SET DEFAULT 0;

SHOW CREATE TABLE Customers;

ALTER TABLE Customers
MODIFY COLUMN PrimeMember VARCHAR(5);

ALTER TABLE Customers
ALTER PrimeMember SET DEFAULT 'No';

SELECT * FROM Orders
WHERE OrderDate > '2024-01-01';

DESCRIBE Orders;

ALTER TABLE Orders
MODIFY COLUMN OrderDate DATETIME;

SELECT p.ProductID, p.ProductName, AVG(r.Rating) AS AverageRating
FROM Products p
JOIN Reviews r ON p.ProductID = r.ProductID
GROUP BY p.ProductID, p.ProductName
HAVING AVG(r.Rating) > 4;

SELECT p.ProductID, p.ProductName, SUM(od.Quantity * od.UnitPrice) AS TotalSales
FROM Products p
JOIN Order_Details od ON p.ProductID = od.ProductID
GROUP BY p.ProductID, p.ProductName
ORDER BY TotalSales DESC;

UPDATE Products p
JOIN Order_Details od ON p.ProductID = od.ProductID
SET p.StockQuantity = p.StockQuantity - od.Quantity;

select * from order_details where orderid is null; 

INSERT INTO Order_Details (OrderID, ProductID, Quantity, UnitPrice, Discount)
VALUES (null,null,null,null,null); 

Select * from products where StockQuantity < 1;

UPDATE Products p
JOIN Order_Details od ON p.ProductID = od.ProductID
SET p.StockQuantity = p.StockQuantity - od.Quantity;
ROLLBACK;

commit;

INSERT INTO Orders (OrderID, CustomerID, OrderDate, OrderAmount, DeliveryFee, DiscountApplied)
VALUES (null,null,null,null,null,null);

select * from orders where orderid is null;

DELETE 
FROM Order_Details
WHERE OrderID IS NULL
LIMIT 5;

START TRANSACTION;
UPDATE Products p
JOIN Order_Details od ON p.ProductID = od.ProductID
SET p.StockQuantity = p.StockQuantity - od.Quantity;
COMMIT;

SELECT 
    o.OrderID,
    o.OrderDate,
    SUM(od.Quantity * od.UnitPrice * (1 - (od.Discount/100))) AS TotalRevenue
FROM 
    Orders o
JOIN 
    Order_Details od ON o.OrderID = od.OrderID
GROUP BY 
    o.OrderID, o.OrderDate
ORDER BY 
    TotalRevenue DESC;
    
SELECT 
    o.CustomerID,
    c.Name,
    COUNT(o.OrderID) AS TotalOrders
FROM 
    Orders o
JOIN 
    Customers c ON o.CustomerID = c.CustomerID
WHERE 
    o.OrderDate = '2025-01-01'  -- Filtering for this specific date
GROUP BY 
    o.CustomerID, c.Name
ORDER BY 
    TotalOrders DESC
LIMIT 10;  


SELECT 
    o.OrderID,
    o.OrderDate,
    SUM(od.Quantity * od.UnitPrice * (1 - (od.Discount/100))) AS TotalRevenue
FROM 
    Orders o
JOIN 
    Order_Details od ON o.OrderID = od.OrderID
WHERE 
    o.OrderID = '1490dbff-1917-4ab6-b829-9787a9b10275'
GROUP BY 
    o.OrderID, o.OrderDate;
    
SELECT 
    s.SupplierID,
    s.SupplierName,
    SUM(p.StockQuantity) AS TotalStock
FROM 
    Suppliers s
JOIN 
    Products p ON s.SupplierID = p.SupplierID
GROUP BY 
    s.SupplierID, s.SupplierName
ORDER BY 
    TotalStock DESC;
    
SELECT SupplierID, StockQuantity FROM Products WHERE StockQuantity IS NOT NULL;

 

SELECT COUNT(*) FROM Suppliers;
SELECT COUNT(*) FROM Products;

SELECT DISTINCT SupplierID FROM Products;
SELECT DISTINCT SupplierID FROM Suppliers;

SELECT 
    s.SupplierID,
    s.SupplierName,
    p.ProductID,
    p.StockQuantity
FROM 
    Suppliers s
JOIN 
    Products p ON s.SupplierID = p.SupplierID;
    
SELECT DISTINCT p.SupplierID
FROM Products p
LEFT JOIN Suppliers s ON p.SupplierID = s.SupplierID
WHERE s.SupplierID IS NULL;

SELECT DISTINCT s.SupplierID
FROM Suppliers s
LEFT JOIN Products p ON s.SupplierID = p.SupplierID
WHERE p.SupplierID IS NULL;

UPDATE Products
SET SupplierID = 'ValidSupplierID'
WHERE SupplierID = 'InvalidSupplierID';

SELECT DISTINCT p.SupplierID
FROM Products p
JOIN Suppliers s ON p.SupplierID = s.SupplierID;

SELECT 
    SupplierID,
    SupplierName,
    TotalStock
FROM 
    Suppliers
ORDER BY 
    TotalStock DESC;
    
SELECT 
    SupplierID,
    SUM(StockQuantity) AS TotalStock
FROM 
    Products
GROUP BY 
    SupplierID
ORDER BY 
    TotalStock DESC
LIMIT 1;

CREATE TABLE ProductCategories (
    ProductID INT PRIMARY KEY, -- Use ProductID as the foreign key
    Category VARCHAR(255) NOT NULL,
    SubCategory VARCHAR(255) NOT NULL
);


INSERT INTO ProductCategories (ProductID, Category, SubCategory)
SELECT ProductID, Category, SubCategory
FROM Products;

select * into ProductCategories from products where 1 = 0;

drop table productcategories;

select * from productcategory;

ALTER TABLE Products
DROP COLUMN Category,
DROP COLUMN SubCategory;

-- Add Foreign Key for ProductID referencing Products table
ALTER TABLE ProductCategory
ADD CONSTRAINT fk_product_id
FOREIGN KEY (ProductID(50)) 
REFERENCES Products(ProductID);


ALTER TABLE ProductCategory
ADD CONSTRAINT fk_category_subcategory
FOREIGN KEY (Category, SubCategory)
REFERENCES Categories(Category, SubCategory);

describe productcategory;

ALTER TABLE ProductCategory
ADD CONSTRAINT fk_ProductID
FOREIGN KEY (ProductID(50))  -- Specify key length (50)
REFERENCES Products(ProductID);


ALTER TABLE productcategory
ADD CONSTRAINT PK_productcategory PRIMARY KEY (ProductID(50));


ALTER TABLE productcategory
ADD CONSTRAINT FK_productcategory FOREIGN KEY (ProductID) REFERENCES Products(ProductID);

ALTER TABLE ProductCategory
ADD CONSTRAINT fk_product_id
FOREIGN KEY (ProductID(50)) 
REFERENCES Products(ProductID);

ALTER TABLE ProductCategory
ADD CONSTRAINT fk_product_id
FOREIGN KEY (ProductID(50)) 
REFERENCES Products(ProductID); 

describe productcategory;

ALTER TABLE Products
ADD PRIMARY KEY (ProductID(50));

SELECT COUNT(ProductID) FROM Products
WHERE ProductID IS NULL;

UPDATE ProductCategory
SET ProductID = 'Unknown'
WHERE ProductID IS NULL;

describe Products;
describe ProductCategory;

ALTER TABLE Productcategory
  MODIFY ProductID TEXT;

UPDATE Products
SET ProductID = 'Unknown'
WHERE ProductID IS NULL;

SELECT ProductID, COUNT(*)
FROM Productcategory
GROUP BY ProductID
HAVING COUNT(*) > 1;

DELETE FROM Products
WHERE ProductID = 'unknown';


SELECT pc.ProductID
FROM ProductCategory pc
LEFT JOIN Products p ON pc.ProductID = p.ProductID
WHERE p.ProductID IS NULL;

SELECT p.ProductID
FROM Products p
LEFT JOIN ProductCategory pc ON   p.ProductID = pc.ProductID
WHERE pc.ProductID IS NULL;

ALTER TABLE ProductCategory
ADD CONSTRAINT fk_product_id
FOREIGN KEY (ProductID(255))
REFERENCES Products(ProductID)
ON DELETE CASCADE
ON UPDATE CASCADE;

ALTER TABLE ProductCategory
MODIFY ProductID VARCHAR(255);

CREATE UNIQUE INDEX idx_product_id ON Products(ProductID);

SELECT pc.ProductID
FROM ProductCategory pc
LEFT JOIN Products p ON pc.ProductID = p.ProductID
WHERE p.ProductID IS NULL;

SHOW CREATE TABLE ProductCategory;

select count(productid) from products;

select count(productid) from productcategory;

CREATE TABLE Product_Category (
    ProductID INT PRIMARY KEY,          
    Category TEXT,                
    SubCategory TEXT,            
    FOREIGN KEY (ProductID) REFERENCES products(ProductID) 
);
select * from products;

SELECT 
    ProductID,
    ProductName,
    TotalRevenue
FROM (
    SELECT 
        p.ProductID,
        p.ProductName,
        SUM(od.Quantity * od.UnitPrice * (1 - (od.Discount/100))) AS TotalRevenue
    FROM 
        Order_Details od
    JOIN 
        Products p ON od.ProductID = p.ProductID
    GROUP BY 
        p.ProductID, p.ProductName
    ORDER BY 
        TotalRevenue DESC
    LIMIT 3
) AS TopProducts;

SELECT 
    c.CustomerID,
    c.Name,
    c.Age,
    c.Gender,
    c.City,
    c.State,
    c.Country,
    c.SignupDate,
    c.PrimeMember
FROM 
    Customers c
LEFT JOIN 
    Orders o ON c.CustomerID = o.CustomerID
WHERE 
    o.OrderID IS NULL;
    
SELECT 
    CustomerID,
    Name,
    Age,
    Gender,
    City,
    State,
    Country,
    SignupDate,
    PrimeMember
FROM 
    Customers
WHERE 
    CustomerID NOT IN (
        SELECT DISTINCT CustomerID FROM Orders WHERE CustomerID IS NOT NULL
    );

SELECT 
    City,
    COUNT(*) AS PrimeMemberCount
FROM 
    Customers
WHERE 
    PrimeMember = 'Yes'
GROUP BY 
    City
ORDER BY 
    PrimeMemberCount DESC;
    
SELECT 
    pc.Category,
    SUM(od.Quantity) AS TotalOrderedQuantity
FROM 
    Order_Details od
JOIN 
    ProductCategory pc ON od.ProductID = pc.ProductID
GROUP BY 
    pc.Category
ORDER BY 
    TotalOrderedQuantity DESC
LIMIT 3;


