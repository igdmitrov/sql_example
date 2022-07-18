USE [AdventureWorks2019]
GO

SELECT 
pivotTable.productName, ISNULL(pivotTable.[2013-8], 0) as '2013-8', ISnull(pivotTable.[2013-9], 0) as '2013-9'

 FROM (
SELECT
 --CustomerNum = (SELECT TOP(1) cust.AccountNumber From Sales.Customer cust WHERE cust.CustomerID = AA.CustomerID),
 AA.productName,
 AA.[PERIOD], SUM(AA.LineTotal) AS Amount FROM (
SELECT header.OrderDate, 
 CONCAT(YEAR(header.OrderDate), '-', MONTH(header.OrderDate)) AS PERIOD,
 product.Name AS productName, header.CustomerID, detail.OrderQty, detail.LineTotal FROM Sales.SalesOrderDetail detail
JOIN Production.Product product
ON product.ProductID = detail.ProductID
JOIN Sales.SalesOrderHeader header
ON header.SalesOrderID = detail.SalesOrderID) AS AA 
GROUP BY AA.productName, AA.[PERIOD]) AS AAA
PIVOT 
(
    SUM(Amount)
    FOR Period IN ([2013-8], [2013-9])
) AS pivotTable
WHERE pivotTable.[2013-8] <> 0 OR pivotTable.[2013-9] <> 0