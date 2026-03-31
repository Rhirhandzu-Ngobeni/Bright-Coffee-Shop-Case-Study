  --Checking how my data looks like and study each column
  select * 
  from bright 
  limit 10;
  
  --Period of this dataset
  select Min(transaction_date) as First_Transaction_Date,
  Max(transaction_date) as End_Transaction_Date
  from bright;
 -- Started on the 1st of january to the 30th of June. This data is for 6 full months.

--Number of stores in the covered area
select count(distinct store_id) as number_of_stores
from bright;
-- total of 3 strores

 -- Store locations 
 select distinct(store_location) as Store_names
 from bright;
 -- Lower Manhattan, Hell's Kitchen and Astoria

-- Number of products sold in each store
Select count(distinct(product_ID)) as Total_products_sold
from bright;
-- A total of 80 products are sold on each store

--Products details
select distinct(product_detail)
from bright;

--Products sold in each store
select distinct(product_category) as Products_sold
from bright;
-- Coffee, Tea, Drinking Chocolate, Bakery, Flavours, Loose tea, Coffee beans, packaged Chocolate and Branded

--Products type
select distinct(product_type)
from bright;

-- Price range of products
select Min(unit_price) as Lowest_Selling_Price,
Max(Unit_price) as Highest_Selling_Price
from bright; 
-- (Assumption: Using the ZAR currency) Prices Range: R0.80 - R45.00

-- Total number of transactions
select count(distinct(transaction_id)) as Total_Number_of_transactions_sold
from bright;
-- 149116 transactions were made in all three stores combined for 6 months in 2023

-- Total quantity sold
select sum(transaction_qty) as Total_Quantity_Sold
from bright;
-- A total of 214470 products were sold in all three stores combined for 6 months in 2023

-- calculation for Revenue
select (transaction_qty * unit_price) as Revenue
from bright;

-- Total Revenue
select sum(transaction_qty * unit_price) as Total_Revenue
from Bright;
-- (Assumption: Using the ZAR currency)The total revenue for all three stores combined for the first 6 minths of 2023 was R698812.33

--Creating a table that I will use for my insights, reporting, presentation and dashboard.

with Temp_table as (
select * , 
(transaction_qty * unit_price) as Revenue, -- Creating a Revenue column
case
when hour(transaction_time) between 6 and 8  then 'Early Morning'
when hour(transaction_time) between 9 and 11 then 'Mid Morning'
when hour(transaction_time) between 12 and 14  then 'Afternoon'
when hour(transaction_time) between 15 and 17  then 'Mid Afternoon'
else 'Evening'
end as Time_of_day, -- creating Time of day column (06am-20pm)
monthname(Transaction_date) as Month, -- Creating Montn column ( Jan-Jun)
Dayname(Transaction_date) as Day_of_the_week, -- Creating day of the week column (Mon-Sun)
case
when Dayname(Transaction_date) in ('Sat', 'Sun') then 'weekend'
else 'weekday'
end as Day_type -- Creating day type (Weekeday or Weekend)
from bright)
select sum(revenue) as Total_revenue,
transaction_qty,
transaction_date,
Month,
Day_of_the_week,
Day_type,
transaction_time,
time_of_day,
store_location,
product_category,
product_type,
product_detail
from Temp_table
Group by transaction_date, store_location, product_category, product_type, time_of_day, Month, Day_of_the_week, Day_type, transaction_qty, product_detail, Day_type, transaction_time
Order by Total_revenue desc;


