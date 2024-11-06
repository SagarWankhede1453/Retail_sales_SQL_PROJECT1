--SQL retail sales analysis

--Create Table
CREATE TABLE  retail_sales 
(
transactions_id	INT PRIMARY KEY,
sale_date DATE,	
sale_time TIME,	
customer_id INT,
gender	VARCHAR(15),
age	INT,
category VARCHAR(15),	
quantity INT,	
price_per_unit FLOAT,	
cogs FLOAT,	
total_sale FLOAT
);

SELECT * FROM retail_sales;

--Now we import data from sales excel file

SELECT * FROM retail_sales;

--Count total number of rows
SELECT COUNT(*) FROM retail_sales;
--count 2000

--Data cleaning

--To find null values
SELECT * FROM retail_sales
WHERE 
      transactions_id is null
	  OR
	  sale_date is null
	  OR
	  sale_time is null
	  OR
	  customer_id is null
	  OR
	  Gender is null
	  OR
	  category is null
	  OR
	  quantity is null
	  OR
	  price_per_unit is null 
	  OR
	  cogs is null
	  OR 
	  total_sale is null;

--Delete null rows 
DELETE FROM retail_sales
WHERE 
      transactions_id is null
	  OR
	  sale_date is null
	  OR
	  sale_time is null
	  OR
	  customer_id is null
	  OR
	  Gender is null
	  OR
	  category is null
	  OR
	  quantity is null
	  OR
	  price_per_unit is null 
	  OR
	  cogs is null
	  OR 
	  total_sale is null;

--Data exploration

--now count new number of rows
SELECT COUNT(*) FROM retail_sales;
--Count 1997

--How many sales we have?
SELECT COUNT(*) as total_sale FROM retail_sales;
-1997

--How many unique customers we have?
SELECT COUNT(DISTINCT customer_id) as total_customer 
FROM retail_sales;
--155 unique customers

--How many distinct category we have?
SELECT COUNT(DISTINCT category) FROM retail_sales;
--3 distinct category


--DATA Analysis & business key problem

--Q.1 Write a SQL query to retrieve all columns for sales made on '2022-11-05'

SELECT * FROM retail_sales where sale_date = '2022-11-05';
--Total 11 rows means total 11 transaction at different time.


--Q.2 Write a SQL query to retrieve all transactions where the category is 'clothing' and the quantity sold is more than 4 in the month of NOV-2022?

SELECT * FROM retail_sales
WHERE category ='Clothing'
AND TO_CHAR(sale_date, 'YYYY-MM') = '2022-11'
AND quantity >=4;
--17 rows means in month of nov there are 17 transaction of clothing where purchased quantity is 4 or more

--Q.3 Write a SQL query to calculate the total sales(total_sale) for each category?

SELECT SUM(total_sale) as net_sale,category FROM retail_sales
group by category;
--Electronics - 313810
--Clothing - 311070
--Beauty - 286840

SELECT category,SUM(total_sale) as net_sale,
COUNT(*) as total_order FROM retail_sales
group by category;
--Electronics - 313810 - 684
--Clothing - 311070 - 701
--Beauty - 286840 - 612

--Q.4 Write a SQL query to find the average age of customers who purchase item from beauty category?

SELECT ROUND(AVG(age),2) FROM retail_sales
WHERE category = 'Beauty'

-- So the average age of customers is 40.42 who purchased beauty products.

--Q.5  Write a SQL query to find all transaction where total sales is greater than 1000?

SELECT COUNT(*) FROM retail_sales
WHERE total_sale >= 1000;
--Total transaction is 404 for high ticket transactions of 1000 or more


--Q.6 Write a SQL query to find the total number of transaction by each gender in different category?

SELECT gender,category,COUNT(transactions_id) FROM retail_sales
GROUP BY gender, category;

--female--beauty--330
--female--clothing--347
--female--electronics--340
--male--electronics--344
--male--clothing--354
--male--beauty--282

--Q.7 Write a SQL query to calculate the average sales for each month. Find out best selling month for each year?

SELECT 
EXTRACT(YEAR FROM sale_date) as year,
EXTRACT(MONTH FROM sale_date) as month
,AVG(total_sale) FROM retail_sales
GROUP BY 1,2
ORDER BY AVG(total_sale) DESC;

--2022	7	541.3414634146342
--2023	2	535.531914893617
--2022	3	521.3829787234042
--2023	8	495.96491228070175
--2023	12	490.3900709219858
--2022	4	486.52542372881356
--2022	6	481.3953488372093
--2022	5	480.38461538461536
--2022	9	478.83720930232556
--2022	11	472.02054794520546
--2022	10	467.36301369863014
--2023	4	466.48936170212767
--2022	12	464.20382165605093
--2023	9	462.73972602739724
--2023	11	453.45238095238096
--2023	5	450.1666666666667
--2023	6	438.48214285714283
--2023	7	427.67857142857144
--2023	10	399.17241379310343
--2022	1	397.10526315789474
--2023	1	396.5
--2023	3	394.8076923076923
--2022	8	385.3636363636364
--2022	2	366.1363636363636

SELECT 
EXTRACT(YEAR FROM sale_date) as year,
EXTRACT(MONTH FROM sale_date) as month
,AVG(total_sale) AS avg_sale,
RANK() OVER(PARTITION BY EXTRACT(YEAR FROM sale_date)
ORDER BY AVG(total_sale) DESC ) AS RANK
FROM retail_sales
GROUP BY 1,2

--YEAR MONTH  AVH SALE         RANK
2022	7	541.3414634146342	1
2022	3	521.3829787234042	2
2022	4	486.52542372881356	3
2022	6	481.3953488372093	4
2022	5	480.38461538461536	5
2022	9	478.83720930232556	6
2022	11	472.02054794520546	7
2022	10	467.36301369863014	8
2022	12	464.20382165605093	9
2022	1	397.10526315789474	10
2022	8	385.3636363636364	11
2022	2	366.1363636363636	12
2023	2	535.531914893617	1
2023	8	495.96491228070175	2
2023	12	490.3900709219858	3
2023	4	466.48936170212767	4
2023	9	462.73972602739724	5
2023	11	453.45238095238096	6
2023	5	450.1666666666667	7
2023	6	438.48214285714283	8
2023	7	427.67857142857144	9
2023	10	399.17241379310343	10
2023	1	396.5	11
2023	3	394.8076923076923	12

SELECT year, month,avg_sale
FROM
(SELECT 
EXTRACT(YEAR FROM sale_date) as year,
EXTRACT(MONTH FROM sale_date) as month
,AVG(total_sale) as avg_sale,
RANK() OVER(PARTITION BY EXTRACT(YEAR FROM sale_date)
ORDER BY AVG(total_sale) DESC ) AS RANK
FROM retail_sales
GROUP BY 1,2)
as t1
where rank =1

--year month  avy_sale
--2022	7	541.3414634146342
--2023	2	535.531914893617

--Q.8 Write a SQL query to find the top 5 customers based on highest total sales?

SELECT customer_id, SUM(total_sale) from retail_sales
GROUP BY customer_id
ORDER BY SUM(total_sale) DESC
LIMIT 5;

--customer_id    Sum
--3	             38440
--1	             30750
--5	             30405
--2	             25295
--4	             23580

--Q.9 Write a SQL query to find the number of unique customers for each type of category?

SELECT category, COUNT(DISTINCT customer_id)
from retail_sales
GROUP BY 1;

--Category     Count
--"Beauty"	    141
--"Clothing"	149
--"Electronics"	144

--Q.10 Write a SQL query to create each shift and number of order (Example morning>= 12, afternoon between 12 and 17, evening >= 17)


WITH hourly_sale
AS
(
SELECT *,
    CASE
	   WHEN EXTRACT (HOUR FROM sale_time)< 12 THEN 'morning'
	   WHEN EXTRACT (HOUR FROM sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
	   ELSE 'Evening'
	 END AS shift
FROM retail_sales)

SELECT shift, COUNT(*) AS total_orders
FROM hourly_sale
GROUP BY shift;

--shift     total order
--"morning"	    558
--"Afternoon"	377
--"Evening"  	1062

--End of project
