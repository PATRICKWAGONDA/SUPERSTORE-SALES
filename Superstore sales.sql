SELECT TOP (1000) [Row ID]
      ,[Order ID]
      ,[Order Date]
      ,[Ship Date]
      ,[Ship Mode]
      ,[Customer ID]
      ,[Customer Name]
      ,[Segment]
      ,[Country]
      ,[City]
      ,[State]
      ,[Postal Code]
      ,[Region]
      ,[Product ID]
      ,[Category]
      ,[Sub-Category]
      ,[Product Name]
      ,[Sales]
      ,[Quantity]
      ,[Discount]
      ,[Profit]
  FROM [Superstore].[dbo].[Superstore_orders]

 ------Profitability Analysis
 ----What products and categories contribue most to the improvement of the store and what areas need improvement
 
 ----Finding the total revenue
 select sum (Sales) as Total_sales
 from Superstore_orders


 ------Finding the total Profit
 select sum(Profit) as Total_Profit
 from Superstore_orders


 -------Profit margins
 ----This is the ratio of Profits to Sales indicating the profitability of products 
 select Category,[Sub-Category],
 sum(Sales) as Total_sales,
 sum(Profit) as Total_profit,
 sum(Profit)/sum(Sales)*100 as Profit_Margin
 from Superstore_orders
 group by Category,[Sub-Category]
 order by Profit_Margin


 ---------Category and Subcategory performance 
 -----Sales and  profit distribution across the different categories of products 
 select Category,[Sub-Category],
 sum(Sales) as Total_Sales,
 sum(Profit) as Total_Profit,
 sum(Profit/Sales)*100 as Pofit_Margin
 from Superstore_orders
 group by Category,[Sub-Category],Sales,Profit
 order by Total_Profit desc

 --------Finding outliers
WITH CategoryStats AS (
    SELECT 
        Category
        SubCategory,
        AVG(SUM(Profit)) OVER() AS MeanProfit,
        STDEV(SUM(Profit)) OVER() AS StdDevProfit
    FROM 
        Superstore_orders
    GROUP BY 
        Category, [Sub-Category]
),
CategoryPerformance AS (
    SELECT 
        Category,
        SubCategory,
        SUM(Sales) AS TotalSales,
        SUM(Profit) AS TotalProfit,
        (SUM(Profit) / SUM(Sales)) * 100 AS ProfitMargin,
        (SUM(Profit) - MeanProfit) / StdDevProfit AS ZScore
    FROM 
        Superstore_orders
    JOIN 
        CategoryStats on 
		Superstore_orders.Category=CategoryStats.SubCategory
    GROUP BY 
        Category, SubCategory, MeanProfit, StdDevProfit
)
SELECT 
    *
FROM 
    CategoryPerformance
WHERE 
    ABS(ZScore) > 3
ORDER BY 
    TotalProfit DESC

-------office supplies
select Category,Sales,Region,[Ship Mode],[Sub-Category],Segment,City,Profit,[Customer Name]
from Superstore_orders
where Category like 'office supplies'
order by Profit asc
----------Binders are the worst perfoming commodity

------Trying to explain the causes 
------Performance over time
SELECT 
    YEAR([Order Date]) AS Year, 
    MONTH([Order Date]) AS Month, 
    SUM(Sales) AS TotalSales, 
    SUM(Profit) AS TotalProfit
FROM Superstore_orders
WHERE [Sub-Category] = 'Binders'
GROUP BY YEAR([Order Date]), MONTH([Order Date])
ORDER BY Year, Month;


-------Customer segments contributing to high discounts 
SELECT 
    [Customer ID], 
    [Customer Name], 
    SUM(Sales) AS TotalSales, 
    SUM(Profit) AS TotalProfit, 
    AVG(Discount) AS AverageDiscount
FROM Superstore_orders
WHERE [Sub-Category] = 'Binders'
GROUP BY [Customer ID], [Customer Name]
HAVING AVG(Discount) > 0.3
ORDER BY AverageDiscount DESC;


----------Product level Analysis 
SELECT 
    [Product ID], 
    [Product Name], 
    SUM(Sales) AS TotalSales, 
    SUM(Profit) AS TotalProfit, 
    AVG(Discount) AS AverageDiscount
FROM Superstore_orders
WHERE [Sub-Category] = 'Binders'
GROUP BY [Product ID], [Product Name]
ORDER BY TotalProfit asc;

--------Regional Performance 
SELECT 
    Region, 
    SUM(Sales) AS TotalSales, 
    SUM(Profit) AS TotalProfit, 
    AVG(Discount) AS AverageDiscount
FROM Superstore_orders
WHERE [Sub-Category] = 'Binders'
GROUP BY Region
ORDER BY TotalProfit DESC;


----------AVG_Discount
select AVG(discount) as AVG_Discount
from Superstore_orders
where [Sub-Category] = 'binders'


------------Explanations
----The total sales are relatively high at over $200k, but the profit is much lower at around $30k. This discrepancy suggests high costs or significant discounts impacting profitability.
------the  average discount of binders is 0.372291529875245 which is relatively high compared to the general average discount of 0.15620272163299
------With nearly 6,000 units sold, the volume is not an issue, suggesting strong demand. The issue lies in the profitability of each sale.


----------Product level analysis for machines
------Techonlogy and office supplies
select Category,Sales,Region,[Ship Mode],[Sub-Category],Segment,City,Profit,[Customer Name]
from Superstore_orders
where Category like 'Technology'
order by Profit asc


-----------Machines are the worst performing technology 
------Trying to find what causes this
------Trying to explain the causes 
------Performance over time
SELECT 
    YEAR([Order Date]) AS Year, 
    MONTH([Order Date]) AS Month, 
    SUM(Sales) AS TotalSales, 
    SUM(Profit) AS TotalProfit
FROM Superstore_orders
WHERE [Sub-Category] = 'Machines'
GROUP BY YEAR([Order Date]), MONTH([Order Date])
ORDER BY Year, Month;


------Customer segments contributing to high discounts 
SELECT 
    [Customer ID], 
    [Customer Name], 
    SUM(Sales) AS TotalSales, 
    SUM(Profit) AS TotalProfit, 
    AVG(Discount) AS AverageDiscount
FROM Superstore_orders
WHERE [Sub-Category] = 'Machines'
GROUP BY [Customer ID], [Customer Name]
HAVING AVG(Discount) > 0.3
ORDER BY AverageDiscount DESC;


-------Regional Performance 
SELECT 
    Region, 
    SUM(Sales) AS TotalSales, 
    SUM(Profit) AS TotalProfit, 
    AVG(Discount) AS AverageDiscount
FROM Superstore_orders
WHERE [Sub-Category] = 'Machines'
GROUP BY Region
ORDER BY TotalProfit DESC;


----------AVG_Discount
select AVG(discount) as AVG_Discount
from Superstore_orders
where [Sub-Category] = 'machines'



------Customer segments with high discounts
SELECT 
    [Customer ID], 
    [Customer Name], 
    SUM(Sales) AS TotalSales, 
    SUM(Profit) AS TotalProfit, 
    AVG(Discount) AS AverageDiscount
FROM Superstore_orders
WHERE [Sub-Category] = 'Machines'
GROUP BY [Customer ID], [Customer Name]
HAVING AVG(Discount) > 0.3
ORDER BY AverageDiscount DESC;

---------Products with high discounts
SELECT 
    [Product ID], 
    [Product Name], 
    SUM(Sales) AS TotalSales, 
    SUM(Profit) AS TotalProfit, 
    AVG(Discount) AS AverageDiscount,
    SUM(Quantity) AS TotalQuantity
FROM Superstore_orders
WHERE [Sub-Category] = 'Machines'
GROUP BY [Product ID], [Product Name]
ORDER BY AverageDiscount DESC;


------Product level analysis 
SELECT 
    [Product ID], 
    [Product Name], 
    SUM(Sales) AS TotalSales, 
    SUM(Profit) AS TotalProfit, 
    AVG(Discount) AS AverageDiscount,
    SUM(Quantity) AS TotalQuantity
FROM Superstore_orders
WHERE [Sub-Category] = 'Machines'
GROUP BY [Product ID], [Product Name]
ORDER BY TotalProfit ASC;

------Trying to explain the causes 
--------Cost of Goods Sold (COGS): High costs associated with the machines might be cutting into profits.
---------Return Rates: High return rates could indicate quality issues or customer dissatisfaction.
----------Shipping Costs: High shipping costs, especially for bulkier items like machines, might also impact profitability.


