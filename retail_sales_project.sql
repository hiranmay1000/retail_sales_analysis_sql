-- SQL retail sales analysis - P1

CREATE DATABASE sql_project_p1;

-- create table
DROP TABLE IF EXISTS retail_sales;
CREATE TABLE retail_sales (
	
	transactions_id INT PRIMARY KEY,
	sale_date DATE,
	sale_time TIME,
	customer_id INT,
	gender VARCHAR(15),
	age INT,
	category VARCHAR(15),
	quantity INT,
	price_per_unit FLOAT,
	cogs FLOAT,
	total_sale FLOAT
)

-- view raw data
SELECT * FROM retail_sales
LIMIT 10;

-- check total tuple 
SELECT 
	COUNT(*) 
FROM retail_sales 

-- DATA CLEANING PROCESS
-- identify null values 
SELECT * FROM retail_sales
WHERE
	transactions_id IS NULL
	OR
	sale_date IS NULL
	OR
	sale_time IS NULL
	OR
	customer_id IS NULL
	OR 
	gender IS NULL
	OR
	age IS NULL
	OR 
	category IS NULL
	OR
	quantity IS NULL
	OR
	price_per_unit IS NULL
	OR
	cogs IS NULL
	OR
	total_sale IS NULL;

-- remove inconsistent data
DELETE FROM retail_sales 
WHERE
	transactions_id IS NULL
	OR
	sale_date IS NULL
	OR
	sale_time IS NULL
	OR
	customer_id IS NULL
	OR 
	gender IS NULL
	OR
	age IS NULL
	OR 
	category IS NULL
	OR
	quantity IS NULL
	OR
	price_per_unit IS NULL
	OR
	cogs IS NULL
	OR
	total_sale IS NULL;

-- DATA EXPLOATION

-- how many sales we have?
SELECT COUNT(*) AS total_sales FROM retail_sales

-- how many customer we have?
SELECT COUNT(DISTINCT customer_id) AS unique_customer FROM retail_sales

-- how many distinct category we have?
SELECT DISTINCT category AS unique_category FROM retail_sales


-- DATA ANALYSIS (Bussiness key problems & solution)


--1. write a SQL query to retrive all columns for sales made on 2022-11-05?
SELECT * FROM retail_sales 
WHERE sale_date = '2022-11-05';

--2. write a SQL query to retrive all transaction where category is 'Clothing' and the quantity sold is more than 4 in the month of 'nov-2022'
SELECT * FROM retail_sales
WHERE 
	category = 'Clothing' AND 
	quantity >= 4   AND 
	sale_date >= '2022-11-01' AND 
	sale_date < '2022-12-01';

--3. write a SQL query to calculate the total sales for each category
SELECT 
	category,
	SUM(total_sale) AS net_sale,
	COUNT(*) AS total_orders
FROM retail_sales
GROUP BY category;

--4. write a SQL query to find the average age of customer who purchased items from the 'Beauty' category
SELECT 
	ROUND(AVG(age), 2) AS average_age
FROM retail_sales
WHERE category = 'Beauty'


--5. write SQL query to find all transactions where the total_sale is greater than 1000
SELECT total_sale 
FROM retail_sales
WHERE total_sale > 1000


-- Q.6 Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.
SELECT category, gender,
	COUNT(transactions_id) as total_trans
FROM retail_sales
GROUP BY category, gender

-- Q.7 Write a SQL query to calculate the average sale for each month. Find out best selling month in each year
SELECT year, month, avg_sale 
FROM (
	SELECT 
		EXTRACT(YEAR FROM sale_date) as year,
		EXTRACT(MONTH FROM sale_date) as month,
		AVG(total_sale) as avg_sale,
		RANK() OVER(PARTITION BY EXTRACT(YEAR FROM sale_date) ORDER BY AVG(total_sale) DESC) as rank
	FROM retail_sales
	GROUP BY year, month
	ORDER BY year ASC, avg_sale DESC
) as t1
WHERE rank = 1;


-- Q.8 Write a SQL query to find the top 5 customers based on the highest total sales 
SELECT 
	customer_id,
	SUM(total_sale) as total_sales

FROM retail_sales
GROUP BY customer_id
ORDER BY total_sales DESC
LIMIT 5;


-- Q.9 Write a SQL query to find the number of unique customers who purchased items from each category.
SELECT COUNT(DISTINCT customer_id), category
FROM retail_sales
GROUP BY category;

-- Q.10 Write a SQL query to create each shift and number of orders (Example Morning <=12, Afternoon Between 12 & 17, Evening >17)
SELECT *,
	CASE 
		WHEN EXTRACT(HOUR FROM sale_time) <= 12 THEN 'Morning'
		WHEN EXTRACT(HOUR FROM sale_time) > 12 AND EXTRACT(HOUR FROM sale_time) <= 17 THEN 'Afternoon'
		ELSE 'Evening'
	END AS shift
FROM retail_sales


-- end of project

