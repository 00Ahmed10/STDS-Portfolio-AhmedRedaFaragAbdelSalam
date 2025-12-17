CREATE VIEW [dbo].[vw_FactSales]
AS
SELECT 
    SOD.SalesOrderDetailID,
    SOD.SalesOrderID,
    SOH.OrderDate,
    SOH.DueDate,
    SOH.ShipDate,
    SOH.Status AS StatusId,
    SOH.SalesPersonID,
    SOH.CustomerID,
    SOH.TerritoryID,
    SOH.ShipMethodID,
    SOH.OnlineOrderFlag,
    SOD.ProductID,
    
  
    SOH.SubTotal AS HeaderSubTotal,
    SOH.TaxAmt AS HeaderTaxAmt,
    SOH.Freight AS HeaderFreight,
    SOH.TotalDue AS HeaderTotalDue,

    
    (SOD.LineTotal / SOH.SubTotal) * SOH.TaxAmt AS TaxAmt,
    (SOD.LineTotal / SOH.SubTotal) * SOH.Freight AS Freight,
    (SOD.LineTotal / SOH.SubTotal) * SOH.TotalDue AS TotalDue,

    SOD.OrderQty,
    SOD.UnitPrice,
    SOD.UnitPriceDiscount,
    SOD.LineTotal
FROM 
    Sales.SalesOrderHeader AS SOH
    INNER JOIN Sales.SalesOrderDetail AS SOD ON SOH.SalesOrderID = SOD.SalesOrderID
WHERE SOH.SubTotal > 0;  

---------------------------
CREATE VIEW [dbo].[vw_DIMShipMethod]
AS
SELECT 
    ShipMethodID,
    Name AS ShipMethodName,
    ShipBase,
    ShipRate
FROM Purchasing.ShipMethod;
---------------------------
CREATE VIEW [dbo].[vw_DIMTerritory]
AS
SELECT 
    TerritoryID,
    Name AS TerritoryName,
    CountryRegionCode,
    [Group] AS TerritoryGroup
FROM Sales.SalesTerritory;
------------------------------
CREATE VIEW [dbo].[vw_DIMSalesPerson]
AS
SELECT 
    BusinessEntityID AS SalesPersonID,
    FirstName,
    LastName,
    JobTitle,
    TerritoryName,
    SalesYTD,
    SalesLastYear
FROM Sales.vSalesPerson;

-------------------------------
CREATE VIEW [dbo].[vw_DIMProduct]
AS
SELECT 
    P.ProductID,
    P.Name AS ProductName,
    P.ProductNumber,
    PSC.ProductSubcategoryID,
    PSC.Name AS SubCategoryName,
    PC.ProductCategoryID,
    PC.Name AS CategoryName,
    P.Color,
    P.StandardCost,
    P.ListPrice
FROM Production.Product AS P
    LEFT JOIN Production.ProductSubcategory AS PSC ON P.ProductSubcategoryID = PSC.ProductSubcategoryID
    LEFT JOIN Production.ProductCategory AS PC ON PSC.ProductCategoryID = PC.ProductCategoryID;

--------------------------------
CREATE VIEW [dbo].[vw_DIMFlagOnlineOffline]
AS
SELECT 
    DISTINCT 
    OnlineOrderFlag,
    CASE 
        WHEN OnlineOrderFlag = 1 THEN 'Online'
        ELSE 'Offline'
    END AS OrderType
FROM Sales.SalesOrderHeader;

-----------------------------------------------------
SELECT ProductID, Name, ProductSubcategoryID
FROM Production.Product
WHERE ProductSubcategoryID IS NULL;