USE Sales;

SELECT COUNT(1)                       --Making sure we have all 2000 rows from our file
FROM Retail;
--DATA CLEANING
SELECT * FROM Retail WHERE				--Finding missing values in the dataset
		transactions_id IS NULL
		OR sale_date IS NULL
		OR customer_id IS NULL
		OR gender IS NULL
		OR age IS NULL     --We have 10 rows where age is NULL
		OR category IS NULL
		OR quantiy IS NULL  --We have 3 rows where quantity is NULL
		OR price_per_unit IS NULL --We have 3 rows where price per unit is NULL
		OR cogs IS NULL --We have 3 rows where cogs is NULL
		OR total_sale IS NULL; --We have 3 rows where total sale is null
--Deleting the rows with null values 
DELETE FROM Retail WHERE 
transactions_id IS NULL
		OR sale_date IS NULL
		OR customer_id IS NULL
		OR gender IS NULL
		OR age IS NULL     --We have 10 rows where age is NULL
		OR category IS NULL
		OR quantiy IS NULL  --We have 3 rows where quantity is NULL
		OR price_per_unit IS NULL --We have 3 rows where price per unit is NULL
		OR cogs IS NULL --We have 3 rows where cogs is NULL
		OR total_sale IS NULL; --We have 3 rows where total sale is null
SELECT COUNT(1) FROM Retail; 
--13 rows were deleted from 2000 records leaving us with 1987 records
--DATA EXPLORATION
SELECT COUNT(1) FROM Retail; 
--13 rows were deleted from 2000 records leaving us with 1987 records

SELECT COUNT(DISTINCT customer_id) FROM Retail; 
-- We have 155 unique customers 
	
SELECT DISTINCT category FROM Retail; 
--We have 3 category of items that is clothing, electronics and beauty

SELECT gender,COUNT(gender) as gender_count FROM Retail GROUP BY gender; 
--We have 975 Male and 1012 Female customers in our database

select gender, count(gender) * 100.0 / sum(count(gender)) over() from Retail group by gender; 
--Calculating Male and Female customers in percentage. We have 49% Male and 50% female customers in our databse.

SELECT distinct category, COUNT(category) FROM Retail group by category; 
--We see that Clothing, electronics and beauty have 698,678 and 611 records respectively

SELECT distinct(category), COUNT(category)*100/SUM(COUNT(*)) OVER() as percentage from Retail group by category; 
--Clothing, electronics and beauty have 35,34 and 30% records respectively.

--Answering business questions: 
	---1. Retreive the sales made in last business month
SELECT MAX(sale_date) FROM Retail; -- We see that 2023-12-31 is the last business month in the data. 

--Lets find sum of sales in the month of Dec 2023
SELECT SUM(total_sale) FROM Retail WHERE sale_date BETWEEN '2023-12-01' AND '2023-12-31';
	--1. Solution: The last month sale was 69145 

	--2. Find the sum of units sold in each category in the month of November -2023
SELECT category, SUM(quantiy) as quantitysold FROM Retail GROUP BY category;

	--3. Write an SQL query to retrieve all transactions for clothing category in November 2023 where units sold is 4 or more.
SELECT * FROM Retail WHERE
							category = 'Clothing'
							AND
							sale_date LIKE '2023-11-%'
							AND
							quantiy >= 4;

	--4. Write an SQL query to generate sum of sales for each category
SELECT category, SUM(total_sale) as net_sale, COUNT(transactions_id) as total_orders FROM Retail group by category; 
--For Clothing , electronics and beauty we have made sales of 309995, 311445 & 286790 respectively for their respective number of orders 698,678 and 611.

	--5. Find the average age of customers who purchased beauty items
SELECT avg(age) as average_age FROM Retail WHERE category = 'Beauty';

	--6. Find all transactions where total sale is greater than 1000.
SELECT * FROM Retail WHERE total_sale >= 1000;

	--7. Write a query to find the total number of transactions in each category by gender
SELECT category,gender,COUNT(*) as count_of_transaction 
	FROM Retail
	GROUP BY category, gender;

	--8. Write SQL query to calculate average sales for each month. Find out best selling month in each year.
SELECT * FROM
(SELECT 
	DATEPART(yy,sale_date) as yr,
	DATEPART(mm,sale_date) as mt,
	AVG(total_sale) as net_sale,
	RANK() OVER(PARTITION BY DATEPART(yy,sale_date) ORDER BY AVG(total_sale) DESC) as rnk
FROM Retail
	GROUP BY 
	DATEPART(yy,sale_date),
	DATEPART(mm,sale_date)) as t1
 WHERE rnk = 1
 ORDER BY yr, net_sale DESC;
	--Solution8. We see that avg sales is highest in July in 2022 and February in 2023 as per the result (2022	7	541, 2023	2	535)
--(Note: Order by clause should be placed in the outer query or it will display an error.

--9. Find Top 5 customers based on their total purchase
SELECT 
		customer_id,
		SUM(total_sale) as salebycustomer,
		RANK() OVER(ORDER BY SUM(total_sale) DESC) as rnk
FROM Retail
GROUP BY customer_id
ORDER BY SUM(total_sale) DESC;

--Solution: According to the sum of purchase of each customer in the whole data, we have top  5 customers as (customer id , total purchase) - (3	38440, 1 30750, 5 30405, 2	25295, 4 23580) 

--10. Find out number of unique customers in each category
SELECT
		category,
		COUNT(distinct customer_id) as no_of_unique_customer
FROM Retail
GROUP BY category;
--Ans10. Beauty	141, Clothing	149, Electronics	144

SELECT MAX(age) as mx, MIN(age) as mn FROM Retail;
--11. Create age bins for customers and find sum of total sale based on age group
SELECT agebins, SUM(total_sale) as totalsales FROM 
		(SELECT total_sale, 
				CASE 
				WHEN age BETWEEN 18 AND 24 then '18-24'
				WHEN age BETWEEN 25 AND 36 then '25-36'
				WHEN age BETWEEN 37 and 48 then '37-38'
				WHEN age > 48 then '48 & above'
				END AS agebins
				FROM Retail) 
		AS t1 
GROUP BY agebins;
--Solution: (48 & above	293065, 18-24	149160, 25-36	234880, 37-38	231125)

--END OF PROJECT 
--THANKS FOR VISITING!!!