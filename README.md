# Retail Sales Analysis SQL Project

## Project Overview

**Project Title:** Retail Sales Analysis

**Level:** Beginner

**Database:** RetailSales

**Objectives**: 

**1. Set up a retail sales database:** Create and populate a retail sales database with the provided sales data.

**2. Data Cleaning:** Identify and remove any records with missing or null values.

**3. Exploratory Data Analysis (EDA):** Perform basic exploratory data analysis to understand the dataset.

**4. Business Analysis:** Use SQL to answer specific business questions and derive insights from the sales data.

# Project Structure
**1. Database Setup**

**Database Creation:** The project starts by creating a database named Sales. A table named Retail is created to store the sales data in Sales database. The table structure includes columns for transaction ID, sale date, customer ID, gender, age, product category, quantity sold, price per unit, cost of goods sold (COGS), and total sale amount.

```sql
CREATE DATABASE Sales

CREATE TABLE Retail 

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
```
**2. Data Exploration & Cleaning**

**Record Count:** Determine the total number of records in the dataset

**Customer Count:** Find out how many unique customers are in the dataset.

**Category Count:** Identify all unique product categories in the dataset and their percentage in the present records.

**Gender Count:** Identify number of male and female records in the dataset and calculate the same by percentage also.

```sql
SELECT COUNT(1) FROM Retail;
SELECT COUNT(DISTINCT customer_id) FROM Retail;
SELECT DISTINCT category FROM Retail;
SELECT distinct(category), COUNT(category)*100/SUM(COUNT(*)) OVER() as percentage from Retail group by category; 
SELECT gender,COUNT(gender) as gender_count FROM Retail GROUP BY gender;
SELECT gender, CAST((count(gender) * 100.0 / sum(count(gender)) over()) AS NUMERIC) AS percentage_gender FROM Retail GROUP BY gender; 
```
 **Null Value Check**: Check for any null values in the dataset and delete records with missing data.

```sql
SELECT * FROM Retail WHERE				
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
```
  
**3. Data Analysis & Findings**

**The following SQL queries were developed to answer specific business questions:**

**1. Retreive the sales made in last business month**
```sql
SELECT MAX(sale_date)
  FROM Retail;
                                  -- We see that 2023-12-31 is the last business month in the data.
                                  --Lets find sum of sales in the month of Dec 2023
SELECT SUM(total_sale)
  FROM Retail
  WHERE sale_date
  BETWEEN '2023-12-01' AND '2023-12-31';
```

**2. Find the sum of units sold in each category in the month of November -2023**
```sql
SELECT
    category,
    SUM(quantiy) AS quantitysold
        FROM Retail
        GROUP BY category;
```

**3. Write an SQL query to retrieve all transactions for clothing category in November 2023 where units sold is 4 or more.**
```sql
SELECT *
    FROM Retail
    WHERE category = 'Clothing'
        AND sale_date LIKE '2023-11-%'
        AND quantiy >= 4;
```

**4. Write an SQL query to generate sum of sales for each category**

```sql
SELECT
category,
SUM(total_sale) AS net_sale,
COUNT(transactions_id) AS total_orders
      FROM Retail
      GROUP BY category;
```

**5. Find the average age of customers who purchased beauty items**
```sql
SELECT
avg(age) AS average_age
    FROM Retail
    WHERE category = 'Beauty';
```

**6. Find all transactions where total sale is greater than 1000.**
```sql
SELECT *
FROM Retail
    WHERE total_sale >= 1000;
```

**7. Write a query to find the total number of transactions in each category by gender**
```sql
SELECT
category,
gender,
COUNT(*) as count_of_transaction 
    FROM Retail
    GROUP BY category, gender;
```

**8. Write SQL query to calculate average sales for each month. Find out best selling month in each year.**
```sql
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
```

**9. Find Top 5 customers based on their total purchase**
```sql
SELECT 
		customer_id,
		SUM(total_sale) as salebycustomer,
		RANK() OVER(ORDER BY SUM(total_sale) DESC) as rnk
FROM Retail
GROUP BY customer_id
ORDER BY SUM(total_sale) DESC;
```

**10. Find out number of unique customers in each category**
```sql
SELECT
		category,
		COUNT(distinct customer_id) as no_of_unique_customer
FROM Retail
GROUP BY category;
```

**11. Create age bins for customers and find sum of total sale based on age group**
```sql
SELECT agebins, SUM(total_sale) as totalsales FROM 
		(SELECT total_sale, 
				CASE 
				WHEN age BETWEEN 18 AND 24 then '18-24'
				WHEN age BETWEEN 25 AND 36 then '25-36'
				WHEN age BETWEEN 37 and 48 then '37-38'
				WHEN age BETWEEN 48 and 60 then '48-60'
				WHEN age > 60 then '60 & above'
				END AS agebins
				FROM Retail) 
		AS t1 
GROUP BY agebins
ORDER BY totalsales DESC;
```

**12. Write a query to find the total sales in each category by gender**

```sql
SELECT 
category,
gender,
SUM(total_sale) as sum_of_sales
	FROM Retail
	GROUP BY category, gender
	ORDER BY SUM(total_sale) DESC;
```

# **Findings**

**1. We have dataset for 2 year 2022 and 2023. The maximum average sale was recorded in the month of July in 2022 with average amount of 541 and in the month of February in 2023 with average amount of 535.** (Refer query 8)

![image](https://github.com/user-attachments/assets/287c4783-78c5-4f9e-bf23-1089ab1cccf2)

**2. Summary of unique customers by category shows that Clothing has the most number of unique customers, followed by Electronics and Beauty.** (Refer query 10)

![image](https://github.com/user-attachments/assets/e5958029-9be8-4000-b1bc-80cb35191c62)

**3. Most number of transactions were recorded in the clothing category for Males and Females followed by Electronics and Beauty.** (Refer query 7)
   
![image](https://github.com/user-attachments/assets/a6044bbc-e177-4fe1-85ba-389af1ef0133)


**4. Sales was recorded highest in the Clothing category for females followed by Electronics category for Males in the records.** (Refer query 12)

![image](https://github.com/user-attachments/assets/27e54a92-eb9e-426a-896d-c664287665f7)

**5. Most of the Sales recorded was made by the age group between 25 and 36 years followed by 37 to 46 years and so on.** (Refer query 11)

![image](https://github.com/user-attachments/assets/1bd09d09-be19-4466-bb52-993bce6848f4)


**Conclusion**

This project serves as a comprehensive introduction to SQL for data analysts, covering database setup, data cleaning, exploratory data analysis, and business-driven SQL queries. The findings from this project can help drive business decisions by understanding sales patterns, customer behavior, and category performance.
