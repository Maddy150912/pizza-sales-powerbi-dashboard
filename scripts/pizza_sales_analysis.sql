/*
===============================================================================
 Project: Pizza Sales Analysis
 Description:
    SQL analysis to derive business insights for Power BI dashboard.
    Includes KPI calculations, trends, and best/worst performers.
===============================================================================
*/

USE PizzaDB;
GO

-- ============================================================================
-- 1. BASE TABLE PREVIEW
-- ============================================================================
SELECT *
FROM pizza_sales;
GO


-- ============================================================================
-- 2. KPI METRICS
-- ============================================================================

-- Total Revenue
SELECT 
    SUM(total_price) AS Total_Revenue
FROM pizza_sales;
GO

-- Average Order Value (AOV)
-- Total Revenue / Total Orders
SELECT 
    SUM(total_price) / COUNT(DISTINCT order_id) AS Avg_Order_Value
FROM pizza_sales;
GO

-- Total Pizzas Sold
SELECT 
    SUM(quantity) AS Total_Pizzas_Sold
FROM pizza_sales;
GO

-- Total Orders
SELECT 
    COUNT(DISTINCT order_id) AS Total_Orders
FROM pizza_sales;
GO

-- Average Pizzas Per Order
SELECT 
    CAST(SUM(quantity) AS DECIMAL(10,2)) /
    CAST(COUNT(DISTINCT order_id) AS DECIMAL(10,2)) 
    AS Avg_Pizzas_Per_Order
FROM pizza_sales;
GO


-- ============================================================================
-- 3. SALES TRENDS
-- ============================================================================

-- Daily Trend (Total Orders by Day)
SELECT 
    DATENAME(WEEKDAY, order_date) AS Order_Day,
    COUNT(DISTINCT order_id) AS Total_Orders
FROM pizza_sales
GROUP BY DATENAME(WEEKDAY, order_date);
GO

-- Monthly Trend (Total Orders by Month)
SELECT 
    DATENAME(MONTH, order_date) AS Order_Month,
    COUNT(DISTINCT order_id) AS Total_Orders
FROM pizza_sales
GROUP BY DATENAME(MONTH, order_date);
GO


-- ============================================================================
-- 4. SALES DISTRIBUTION
-- ============================================================================

-- Percentage of Sales by Pizza Category
SELECT 
    pizza_category,
    SUM(total_price) AS Total_Sales,
    CAST(
        SUM(total_price) * 100.0 /
        (SELECT SUM(total_price) FROM pizza_sales)
    AS DECIMAL(10,2)) AS Pct_Sales_By_Category
FROM pizza_sales
GROUP BY pizza_category;
GO

-- Percentage of Sales by Pizza Size
SELECT 
    pizza_size,
    SUM(total_price) AS Total_Sales,
    CAST(
        SUM(total_price) * 100.0 /
        (SELECT SUM(total_price) FROM pizza_sales)
    AS DECIMAL(10,2)) AS Pct_Sales_By_Size
FROM pizza_sales
GROUP BY pizza_size
ORDER BY Pct_Sales_By_Size DESC;
GO


-- ============================================================================
-- 5. TOP 5 BEST SELLERS
-- ============================================================================

-- Top 5 by Revenue
SELECT pizza_name, Pizza_Total_Revenue
FROM (
    SELECT 
        pizza_name,
        SUM(total_price) AS Pizza_Total_Revenue,
        DENSE_RANK() OVER (ORDER BY SUM(total_price) DESC) AS Rank_No
    FROM pizza_sales
    GROUP BY pizza_name
) t
WHERE Rank_No <= 5;
GO

-- Top 5 by Quantity
SELECT pizza_name, Pizza_Total_Quantity
FROM (
    SELECT 
        pizza_name,
        SUM(quantity) AS Pizza_Total_Quantity,
        DENSE_RANK() OVER (ORDER BY SUM(quantity) DESC) AS Rank_No
    FROM pizza_sales
    GROUP BY pizza_name
) t
WHERE Rank_No <= 5;
GO

-- Top 5 by Orders
SELECT pizza_name, Pizza_Total_Orders
FROM (
    SELECT 
        pizza_name,
        COUNT(DISTINCT order_id) AS Pizza_Total_Orders,
        DENSE_RANK() OVER (ORDER BY COUNT(DISTINCT order_id) DESC) AS Rank_No
    FROM pizza_sales
    GROUP BY pizza_name
) t
WHERE Rank_No <= 5;
GO


-- ============================================================================
-- 6. BOTTOM 5 WORST SELLERS
-- ============================================================================

-- Bottom 5 by Revenue
SELECT pizza_name, Pizza_Total_Revenue
FROM (
    SELECT 
        pizza_name,
        SUM(total_price) AS Pizza_Total_Revenue,
        DENSE_RANK() OVER (ORDER BY SUM(total_price)) AS Rank_No
    FROM pizza_sales
    GROUP BY pizza_name
) t
WHERE Rank_No <= 5;
GO

-- Bottom 5 by Quantity
SELECT pizza_name, Pizza_Total_Quantity
FROM (
    SELECT 
        pizza_name,
        SUM(quantity) AS Pizza_Total_Quantity,
        DENSE_RANK() OVER (ORDER BY SUM(quantity)) AS Rank_No
    FROM pizza_sales
    GROUP BY pizza_name
) t
WHERE Rank_No <= 5;
GO

-- Bottom 5 by Orders
SELECT pizza_name, Pizza_Total_Orders
FROM (
    SELECT 
        pizza_name,
        COUNT(DISTINCT order_id) AS Pizza_Total_Orders,
        DENSE_RANK() OVER (ORDER BY COUNT(DISTINCT order_id)) AS Rank_No
    FROM pizza_sales
    GROUP BY pizza_name
) t
WHERE Rank_No <= 5;
GO
