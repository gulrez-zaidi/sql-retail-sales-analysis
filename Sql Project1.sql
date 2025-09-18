SELECT * FROM sql_project_p1.retail_sales;

LOAD DATA LOCAL INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Data/sql_project_p1/SQL - Retail Sales Analysis_utf .csv'
INTO TABLE retail_sales
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(transactions_id, sale_date, sale_time, customer_id, gender, @age, category, @quantiy, @price_per_unit, @cogs, @total_sale)
SET
    age = NULLIF(@age, ''),
    quantiy = NULLIF(@quantiy, ''),
    price_per_unit = NULLIF(@price_per_unit, ''),
    cogs = NULLIF(@cogs, ''),
    total_sale = NULLIF(@total_sale, '');
    
SELECT count(*) FROM sql_project_p1.retail_sales;


select * from retail_sales 
where 
    transactions_id is null
    or 
    sale_date is null
    or 
    sale_time is null
    or
    customer_id is null
    or
    age is null
    or
    category is null
    or
    quantiy is null
    or
    price_per_unit is null
    or
    cogs is null
    or
    total_sale is null;

DELETE FROM retail_sales 
WHERE 
    transactions_id IS NULL 
    or sale_date IS NULL 
    or sale_time IS NULL 
    or customer_id IS NULL 
    or gender IS NULL 
    or age IS NULL 
    or category IS NULL 
    or quantiy IS NULL 
    or price_per_unit IS NULL 
    or cogs IS NULL 
    or total_sale IS NULL;

-- Data Exploration
-- How many sales do we have?
select count(*) as total_sales from retail_sales;

-- How many unique customers we have?
select count(distinct customer_id) as customers from retail_sales;

-- What are the categories we have?
select distinct category from retail_sales;

-- Data Analysis & Business Key Problems & Answers

-- My Analysis & Findings
-- Q.1 Write a SQL query to retrieve all columns for sales made on '2022-11-05
-- Q.2 Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 10 in the month of Nov-2022
-- Q.3 Write a SQL query to calculate the total sales (total_sale) for each category.
-- Q.4 Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.
-- Q.5 Write a SQL query to find all transactions where the total_sale is greater than 1000.
-- Q.6 Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.
-- Q.7 Write a SQL query to calculate the average sale for each month. Find out best selling month in each year
-- Q.8 Write a SQL query to find the top 5 customers based on the highest total sales
-- Q.9 Write a SQL query to find the number of unique customers who purchased items from each category.
-- Q.10 Write a SQL query to create each shift and number of orders (Example Morning <=12, Afternoon Between 12 & 17, Evening >17]


-- Q.1 Write a SQL query to retrieve all columns for sales made on '2022-11-05'
select * from retail_sales
where sale_date = '2022-11-05';

-- Q.2 Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than equall to 4 in the month of Nov-2022
select * from retail_sales
where category = 'Clothing' and quantiy >= 4 
and year(sale_date)=2022 and month(sale_date)=11;

-- Q.3 Write a SQL query to calculate the total sales (total_sale) for each category.
select category, 
sum(total_sale) as total_sales, 
count(*) as total_order
from retail_sales
group by category;

-- Q.4 Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.
select round(avg(age),2) as average_age
from retail_sales
where category ='Beauty'
group by category;

-- Q.5 Write a SQL query to find all transactions where the total_sale is greater than 1000.
select * from retail_sales
where total_sale > 1000;

-- Q.6 Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.
select category, gender, count(transactions_id) as total_transactions from retail_sales
group by category, gender
order by category;

-- Q.7 Write a SQL query to calculate the average sale for each month.Find out best selling month in each year.
select sale_year, sale_month, avg_sale from 
(
select 
YEAR(sale_date) AS sale_year, 
MONTH(sale_date) AS sale_month, 
round(avg(total_sale),2) as avg_sale,
rank() over(partition by YEAR(sale_date) order by avg(total_sale) desc) as rnk
from retail_sales
group by year(sale_date), month(sale_date)
) as T1
where rnk = 1;

-- Q.8 Write a SQL query to find the top 5 customers based on the highest total sales.
select customer_id, sum(total_sale) as total_sale
from retail_sales
group by customer_id
order by total_sale desc
limit 5;

-- Q.9 Write a SQL query to find the number of unique customers who purchased items from each category.
select category, count(distinct customer_id) as unique_customers
from retail_sales
group by category;
 
-- Q.10 Write a SQL query to create each shift and number of orders (Example Morning <12, Afternoon Between 12 & 17, Evening >17]
with hourly_sale as
(select *,
case 
    when hour(sale_time) < 12 then "Morning"
    when hour(sale_time) between 12 and 17 then "Afternoon"
	else "Evening"
    end as shift
    from retail_sales)
    select shift, count(*) as total_orders from hourly_sale
    group by shift;







