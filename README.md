# Retail Sales Analysis SQL Project

## Project Overview

**Project Title**: Retail Sales Analysis  
**Database**: `sql_project_p1`

This project is designed to demonstrate SQL skills and techniques typically used by data analysts to explore, clean, and analyze retail sales data. The project involves setting up a retail sales database, performing exploratory data analysis (EDA), and answering specific business questions through SQL queries. This project is ideal for those who are starting their journey in data analysis and want to build a solid foundation in SQL.

## Objectives

1. **Set up a retail sales database**: Create and populate a retail sales database with the provided sales data.
2. **Data Cleaning**: Identify and remove any records with missing or null values.
3. **Exploratory Data Analysis (EDA)**: Perform basic exploratory data analysis to understand the dataset.
4. **Business Analysis**: Use SQL to answer specific business questions and derive insights from the sales data.

## Project Structure

### 1. Database Setup

- **Database Creation**: The project starts by creating a database named `sql_project_p1`.
- **Table Creation**: A table named `retail_sales` is created to store the sales data. The table structure includes columns for transaction ID, sale_date, sale time, customer ID, gender, age, product category, quantity sold, price per unit, cost of goods sold (COGS), and total sale amount.

```sql
create database sql_project_p1;

create table if not exists retail_sales 
			(	
			transactions_id	int primary key,
			sale_date date,
			sale_time time,
			customer_id int,
			gender varchar(15),
			age	int,
			category varchar(15),	
			quantity int,
			price_per_unit float,	
			cogs float,	
			total_sale float
			);
```

### 2. Data Exploration & Cleaning

- **Record Count**: Determine the total number of records in the dataset.
- **Customer Count**: Find out how many unique customers are in the dataset.
- **Category Count**: Identify all unique product categories in the dataset.
- **Null Value Check**: Check for any null values in the dataset and delete records with missing data.

```sql
select count(*) as total_records from retail_sales;
select count(distinct customer_id) as customers from retail_sales;
select distinct category from retail_sales;

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
```

### 3. Data Analysis & Findings

The following SQL queries were developed to answer specific business questions:

1. **Write a SQL query to retrieve all columns for sales made on '2022-11-05:**
```sql
SELECT *
FROM retail_sales
WHERE sale_date = '2022-11-05';
```

2. **Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 4 in the month of Nov-2022:**
```sql
SELECT 
    *
FROM retail_sales
WHERE
    category = 'Clothing' AND quantity >= 4
        AND YEAR(sale_date) = 2022
        AND MONTH(sale_date) = 11;
```

3. **Write a SQL query to calculate the total sales (total_sale) for each category:**
```sql
select
category, sum(total_sale) as total_sales, 
count(*) as total_order
from retail_sales
group by category;
```

4. **Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category:**
```sql
select
round(avg(age),2) as average_age
from retail_sales
where category ='Beauty'
group by category;
```

5. **Write a SQL query to find all transactions where the total_sale is greater than 1000:**
```sql
select * from retail_sales
where total_sale > 1000;
```

6. **Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category:**
```sql
select
category, gender,
count(transactions_id) as total_transactions
from retail_sales
group by category, gender
order by category;
```

7. **Write a SQL query to calculate the average sale for each month. Find out best selling month in each year:**
```sql
select sale_year, sale_month, avg_sale
from 
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
```

8. **Write a SQL query to find the top 5 customers based on the highest total sales:**
```sql
select
customer_id, sum(total_sale) as total_sale
from retail_sales
group by customer_id
order by total_sale desc
limit 5;
```

9. **Write a SQL query to find the number of unique customers who purchased items from each category:**
```sql
select
category, count(distinct customer_id) as unique_customers
from retail_sales
group by category;
```

10. **Write a SQL query to create each shift and number of orders (Example Morning <12, Afternoon Between 12 & 17, Evening >17):**
```sql
with hourly_sale as
(
select *,
case 
    when hour(sale_time) < 12 then "Morning"
    when hour(sale_time) between 12 and 17 then "Afternoon"
	else "Evening"
    end as shift
    from retail_sales
)
    select shift, count(*) as total_orders from hourly_sale
    group by shift;
```

Q11. **High-value transactions summary (total_sale > 1000):**
```sql
SELECT 
    COUNT(*) AS high_value_orders,
    SUM(total_sale) AS high_value_revenue,
    ROUND(SUM(total_sale) * 100.0 / (SELECT SUM(total_sale) FROM retail_sales), 2) AS pct_of_revenue
FROM retail_sales
WHERE total_sale > 1000;
```

Q12. **Revenue contribution by top 5 customers:**
```sql
SELECT 
    customer_id, 
    SUM(total_sale) AS total_revenue,
    ROUND(SUM(total_sale) * 100.0 / (SELECT SUM(total_sale) FROM retail_sales), 2) AS pct_of_total
FROM retail_sales
GROUP BY customer_id
ORDER BY total_revenue DESC
LIMIT 5;
```

Q13. **Category-wise revenue share:**
```sql
SELECT 
    category, 
    ROUND(SUM(total_sale) * 100.0 / (SELECT SUM(total_sale) FROM retail_sales), 2) AS revenue_percent
FROM retail_sales
GROUP BY category;
```

Q14. **Shift-wise sales percentage:**
```sql
WITH hourly_sale AS (
    SELECT *,
        CASE 
            WHEN HOUR(sale_time) < 12 THEN 'Morning'
            WHEN HOUR(sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
            ELSE 'Evening'
        END AS shift
    FROM retail_sales
)
SELECT 
    shift, 
    ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM retail_sales), 2) AS shift_percent
FROM hourly_sale
GROUP BY shift;
```

Q15. **Best month comparison to average month:**
```sql
WITH monthly_sales AS (
    SELECT MONTH(sale_date) AS month, SUM(total_sale) AS total_sales
    FROM retail_sales
    GROUP BY MONTH(sale_date)
)
SELECT 
    MAX(total_sales) AS best_month_sales,
    ROUND(AVG(total_sales), 2) AS avg_monthly_sales,
    ROUND((MAX(total_sales) - AVG(total_sales)) * 100.0 / AVG(total_sales), 2) AS pct_above_avg
FROM monthly_sales;
```

## Findings

- **Data Cleaning**: Removed 13 incomplete records (0.65%) to improve overall data reliability.
- **Customer Demographics**: Customers span multiple age groups and genders, contributing to purchases across categories such as Clothing, Electronics, and Beauty.
- **High-Value Transactions**: Identified 306 high-value transactions (15.3% of total orders) with sales exceeding ₹1000, generating ₹475,600 — 52.17% of total revenue.
- **Category Performance**: Revenue share — Electronics (34.42%), Clothing (34.12%), and Beauty (31.46%).
- **Top Customers**: Top 5 customers contributed ₹148,470 (16.28% of total revenue), indicating strong customer loyalty potential.
- **Sales Trends**: Monthly analysis revealed the best-performing month generated ₹141,025 — 86.33% above the average month (₹75,685.83), showing strong seasonal sales variation.
- **Shift-wise Sales**: Highest transaction volume occurred in the Evening (53.10%), followed by Morning (28.05%) and Afternoon (18.85%), providing insights for staffing and marketing schedules.
- **Customer Insights**: Unique customer counts and top spenders were identified per category — valuable for loyalty and targeted marketing.
- **Overall Impact**: Analysis helped uncover spending behavior, sales seasonality, and high-performing segments, supporting data-driven retail strategies.

## Reports

- **Sales Overview**: Summarizes total revenue, order count, and category-level performance, highlighting the contribution of Electronics, Clothing, and Beauty.
- **High-Value & Customer Insights**: Identifies 306 premium transactions (₹475,600 revenue) and top 5 customers contributing 16.28% of total sales — useful for retention and loyalty analysis.
- **Trend Analysis**: Examines monthly sales variations, revealing the best-performing month with sales 86.33% above the average, and highlights seasonal demand patterns.
- **Shift-Wise Performance**: Compares order distribution by Morning, Afternoon, and Evening, showing Evening dominance (53.10%) — supporting staffing and marketing optimization.
- **Data Quality & Cleaning**: Ensures analytical accuracy by removing 13 incomplete records, improving dataset reliability by 0.65%.

## Conclusion

This SQL Retail Sales Analysis project demonstrates the power of SQL in performing data cleaning, exploratory data analysis, and business insight generation.
Through detailed queries and performance metrics, the project uncovers key sales drivers, high-value customer behavior, and seasonal demand trends.

The insights derived can directly support data-driven decision-making in retail — such as inventory planning, marketing optimization, and customer retention strategies — while also showcasing strong SQL proficiency for data analytics roles.


This project is part of my portfolio, showcasing the SQL skills essential for data analyst roles. If you have any questions, feedback, or would like to collaborate, feel free to get in touch!

- **LinkedIn**: [Connect with me professionally](https://www.linkedin.com/in/mohammad-gulrez-zaidi-95711325a)  
- **Email**: [gulrezzaidi724@gmail.com](mailto:gulrezzaidi724@gmail.com)  
  

Thank you for your support, and I look forward to connecting with you!







