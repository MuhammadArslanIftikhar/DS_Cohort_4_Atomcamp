# Assignment # 01

# Changing the Data type of date column to date.
SET SQL_SAFE_UPDATES=0;

select * from wfp_food_prices_pakistan;
select * from commodity_commodity;
alter table wfp_food_prices_pakistan
modify column date date;

# 1.  ●	Select dates and commodities for cities Quetta, Karachi, and Peshawar where price was less than or equal 50 PKR

select date,cmname,mktname from wfp_food_prices_pakistan 
where mktname in ('Karachi','Quetta','Peshawar') and price <=50;

# 2.  ●	Query to check number of observations against each market/city in PK

 select mktname, count(*) as observation_count
 from wfp_food_prices_pakistan
 group by mktname;

# 3.  ●	Show number of distinct cities

select count(distinct mktname) as Distinct_Cities_Count
 from wfp_food_prices_pakistan;
 
 # 4.  ● List down/show the names of cities in the table
 
 select distinct mktname from wfp_food_prices_pakistan;
 
 # 5.  ●	List down/show the names of commodities in the table
 
 select distinct cmname from wfp_food_prices_pakistan;
 
 # 6. ●	List Average Prices for Wheat flour - Retail in EACH city separately over the entire period.
 
 select mktname as City, avg(price) as Average_Price 
 from wfp_food_prices_pakistan
 where cmname = 'Wheat flour - Retail'
 group by mktname;
 
 /* 7.  ●	Calculate summary stats (avg price, max price) for each city separately for all cities except Karachi 
 and sort alphabetically the city names, commodity names where commodity is Wheat (does not matter which one) 
 with separate rows for each commodity */
 
 select * from wfp_food_prices_pakistan;
 select mktname, cmname, avg(price) As Average_Price, max(price) as Maximum_Price
 from wfp_food_prices_pakistan
 where mktname != 'Karachi' and cmname like 'Wheat%'
 group by mktname, cmname
 order by mktname, cmname;
 
 # 8. ●	Calculate Avg_prices for each city for Wheat Retail and show only those avg_prices which are less than 30

 select mktname as City, avg(price) as Average_Price
 from wfp_food_prices_pakistan
 where cmname = 'Wheat - Retail'
 group by mktname
 having Average_Price < 30;
 
 # 9. ●	Prepare a table where you categorize prices based on a logic (price < 30 is LOW, price > 250 is HIGH, in between are FAIR)
 
 select *,
		case
			when price < 30 then 'Low'
			when price > 250 then 'High'
			WHEN price IS NULL THEN 'NULL'
			else 'Fair'
		end as category
from wfp_food_prices_pakistan;

/* 10. ●	Create a query showing date, cmname, category, city, price, city_category where Logic for city category is: 
Karachi and Lahore are 'Big City', Multan and Peshawar are 'Medium-sized city', Quetta is 'Small City' */

select date, cmname, category, mktname, price,
       case
           when mktname IN ('Karachi', 'Lahore') then 'Big City'
           when mktname IN ('Multan', 'Peshawar') then 'Medium-sized city'
           when mktname = 'Quetta' then 'Small City'
           else 'Unknown'
       end as city_category
from wfp_food_prices_pakistan;

/* 11. ●	Create a query to show date, cmname, city, price. Create new column price_fairness through CASE showing price 
is fair if less than 100,unfair if more than or equal to 100, if > 300 then 'Speculative' */
 
 select date, cmname, mktname, price,
       case
           when price < 100 then 'Fair'
           when price >= 100 AND price <= 300 then 'Unfair'
           when price > 300 then 'Speculative'
           else 'Unknown'
       end as price_fairness
from wfp_food_prices_pakistan;

# 12. ●	Join the food prices and commodities table with a left join. 

select *
from wfp_food_prices_pakistan
left join commodity_commodity on wfp_food_prices_pakistan.cmname = commodity_commodity.cmname;
 
 # 13. ●	Join the food prices and commodities table with an inner join
 
 select *
from wfp_food_prices_pakistan
inner join commodity_commodity ON wfp_food_prices_pakistan.cmname = commodity_commodity.cmname;
