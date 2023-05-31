-- Stored procedure to retrieve customer details by ID
CREATE PROCEDURE GetCustomerByID
    @CustomerID INT
AS
BEGIN
    SELECT * FROM Customers WHERE CustomerID = @CustomerID;
END

-- Stored procedure to insert a new customer
CREATE PROCEDURE InsertCustomer
    @CustomerName VARCHAR(50),
    @Email VARCHAR(100),
    @Phone VARCHAR(15)
AS
BEGIN
    INSERT INTO Customers (CustomerName, Email, Phone)
    VALUES (@CustomerName, @Email, @Phone);
END

-- Stored procedure to update customer information
CREATE PROCEDURE UpdateCustomer
    @CustomerID INT,
    @NewPhone VARCHAR(15)
AS
BEGIN
    UPDATE Customers
    SET Phone = @NewPhone
    WHERE CustomerID = @CustomerID;
END

-- Stored procedure to calculate total sales by customer
CREATE PROCEDURE GetTotalSalesByCustomer
AS
BEGIN
    SELECT C.CustomerID, C.CustomerName, SUM(O.TotalAmount) AS TotalSales
    FROM Customers C
    JOIN Orders O ON C.CustomerID = O.CustomerID
    GROUP BY C.CustomerID, C.CustomerName;
END

-- Stored procedure to delete a customer and associated orders
CREATE PROCEDURE DeleteCustomer
    @CustomerID INT
AS
BEGIN
    BEGIN TRANSACTION;
    
    BEGIN TRY
        DELETE FROM Orders WHERE CustomerID = @CustomerID;
        DELETE FROM Customers WHERE CustomerID = @CustomerID;
        
        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        PRINT 'Error occurred: ' + ERROR_MESSAGE();
    END CATCH
END
