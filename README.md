# Retail Sales Analysis SQL Project

## Project Overview

**Project Title**: Retail Sales Analysis  
**Level**: Beginner  
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

1. **Write a SQL query to retrieve all columns for sales made on '2022-11-05**:
```sql
SELECT *
FROM retail_sales
WHERE sale_date = '2022-11-05';
```

2. **Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 4 in the month of Nov-2022**:
```sql
SELECT 
    *
FROM retail_sales
WHERE
    category = 'Clothing' AND quantity >= 4
        AND YEAR(sale_date) = 2022
        AND MONTH(sale_date) = 11;
```

3. **Write a SQL query to calculate the total sales (total_sale) for each category.**:
```sql
select
category, sum(total_sale) as total_sales, 
count(*) as total_order
from retail_sales
group by category;
```

4. **Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.**:
```sql
select
round(avg(age),2) as average_age
from retail_sales
where category ='Beauty'
group by category;
```

5. **Write a SQL query to find all transactions where the total_sale is greater than 1000.**:
```sql
select * from retail_sales
where total_sale > 1000;
```

6. **Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.**:
```sql
select
category, gender,
count(transactions_id) as total_transactions
from retail_sales
group by category, gender
order by category;
```

7. **Write a SQL query to calculate the average sale for each month. Find out best selling month in each year**:
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

8. **Write a SQL query to find the top 5 customers based on the highest total sales **:
```sql
select
customer_id, sum(total_sale) as total_sale
from retail_sales
group by customer_id
order by total_sale desc
limit 5;

```

9. **Write a SQL query to find the number of unique customers who purchased items from each category.**:
```sql
select
category, count(distinct customer_id) as unique_customers
from retail_sales
group by category;
```

10. **Write a SQL query to create each shift and number of orders (Example Morning <12, Afternoon Between 12 & 17, Evening >17)**:
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

## Findings

- **Customer Demographics**: The dataset includes customers from various age groups, with sales distributed across different categories such as Clothing and Beauty.
- **High-Value Transactions**: Multiple orders had sales amounts exceeding 1000, highlighting premium and bulk purchases.
- **Sales Trends**: Monthly analysis reveals best-performing months for each year, helping to identify seasonal demand patterns.
- **Shift-wise Sales**: Transactions are spread across Morning, Afternoon, and Evening shifts, showing how order volume varies by time of day.
- **Customer Insights**: The project highlights top-spending customers and provides counts of unique customers per category, useful for loyalty and marketing strategies.

## Reports

- **Sales Summary**: Covers total sales, category-level sales, and overall order volume.
- **Trend Analysis**:Breaks down monthly sales performance and time-of-day order patterns.
- **Customer Insights**: Includes top customers by sales, customer distribution across categories, and gender-based transaction counts.

## Conclusion

This project serves as a comprehensive introduction to SQL for data analysts, covering database setup, data cleaning, exploratory data analysis, and business-driven SQL queries. The findings from this project can help drive business decisions by understanding sales patterns, customer behavior, and product performance.

## How to Use 

1. **Clone the Repositor**y – download/copy your project from GitHub to their computer.
2. **Set Up the Database** – Run the SQL setup script (database_setup.sql) to create the database and required tables.
3. **Run the Queries** – use your query file (analysis_queries.sql) to reproduce the analysis and results.
4. **Explore and Modify** – encourage them to tweak queries or explore further insights beyond what you provided.

## Author - Mohammad Gulrez Zaidi

This project is part of my portfolio, showcasing the SQL skills essential for data analyst roles. If you have any questions, feedback, or would like to collaborate, feel free to get in touch!

- **LinkedIn**: [Connect with me professionally](www.linkedin.com/in/mohammad-gulrez-zaidi-95711325a)
- **Email**: [gulrezzaidi724@gmail.com](mailto:gulrezzaidi724@gmail.com)  

Thank you for your support, and I look forward to connecting with you!

