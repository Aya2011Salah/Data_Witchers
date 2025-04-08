-- -----------the total sales per category---------------------------
With the_total_sales_per_category As(
Select 
Category,
Round(Sum(Sales),0)As Total_sales,
(select
Round(sum(Sales),0) 
from `sales store cleaned`) As All_Sales 
From `sales store cleaned`
Group by Category
order by Total_sales desc)
Select 
Category,
Total_sales,
concat(format((Total_sales/All_Sales)*100,0),'%') As Sales_percentage 
From the_total_sales_per_category;
--    ------------------------the total sales per region-------------------------------------------------------------------------------
With total_sales_per_region As (
Select 
Region,
Round(Sum(Sales),0) As Total_sales,
(select
Round(sum(Sales),0) 
from `sales store cleaned`) As All_Sales 
From `sales store cleaned`
Group by Region
Order by Total_sales desc)
Select
Region,
Total_sales,
concat(format((Total_sales/All_Sales)*100,0),'%') As Sales_percentage
from total_sales_per_region ;
--  ---------------------------- total sales per segment-----------
With total_sales_per_segment As (
Select
 Segment,
Round(Sum(Sales),0) As Total_sales,
count(distinct `Order ID`)As total_order_count
From `sales store cleaned`
Group by  Segment
Order by Total_sales desc)
Select
Segment, 
Total_sales,
total_order_count,
round(Total_sales/total_order_count)As Avg_amount_order
From total_sales_per_segment;
-- -----------------total sales per order ID to identify the most valuable orders.------------------------------
Select
`Order ID`,
Round(avg(Sales),0) As Avg_sales_per_order
From `sales store cleaned`
Group by `Order ID`
Order by Avg_sales_per_order desc;
-- -------------------total number of orders per customer Id & name --------------------------------------
SELECT
 `Customer ID`,
 `Customer Name`,
 COUNT(DISTINCT `Order ID`) AS Total_Orders,
round(sum(Sales) )As Total_Sales
FROM `sales store cleaned`
GROUP BY 
`Customer ID`,
 `Customer Name`
 order by Total_Orders desc
 limit 10;
-- ---------------------the average sales per order------------------------------
Select
Round(Sum(Sales),0)/count(Distinct(`Order ID`)) As Avg_sales_per_order
From `sales store cleaned`;

-- -----------------customers name & Id have the highest total sales-----------------------------------
Select
distinct`Customer Name`,
`Customer ID`,
Round(Sum(Sales),0) As Total_sales
From `sales store cleaned`
group by `Customer Name`,
`Customer ID`
order by Total_sales desc
limit 10 ;
-- --------------------Avg_amount_per_customers----------------
with Avg_amount_per_customers  As(
SELECT
distinct( `Customer ID`),
 `Customer Name`,
 COUNT(DISTINCT `Order ID`) AS Total_Orders,
round(sum(Sales) )As Total_Sales
FROM `sales store cleaned`
GROUP BY 
`Customer ID`,
 `Customer Name`)
 SELECT
 distinct(`Customer ID`),
 `Customer Name`,
Total_Orders,
Total_Sales,
round(Total_Sales/ Total_Orders) As Avg_amount_per_customer 
from Avg_amount_per_customers 
order by Avg_amount_per_customer desc
limit 10;
--   ------------------------the total sales per year-------------------------------------------
Select 
year(`Order Date`) AS year,
Round(Sum(Sales),0) As Total_sales
From `sales store cleaned`
Group by year
Order by  Total_sales desc;
--  ------------highest month per year----------
SELECT 
year(`Order Date`) AS Year,
MONTH(`Order Date`) AS Month,
Round(Sum(Sales),0)  As Total_sales 
FROM `sales store cleaned`
GROUP BY MONTH, Year
order by Total_sales desc; 
-- ---------top sales per month---
SELECT 
MONTH(`Order Date`) AS Month,
Round(Sum(Sales),0)  As Total_sales 
FROM `sales store cleaned`
GROUP BY MONTH
order by Total_sales desc;
--    --------------------------------total sales per month for a specific year-------------------------------------------
SELECT 
MONTH(`Order Date`) AS Month,
Round(Sum(Sales),0)  As Total_sales 
FROM `sales store cleaned`
WHERE YEAR(`Order Date`) = 2018
GROUP BY MONTH(`Order Date`)
ORDER BY Month ;
--      -------------------------------total sales per month for a specific year--------------------------------------------
SELECT 
MONTH(`Order Date`) AS Month,
 Round(Sum(Sales),0) As Total_sales
FROM `sales store cleaned`
WHERE YEAR(`Order Date`) = 2017
GROUP BY MONTH(`Order Date`)
ORDER BY Month ;
--    -----total sales per month for a specific year------------------------------------
SELECT 
MONTH(`Order Date`) AS Month,
Round( Sum(Sales),0) As Total_sales
FROM `sales store cleaned`
WHERE YEAR(`Order Date`) = 2016
GROUP BY MONTH(`Order Date`)
ORDER BY Month ;
-- ------------------total sales per month for a specific year------------------------------------
SELECT 
MONTH(`Order Date`) AS Month,
 Round(Sum(Sales),0) As Total_sales
FROM `sales store cleaned`
WHERE YEAR(`Order Date`) = 2015
GROUP BY MONTH(`Order Date`)
ORDER BY Month ;
-- ----------------------------total sales per sub-category---------------------------------------------
SELECT
`Sub-Category` ,
Round(SUM(Sales),0) AS Total_Sales
FROM `sales store cleaned`
GROUP BY `Sub-Category`
ORDER BY Total_Sales DESC;
-- ---------------------total sales per ship mode-------------------------------------------
SELECT
`Ship Mode` ,
Round(SUM(Sales),0) AS Total_Sales
FROM `sales store cleaned`
GROUP BY `Ship Mode`
ORDER BY Total_Sales DESC;
-- ---------------- highest request ship mode --------
with Highest_Request_ship_mode as
(
Select
	distinct(`Ship Mode`)as Ship_Mode ,
    count(distinct (`Order ID`)) as total_order,
    (select  count(distinct (`Order ID`)) from `sales store cleaned`) as Total_orders_overall
from
	`sales store cleaned`
group by
	`Ship Mode`
    )
Select
	Ship_Mode,
    total_order,
	Total_orders_overall,
    concat(round(total_order/Total_orders_overall*100),'%') as order_presentage
From
	Highest_Request_ship_mode
order by
	total_order desc;
--   --------------------------average time between order date and ship date----------------------------------------------
 SELECT
 AVG(DATEDIFF(`Ship Date`, `Order Date`)) AS Avg_Shipping_Time
FROM `sales store cleaned`;
--  ---------------------------average time between order date and ship date per order Id and ship mode --------------------------------------------------
SELECT
`Order ID`,
`Ship Mode`,
 AVG(DATEDIFF(`Ship Date`, `Order Date`)) AS Avg_Shipping_Time
FROM `sales store cleaned`
group by `Order ID`,`Ship Mode`
order by  Avg_Shipping_Time desc;
-- ---------------AVG_SHIP_DATE----

SELECT 
    `Ship Mode`,
    round(Avg(datediff(`Ship Date`,`Order Date`))) AS AVG_SHIP_DATE
   
FROM `sales store cleaned`
group by `Ship Mode`
order by AVG_SHIP_DATE desc;

-- ------------------------------Most profitable product name*----------------------------------
with sales_presnt as
(
SELECT 
    distinct (`Product Name`), 
    round(SUM(Sales)) AS Sales_amount,
    (SELECT round(SUM(Sales)) FROM `sales store cleaned`) AS total_sales
FROM   
    `sales store cleaned`
GROUP BY 
    `Product Name`
)
select
	distinct (`Product Name`),
    Sales_amount,
    concat(format(Sales_amount/total_sales*100,3),'%') as sales_presentage
from
	sales_presnt
order by
	sales_presentage desc;
-- ----------------total sales per state----------------------
SELECT
State,
Round(SUM(Sales),0) AS Total_Sales
FROM `sales store cleaned`
GROUP BY State
ORDER BY Total_Sales DESC;
-- ----------------top 5 seller in each state-------
WITH StateSales AS (
    SELECT
       `State`,
        ROUND(SUM(`Sales`)) AS State_Sales_Amount,
        (SELECT ROUND(SUM(`Sales`)) FROM  `sales store cleaned`) AS Total_Sales
    FROM
        `sales store cleaned`
    GROUP BY
     `State`
),
 
CategorySalesByState AS (
    SELECT
        `State`,
       `Sub-Category`,
        ROUND(SUM(`Sales`)) AS Sales_amount,
        (SELECT ROUND(SUM(`Sales`)) FROM `sales store cleaned`) AS Total_Sales
    FROM
         `sales store cleaned`
    GROUP BY
        `State`,
       `Sub-Category`
),
 
RankedData AS (
    SELECT
        c.`State`,
        c.`Sub-Category`,
        c.Sales_amount,
        c.Total_Sales,
        ROUND((c.Sales_amount / s.State_Sales_Amount) * 100, 2) AS sales_percentage,
        RANK() OVER(PARTITION BY c.`State` ORDER BY c.Sales_amount DESC) AS Category_Rank_In_State,
        RANK() OVER(ORDER BY s.State_Sales_Amount DESC) AS State_Rank,
        s.State_Sales_Amount
    FROM
        CategorySalesByState c
    JOIN
        StateSales s ON c.`State` = s.`State`
)
 
SELECT
   `State`,
    `Sub-Category`,
    Sales_amount,
    State_Sales_Amount,
    Total_Sales,
    CONCAT(sales_percentage, '%') AS sales_percentage,
    Category_Rank_In_State,
    State_Rank
FROM
    RankedData
WHERE
    Category_Rank_In_State IN (1, 2,3,4,5)
ORDER BY
  Sales_amount desc;
-- -----------------------total sales per city ---------------------------------
SELECT
City,
Round(SUM(Sales),0) AS Total_Sales
FROM `sales store cleaned`
GROUP BY City
ORDER BY Total_Sales DESC;

 
-- ----------------------------- postal codes generate the most revenue--------------------------------------------
select
`Postal Code`,
Round(SUM(Sales),0) AS Total_Sales
FROM `sales store cleaned`
group by `Postal Code`
order by Total_Sales desc
limit 10;
-- ---------------------the total sales per year and region----------------------------
Select 
Region,
year(`Order Date`) AS year,
Round(Sum(Sales),0) As Total_sales
From `sales store cleaned`
Group by year,Region
Order by  Total_sales desc;
-- -----------------------------total sales per category and sub-category-----------------------------
SELECT 
Category,
 `Sub-Category`,
 Round(SUM(Sales),0) AS Total_Sales
FROM `sales store cleaned`
GROUP BY Category,
 `Sub-Category`
ORDER BY Total_Sales DESC;

-- ------ Yearly Sales Trend----------------
with x as(SELECT 
    YEAR(`Order Date`) AS Year,
    ROUND(SUM(Sales), 0) AS Total_Sales,
    -- YoY Growth Rate Calculation
    ROUND(
        (SUM(Sales) - LAG(SUM(Sales), 1) OVER (ORDER BY YEAR(`Order Date`))) 
        / LAG(SUM(Sales), 1) OVER (ORDER BY YEAR(`Order Date`)) * 100, 
    2) AS YoY_Growth_Percent
FROM `sales store cleaned`
GROUP BY YEAR(`Order Date`)
ORDER BY Year)
select 
Year,
Total_Sales,
YoY_Growth_Percent
from x
where YoY_Growth_Percent is not null;


-- -------------------------------------- Monthly Sales for All Years (Trend Comparison)------
SELECT 
    YEAR(`Order Date`) AS Year,
    MONTH(`Order Date`) AS Month,
    ROUND(SUM(Sales), 0) AS Total_Sales
FROM `sales store cleaned`
GROUP BY YEAR(`Order Date`), MONTH(`Order Date`)
ORDER BY Year, Month;
-- ----------------- Avg. Shipping Time Overall
SELECT 
    AVG(DATEDIFF(`Ship Date`, `Order Date`)) AS Avg_Shipping_Days
FROM `sales store cleaned`;

-- Avg. Shipping Time by Ship Mode--------------
SELECT 
    `Ship Mode`,
    AVG(DATEDIFF(`Ship Date`, `Order Date`)) AS Avg_Shipping_Days
FROM `sales store cleaned`
GROUP BY `Ship Mode`
ORDER BY Avg_Shipping_Days;
--  ----------------------------- Sales Contribution by Ship Mode--------
SELECT 
    `Ship Mode`,
    ROUND(SUM(Sales), 0) AS Total_Sales,
    ROUND(SUM(Sales) / (SELECT SUM(Sales) FROM `sales store cleaned`) * 100, 2) AS Percent_Contribution
FROM `sales store cleaned`
GROUP BY `Ship Mode`
ORDER BY Total_Sales DESC;


-- -------------- Avg. Shipping Time Overall
SELECT 
    AVG(DATEDIFF(`Ship Date`, `Order Date`)) AS Avg_Shipping_Days
FROM `sales store cleaned`;

-- Avg. Shipping Time by Ship Mode
SELECT 
    `Ship Mode`,
    AVG(DATEDIFF(`Ship Date`, `Order Date`)) AS Avg_Shipping_Days
FROM `sales store cleaned`
GROUP BY `Ship Mode`
ORDER BY Avg_Shipping_Days;
-- ---------------- Sales Contribution by Ship Mode
SELECT 
    `Ship Mode`,
    ROUND(SUM(Sales), 0) AS Total_Sales,
    ROUND(SUM(Sales) / (SELECT SUM(Sales) FROM `sales store cleaned`) * 100, 2) AS Percent_Contribution
FROM `sales store cleaned`
GROUP BY `Ship Mode`
ORDER BY Total_Sales DESC;


-- -------------MoM-----
with MOM as (
with monthly_sales as (
select	
    month(`Order Date`) as Order_Month,
	round(sum(`Sales`)) as Monthly_Total
from	
	`sales store cleaned`
group by 1 	
)
select
    Order_Month,
    Monthly_Total,
    lag(Monthly_Total) over (order by(Order_Month)) as Prev_month_total
from
	monthly_sales
    )
    select
    Order_Month,
    concat(round((Monthly_Total-Prev_month_total)/Prev_month_total*100,0),'%') as mom_growth_percentage
from
	MOM
having 
	mom_growth_percentage is not null
order by
	Monthly_Total desc  ;
    -- --------------------------------
    -- Highest and lowest Sub Category sales---------------------------------------------------------------------------
 
WITH sales_precentage AS (
    SELECT 
        `Sub-Category`, 
        ROUND(SUM(`Sales`)) AS Sales_amount,
        ROUND(SUM(`Sales`)/(SELECT SUM(`Sales`) FROM `sales store cleaned`)*100, 1) AS sales_percentage
    FROM   
       `sales store cleaned`
    GROUP BY 
      `Sub-Category`

),
running_totals AS (
    SELECT
        `Sub-Category`,
        Sales_amount,
        sales_percentage,
        SUM(sales_percentage) OVER (ORDER BY sales_percentage DESC ROWS UNBOUNDED PRECEDING) AS running_percentage
    FROM
        sales_precentage
)
SELECT
    `Sub-Category`,
    Sales_amount,
    CONCAT(sales_percentage, '%') AS sales_presentage,
    CASE
        WHEN running_percentage <= 60 THEN 'Highest_product_sales'
        WHEN running_percentage >= 95 THEN 'Lowest_Product_sales'
        ELSE 'Other'
    END AS sales_group
FROM
    running_totals
ORDER BY
    sales_percentage DESC;
-- -----------------Total -sales----------
Select 
Round(Sum(sales),0) As Total_Sales
From `sales store cleaned`