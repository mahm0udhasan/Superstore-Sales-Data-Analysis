--Explore Data
select top 50 * from SuperStore

--backup
select *
into SuperStore_backup
from SuperStore

--change column
UPDATE SuperStore
SET Profit = ROUND(Profit, 2),
	Sales = ROUND(Sales, 2)
	Discount = ROUND(discount, 2);

--adding column>> null
alter table superStore
add Shipping_Days int;
--set values in the column
update SuperStore
set Shipping_Days = DATEDIFF(day, Order_Date, Ship_Date)

--Dublicates
select 
Row_ID,
count(*) Check_Duplicates
from SuperStore
group by Row_ID
having count(*) > 1
order by Check_Duplicates desc

--check null
select *
from SuperStore
where Profit is null

--check minus
select *
from SuperStore
where sales < 0

--check distinct
select distinct
segment
from SuperStore

--------------------------------------------------------

--max sales of products
select 
Product_Name,
COUNT(Product_Name) countOfProducts ,
SUM(sales) totalSales
from SuperStore
group by Product_Name
order by totalSales desc

--max sales of region
select
Region,
round(sum(profit), 2) ProfitRegion
from SuperStore
group by Region
order by ProfitRegion desc

-- the lose category
select 
category,
sum(sales) sumSales,
sum(profit) sumProfit,
ROUND(sum(case when Profit > 0 then 0 else Profit end), 2) lose
from SuperStore
group by Category

--analyse category, sub category
select
Category,
Sub_Category,
round(sum(sales), 2) sumSales,
round(sum(Profit), 2) sumProfit
from SuperStore
group by Category, Sub_Category
order by sumProfit desc, category 
--order by sumSales desc, category

--analyse city, state
select
City,
State,
round(sum(sales), 2) sumSales,
round(sum(Profit), 2) sumProfit
from SuperStore
group by City, State
order by sumSales desc, City
--order by sumProfit desc, City

--analyse customers
select top 10
Customer_Name,
sum(sales) totalSales
from SuperStore
group by Customer_Name
order by totalSales desc

--analyse shipping days
select 
Row_ID,
Product_Name,
Ship_Mode,
DATEDIFF(day, Order_Date, Ship_Date) shippingDays
from SuperStore
order by shippingDays desc
-------------------------------
select 
Ship_Mode,
avg(Shipping_Days) avgShipping
from SuperStore
group by Ship_Mode
*/

--cte_analyse products by cities
-- sum(quantity) most seller  -- sum(profit) most profit
WITH ProductSales AS
(
    SELECT
        City,
        Product_Name,
        SUM(Sales) AS TotalSales,
        ROW_NUMBER() OVER
        (
            PARTITION BY City
            ORDER BY SUM(Sales) DESC
        ) AS rn
    FROM SuperStore
    GROUP BY City, Product_Name
)
SELECT
    City,
    Product_Name,
    TotalSales
FROM ProductSales
WHERE rn = 1;

