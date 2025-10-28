create database sql_project_p1;
use sql_project_p1;

DROP TABLE IF EXISTS retail_sales;
CREATE TABLE retail_sales (
    transaction_id INT PRIMARY KEY,
    sale_date DATE,
    sale_time TIME,
    customer_id INT,
    gender VARCHAR(50),
    age INT NULL,
    category VARCHAR(50),
    quantity INT,
    price_per_unit DECIMAL(10,2),
    cogs DECIMAL(10,2),
    total_sale DECIMAL(10,2)
);

            
SELECT 
    *
FROM
    retail_sales;
    
SELECT 
    COUNT(*) 
FROM retail_sales;

SELECT COUNT(DISTINCT transaction_id) FROM retail_sales;
CREATE UNIQUE INDEX idx_transaction_id
ON retail_sales (transaction_id);

SELECT * FROM retail_sales
WHERE 
    transaction_id IS NULL
    OR
    sale_date IS NULL
    OR 
    sale_time IS NULL
    OR
    gender IS NULL
    OR
    category IS NULL
    OR
    quantity IS NULL
    OR
    cogs IS NULL
    OR
    total_sale IS NULL;
    
    SELECT COUNT(*) as total_sale FROM retail_sales;
    
    SELECT COUNT(DISTINCT customer_id) as total_sale FROM retail_sales;


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
-- Q.10 Write a SQL query to create each shift and number of orders (Example Morning <=12, Afternoon Between 12 & 17, Evening >17)


-- Q.1 Write a SQL query to retrieve all columns for sales made on '2022-11-05.
SELECT * FROM 
retail_sales 
where sale_date = '2022-11-05';

-- Q.2 Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 4 in the month of Nov-2022

Select * from retail_sales 

Where Category = 'Clothing';


SELECT 
    ROW_NUMBER() OVER (ORDER BY transaction_id) AS row_index,
    sub.*
FROM (
    SELECT * FROM retail_sales WHERE category = 'Clothing' and quantity >= 4
) sub; 


 -- Q.3 Write a SQL query to calculate the total sales (total_sale) for each category.
 
 SELECT 
    category,
    SUM(total_sale) as net_sale,
    COUNT(*) as total_orders
FROM retail_sales
GROUP BY 1;

-- Q.4 Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.

SELECT
ROUND(AVG(age),2) as Average_age
FROM retail_sales
where category = 'Beauty';

-- Q.5 Write a SQL query to find all transactions where the total_sale is greater than 1000.

SELECT *
FROM retail_sales
where total_sale > 1000;

-- Q.6 Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.

SELECT 
    category,
    gender,
    COUNT(*) as total_trans
FROM retail_sales
GROUP 
    BY 
    category,
    gender
ORDER BY 1;

-- Q.7 Write a SQL query to calculate the average sale for each month. Find out best selling month in each year

WITH monthly_avg AS (
    SELECT 
        EXTRACT(YEAR FROM sale_date) AS year,
        EXTRACT(MONTH FROM sale_date) AS month,
        AVG(total_sale) AS avg_sale
    FROM retail_sales
    GROUP BY EXTRACT(YEAR FROM sale_date), EXTRACT(MONTH FROM sale_date)
),
ranked_months AS (
    SELECT 
        year,
        month,
        avg_sale,
        RANK() OVER (
            PARTITION BY year
            ORDER BY avg_sale DESC
        ) AS ranki
    FROM monthly_avg
) 
SELECT 
    year,
    month,
    avg_sale
FROM ranked_months
WHERE ranki = 1;

-- Q.8 Write a SQL query to find the top 5 customers based on the highest total sales 


Select
 customer_id,
 SUM(total_sale) as total_sales
 from retail_sales
 GROUP BY 1
 order by 2 desc
 limit 5;
 
 -- Q.9 Write a SQL query to find the number of unique customers who purchased items from each category.
 
 
 select 
 category, 
 count(distinct customer_id) as unique_cus
 from retail_sales
 group by 1;
 
 -- Q.10 Write a SQL query to create each shift and number of orders (Example Morning <12, Afternoon Between 12 & 17, Evening >17)

WITH hourly_sale
AS
(
SELECT *,
    CASE
        WHEN EXTRACT(HOUR FROM sale_time) < 12 THEN 'Morning'
        WHEN EXTRACT(HOUR FROM sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
        ELSE 'Evening'
    END as shift
FROM retail_sales
)
SELECT 
    shift,
    COUNT(*) as total_orders    
FROM hourly_sale
GROUP BY shift;

-- End of project