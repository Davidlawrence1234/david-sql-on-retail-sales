DROP TABLE IF EXISTS retail_sales;
CREATE TABLE retail_sales
(
    transactions_id INT PRIMARY KEY,
    sale_date DATE,	
    sale_time TIME,
    customer_id INT,	
    gender VARCHAR(10),
    age INT,
    category VARCHAR(35),
    quantity INT,
    price_per_unit FLOAT,	
    cogs FLOAT,
    total_sale FLOAT
);

SELECT * FROM retail_sales;

SELECT
     COUNT(*) FROM retail_sales;

--- CHECK FOR NULL VALUES

SELECT * FROM retail_sales
WHERE transactions_id IS NULL;

SELECT * FROM retail_sales
WHERE sale_date IS NULL;

SELECT * FROM retail_sales
WHERE sale_time IS NULL;

SELECT * FROM retail_sales
WHERE
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

-- DELECT THE NULL VALUE FROM TABLE 
DELETE FROM retail_sales
WHERE
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

--- DATA EXPLORATION
--- HOW MANY SALES WE HAVE? 1987
SELECT COUNT(*) as total_sale FROM retail_sales;
--- how many uniques customers in the table? 155 
SELECT COUNT(DISTINCT customer_id) as total_sale FROM retail_sales;
--- how many uniques category in the table ? 3
SELECT COUNT(DISTINCT category) as total_sale FROM retail_sales;

---DATA analysis/ Business problem
---1)Write a SQL query to retrieve all columns for sales made on '2022-11-05:
----2)SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 4 in the month of Nov-2022
----3)SQL query to calculate the total sales (total_sale) for each category
---4)SQL query to find the average age of customers who purchased items from the 'Beauty' category
---5)SQL query to find all transactions where the total_sale is greater than 1000
---6) SQL query to find the total number of transactions (transaction_id) made by each gender in each category
---7)SQL query to calculate the average sale for each month. Find out best selling month in each year:
---8)SQL query to find the top 5 customers based on the highest total sales
---9)SQL query to find the number of unique customers who purchased items from each category.
---10)SQL query to create each shift and number of orders (Example Morning <12, Afternoon Between 12 & 17, Evening >17)

--- Q.1 answer =10 
SELECT *
FROM retail_sales
WHERE sale_date = '2022-11-05';

--- Q.2 answer = 17
SELECT 
     *
FROM retail_sales
WHERE category = 'Clothing'
     AND
	 TO_CHAR(sale_date, 'yyyy-mm') = '2022-11'
	 AND
	 quantity >= 4;

--- Q.3
SELECT 
     category,
	 SUM(total_sale) as net_sale,
	 COUNT(*) as total_order
FROM retail_sales
GROUP BY 1;


--- Q.4 ANSWER = 40.42

SELECT 
     ROUND(AVG(age), 2) as avg_age
FROM retail_sales
WHERE category = 'Beauty';


--- Q.5 answer = 306

SELECT * FROM retail_sales
WHERE  total_sale > 1000;

--- Q.6 
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

--- Q.7
SELECT
      year,
	  month,
	 avg_sale
FROM
(

      SELECT
          EXTRACT(YEAR FROM sale_date) as year,
	      EXTRACT(MONTH FROM sale_date) as month,
	      AVG(total_sale) as avg_sale,
	      RANK() OVER(PARTITION BY EXTRACT(YEAR FROM sale_date) ORDER BY AVG(total_sale) DESC) as rank
       FROM retail_sales
       GROUP BY 1, 2
) as t1
WHERE rank = 1;
--ORDER BY 1, 3 DESC;

--- Q.8 
SELECT
     customer_id,
	 SUM(total_sale) as total_sales
FROM retail_sales
GROUP BY 1
ORDER BY 2 DESC
LIMIT 5;

--- Q.9 

SELECT
     category,
     COUNT(DISTINCT customer_id) 
FROM retail_sales
GROUP BY category;

---- Q.10 morning total order =548, afternoon orders = 377, Evening orders = 1062
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

---- END OF PROJECT









	










	

	 
