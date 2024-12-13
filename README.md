# Retail Sales Analysis - SQL Project (P1)

## Project Overview
This project involves analyzing a retail sales database using SQL. The primary objectives include data cleaning, exploration, and analysis to uncover insights such as sales trends, customer behavior, and category performance. This project also demonstrates the use of SQL techniques to answer various business-related queries.

---

## Database Details
### Database Name:
`sql_project_p1`

### Table Name:
`retail_sales`

### Schema:
| Column Name      | Data Type   | Description                           |
|------------------|-------------|---------------------------------------|
| transactions_id  | INT         | Unique identifier for each transaction |
| sale_date        | DATE        | Date of the transaction               |
| sale_time        | TIME        | Time of the transaction               |
| customer_id      | INT         | Unique identifier for the customer    |
| gender           | VARCHAR(15) | Gender of the customer                |
| age              | INT         | Age of the customer                   |
| category         | VARCHAR(15) | Product category                      |
| quantity         | INT         | Quantity of items sold                |
| price_per_unit   | FLOAT       | Price per unit of the item            |
| cogs             | FLOAT       | Cost of goods sold                    |
| total_sale       | FLOAT       | Total sale amount                     |

---



# DEMO POWER BI REPORT


![Uploading retail_sales_report_demo_video_adobe.gif…]()




## Steps Performed

### 1. **Data Cleaning**
- Identified and removed rows with NULL values to ensure data consistency.
```sql
DELETE FROM retail_sales
WHERE
    transactions_id IS NULL
    OR sale_date IS NULL
    OR sale_time IS NULL
    OR customer_id IS NULL
    OR gender IS NULL
    OR age IS NULL
    OR category IS NULL
    OR quantity IS NULL
    OR price_per_unit IS NULL
    OR cogs IS NULL
    OR total_sale IS NULL;
```

### 2. **Data Exploration**
- View raw data:
```sql
SELECT * FROM retail_sales LIMIT 10;
```
- Total transactions:
```sql
SELECT COUNT(*) AS total_sales FROM retail_sales;
```
- Unique customers:
```sql
SELECT COUNT(DISTINCT customer_id) AS unique_customers FROM retail_sales;
```
- Distinct categories:
```sql
SELECT DISTINCT category FROM retail_sales;
```

---

## Business Queries and Insights

### 1. Sales on a Specific Date
Retrieve all columns for sales made on `2022-11-05`:
```sql
SELECT * FROM retail_sales WHERE sale_date = '2022-11-05';
```

### 2. High Quantity Clothing Sales in November 2022
```sql
SELECT * FROM retail_sales
WHERE
    category = 'Clothing' AND
    quantity >= 4 AND
    sale_date >= '2022-11-01' AND
    sale_date < '2022-12-01';
```

### 3. Total Sales by Category
```sql
SELECT
    category,
    SUM(total_sale) AS net_sale,
    COUNT(*) AS total_orders
FROM retail_sales
GROUP BY category;
```

### 4. Average Age of Customers in 'Beauty' Category
```sql
SELECT
    ROUND(AVG(age), 2) AS average_age
FROM retail_sales
WHERE category = 'Beauty';
```

### 5. High-Value Transactions
Find transactions with `total_sale > 1000`:
```sql
SELECT * FROM retail_sales WHERE total_sale > 1000;
```

### 6. Transactions by Gender and Category
```sql
SELECT
    category,
    gender,
    COUNT(transactions_id) AS total_trans
FROM retail_sales
GROUP BY category, gender;
```

### 7. Best-Selling Month in Each Year
```sql
WITH RankedSales AS (
    SELECT
        EXTRACT(YEAR FROM sale_date) AS year,
        EXTRACT(MONTH FROM sale_date) AS month,
        AVG(total_sale) AS avg_sale,
        RANK() OVER (
            PARTITION BY EXTRACT(YEAR FROM sale_date)
            ORDER BY AVG(total_sale) DESC
        ) AS rank
    FROM retail_sales
    GROUP BY EXTRACT(YEAR FROM sale_date), EXTRACT(MONTH FROM sale_date)
)
SELECT year, month, avg_sale
FROM RankedSales
WHERE rank = 1;
```

### 8. Top 5 Customers by Total Sales
```sql
SELECT
    customer_id,
    SUM(total_sale) AS total_sales
FROM retail_sales
GROUP BY customer_id
ORDER BY total_sales DESC
LIMIT 5;
```

### 9. Unique Customers by Category
```sql
SELECT
    category,
    COUNT(DISTINCT customer_id) AS unique_customers
FROM retail_sales
GROUP BY category;
```

### 10. Orders by Shift (Morning, Afternoon, Evening)
```sql
SELECT *,
    CASE
        WHEN EXTRACT(HOUR FROM sale_time) <= 12 THEN 'Morning'
        WHEN EXTRACT(HOUR FROM sale_time) > 12 AND EXTRACT(HOUR FROM sale_time) <= 17 THEN 'Afternoon'
        ELSE 'Evening'
    END AS shift
FROM retail_sales;
```

---

## Tools Used
- **SQL Database:** MySQL
- **Concepts Covered:** Data Cleaning, Data Exploration, Aggregations, Window Functions, Case Statements

---

## Potential Enhancements
- Implement advanced visualizations using a BI tool (e.g., Tableau, Power BI).
- Automate data cleaning and exploration processes.
- Integrate more complex analytical queries (e.g., time-series forecasting).

---

## Conclusion
This project demonstrates the power of SQL in analyzing retail data and solving key business problems. The results provide actionable insights into sales trends, customer behavior, and category performance.

