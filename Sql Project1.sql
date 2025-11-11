-- SQl Retail Sales Analysis -p1

SELECT * FROM sql_project_p1.retail_sales;
alter table retail_sales
change column quantiy quantity int;
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
    or sale_date is null
    or sale_time is null
    or customer_id is null
    or age is null
    or category is null
    or quantity is null
    or price_per_unit is null
    or cogs is null
    or total_sale is null;

DELETE FROM retail_sales 
WHERE 
    transactions_id IS NULL 
    or sale_date IS NULL 
    or sale_time IS NULL 
    or customer_id IS NULL 
    or gender IS NULL 
    or age IS NULL 
    or category IS NULL 
    or quantity IS NULL 
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
SELECT 
    *
FROM
    retail_sales
WHERE
    category = 'Clothing' AND quantity >= 4
        AND YEAR(sale_date) = 2022
        AND MONTH(sale_date) = 11;

-- Q.3 Write a SQL query to calculate the total sales (total_sale) for each category.


SELECT 
    category,
    SUM(total_sale) AS total_sales,
    COUNT(*) AS total_order
FROM
    retail_sales
GROUP BY category;


-- Q.4 Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.


SELECT 
    ROUND(AVG(age), 2) AS average_age
FROM
    retail_sales
WHERE
    category = 'Beauty'
GROUP BY category;


-- Q.5 Write a SQL query to find all transactions where the total_sale is greater than 1000.


SELECT 
    *
FROM
    retail_sales
WHERE
    total_sale > 1000;


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
SELECT 
    customer_id, SUM(total_sale) AS total_sale
FROM
    retail_sales
GROUP BY customer_id
ORDER BY total_sale DESC
LIMIT 5;


-- Q.9 Write a SQL query to find the number of unique customers who purchased items from each category.
SELECT 
    category, COUNT(DISTINCT customer_id) AS unique_customers
FROM
    retail_sales
GROUP BY category;


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


-- Q.11 High-value transactions (> ₹1000)
SELECT 
    COUNT(*) AS high_value_orders,
    ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM retail_sales), 2) AS pct_of_orders,
    SUM(total_sale) AS high_value_revenue,
    ROUND(SUM(total_sale) * 100.0 / (SELECT SUM(total_sale) FROM retail_sales), 2) AS pct_of_revenue
FROM retail_sales
WHERE total_sale > 1000;

-- Q.12 Top 5 customers contribution
SELECT 
    ROUND(SUM(total_sale) * 100.0 / (SELECT SUM(total_sale) FROM retail_sales), 2) AS pct_of_revenue
FROM (
    SELECT SUM(total_sale) AS total_sale
    FROM retail_sales
    GROUP BY customer_id
    ORDER BY total_sale DESC
    LIMIT 5
) AS top5;

-- Q.13 Category-wise contribution
SELECT 
    category,
    ROUND(SUM(total_sale) * 100.0 / (SELECT SUM(total_sale) FROM retail_sales), 2) AS pct_of_revenue
FROM retail_sales
GROUP BY category;

-- Q.14 Shift-wise order distribution
WITH shift_table AS (
    SELECT 
        CASE 
            WHEN HOUR(sale_time) < 12 THEN 'Morning'
            WHEN HOUR(sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
            ELSE 'Evening'
        END AS shift
    FROM retail_sales
)
SELECT 
    shift,
    ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM shift_table), 2) AS pct_of_orders
FROM shift_table
GROUP BY shift;

-- Q.15 Best month comparison to average month
WITH monthly_sales AS (
    SELECT MONTH(sale_date) AS month, SUM(total_sale) AS total_sales
    FROM retail_sales
    GROUP BY MONTH(sale_date)
)
SELECT 
    MAX(total_sales) AS best_month_sales,
    ROUND(AVG(total_sales), 2) AS avg_monthly_sales,
    ROUND((MAX(total_sales) - AVG(total_sales)) * 100.0 / AVG(total_sales), 2) AS pct_above_avg
FROM monthly_sales


