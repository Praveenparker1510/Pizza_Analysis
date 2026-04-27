Use Pizza_database

SELECT * FROM pizza_sales

Total Revenue :

SELECT SUM(total_price) AS Total_Revenue FROM pizza_sales

Average Order Value :

SELECT SUM(total_price) / COUNT(DISTINCT order_id) AS Avg_Order_Value 
FROM pizza_sales

Total Pizza Sold :

SELECT SUM(quantity) AS Total_Pizza_Sold FROM pizza_sales

Total Orders :

SELECT COUNT(DISTINCT order_id) AS Total_Orders FROM pizza_sales

Average Pizza Per Order :

SELECT CAST(CAST(SUM(quantity) AS DECIMAL(10,2)) / 
CAST(COUNT(DISTINCT order_id) AS DECIMAL(10,2)) AS DECIMAL(10,2)) AS Average_Pizza_Per_Order FROM pizza_sales

Daily Trend For Total Orders :

SELECT DATENAME(DW, order_date) AS Order_Day,COUNT(DISTINCT order_id) AS Total_Orders
FROM pizza_sales
GROUP BY DATENAME(DW, order_date)

Monthly Trend For Total Orders :

SELECT DATENAME(MONTH, order_date) AS Month_Name,COUNT(DISTINCT order_id) AS Total_Orders
FROM pizza_sales
GROUP BY DATENAME(MONTH, order_date)
ORDER BY Total_Orders DESC

Hourly Trend For Total Orders :

SELECT DATEPART(HOUR, order_time) AS Order_Hours,COUNT(DISTINCT order_id) AS Total_Orders
FROM pizza_sales
GROUP BY DATEPART(HOUR, order_time)
ORDER BY DATEPART(HOUR, order_time)

% Of Sales By Category :

SELECT pizza_category,CAST(SUM(total_price) AS DECIMAL(10,2)) AS Total_Revenue,
CAST(SUM(total_price * 100) / (SELECT SUM(total_price)  FROM pizza_sales)
AS DECIMAL(10,2)) AS PCT
FROM pizza_sales
GROUP BY pizza_category

% Of Sales By Pizza Size :

SELECT pizza_size,CAST(SUM(total_price) AS DECIMAL(10,2)) AS Total_Revenue,
CAST(SUM(total_price * 100) / (SELECT SUM(total_price)  FROM pizza_sales)
AS DECIMAL(10,2)) AS PCT
FROM pizza_sales
GROUP BY pizza_size
ORDER BY pizza_size

Total Pizzas Sold By Pizza Category :

SELECT pizza_category,SUM(quantity) AS Total_Quantity_Sold
FROM pizza_sales
GROUP BY pizza_category
ORDER BY Total_Quantity_Sold DESC

Top 5 Pizzas By Revenue :

SELECT TOP 5 pizza_name,SUM(total_price) AS Total_Revenue
FROM pizza_sales
GROUP BY pizza_name
ORDER BY Total_Revenue DESC

Bottom 5 Pizzas By Revenue :

SELECT TOP 5 pizza_name,SUM(total_price) AS Total_Revenue
FROM pizza_sales
GROUP BY pizza_name
ORDER BY Total_Revenue 

Top 5 Pizzas By Quantity :

SELECT TOP 5 pizza_name,SUM(quantity) AS Total_Quantity_Sold
FROM pizza_sales
GROUP BY pizza_name
ORDER BY Total_Quantity_Sold DESC

Bottom 5 Pizzas By Quantity :

SELECT TOP 5 pizza_name,SUM(quantity) AS Total_Quantity_Sold
FROM pizza_sales
GROUP BY pizza_name
ORDER BY Total_Quantity_Sold

Top 5 Pizzas By Total Orders:

SELECT TOP 5 pizza_name,COUNT(DISTINCT order_id) AS Total_Orders
FROM pizza_sales
GROUP BY pizza_name
ORDER BY Total_Orders DESC

Bottom 5 Pizzas By Total Orders:

SELECT TOP 5 pizza_name,COUNT(DISTINCT order_id) AS Total_Orders
FROM pizza_sales
GROUP BY pizza_name
ORDER BY Total_Orders
