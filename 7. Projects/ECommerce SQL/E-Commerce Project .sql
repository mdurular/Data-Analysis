

--E-Commerce Project Solution



--1. Join all the tables and create a new table called combined_table. (market_fact, cust_dimen, orders_dimen, prod_dimen, shipping_dimen)

 select * into combined_table from 
 
 (select A.Sales, A.Discount,A.Order_Quantity,A.Product_Base_Margin, B.*,C.*,D.*,E.*
 from market_fact_new A
 FULL OUTER JOIN orders_dimen_new B ON B.Ord_id = A.Ord_id
  FULL OUTER JOIN prod_dimen_new C ON C.Prod_id = A.Prod_id
  FULL OUTER JOIN cust_dimen_new D ON D.Cust_id = A.Cust_id
  FULL OUTER JOIN shipping_dimen_new E ON E.Ship_id = A.Ship_id )  S ;

 select * from combined_table




--///////////////////////


--2. Find the top 3 customers who have the maximum count of orders.

SELECT TOP 3 Cust_id , COUNT (Ord_id) AS total_order
FROM combined_table
GROUP BY Cust_id
ORDER BY total_order DESC;


--/////////////////////////////////



--3.Create a new column at combined_table as DaysTakenForDelivery that contains the date difference of Order_Date and Ship_Date.
--Use "ALTER TABLE", "UPDATE" etc.

ALTER TABLE combined_table
ADD DaysTakenForDelivery INT;

UPDATE combined_table
SET DaysTakenForDelivery = DATEDIFF(day, Order_Date, Ship_date)



--////////////////////////////////////


--4. Find the customer whose order took the maximum time to get delivered.
--Use "MAX" or "TOP"


SELECT  TOP 1 Cust_id , Customer_Name, MAX(DaysTakenForDelivery) AS max_delivered
FROM combined_table
GROUP BY Cust_id , Customer_Name
ORDER BY max_delivered DESC;

--////////////////////////////////



--5. Count the total number of unique customers in January and how many of them came back every month over the entire year in 2011
--You can use such date functions and subqueries


SELECT MONTH(Order_date) AS month_ord, COUNT(DISTINCT Cust_id) AS monthly_num_of_cust
FROM combined_table
WHERE cust_id IN 
(
SELECT Cust_id 
FROM combined_table
WHERE YEAR(Order_Date)=2011 
AND MONTH(Order_Date)=1 
)
AND YEAR (Order_Date) = 2011
GROUP BY MONTH(Order_date) 
ORDER BY month_ord

--////////////////////////////////////////////


--6. write a query to return for each user the time elapsed between the first purchasing and the third purchasing, 
--in ascending order by Customer ID
--Use "MIN" with Window Functions
 -- SOLUTÝON-1
SELECT DISTINCT Cust_id,
		Order_date,
		dense_number,
		FIRST_ORDER_DATE,
		DATEDIFF(day, FIRST_ORDER_DATE, order_date) DAYS_ELAPSED

FROM (SELECT Cust_id, Order_Date,
			MIN (Order_Date) OVER (PARTITION BY Cust_id) FIRST_ORDER_DATE,
			DENSE_RANK () OVER (PARTITION BY Cust_id ORDER BY Order_date) dense_number
FROM combined_table) A
WHERE	dense_number = 3

 -- SOLUTÝON-2

 WITH T1 AS
 (SELECT Cust_id, Order_Date,
			MIN (Order_Date) OVER (PARTITION BY Cust_id) FIRST_ORDER_DATE,
			DENSE_RANK () OVER (PARTITION BY Cust_id ORDER BY Order_date) dense_number
FROM combined_table)

SELECT DISTINCT Cust_id,
		Order_date,
		dense_number,
		FIRST_ORDER_DATE,
		DATEDIFF(day, FIRST_ORDER_DATE, order_date) DAYS_ELAPSED
FROM T1
WHERE	dense_number = 3

--//////////////////////////////////////

--7. Write a query that returns customers who purchased both product 11 and product 14, 
--as well as the ratio of these products to the total number of products purchased by the customer.
--Use CASE Expression, CTE, CAST AND such Aggregate Functions


WITH T1 AS (
SELECT Cust_id, 
		SUM(CASE WHEN Prod_id = '11' THEN Order_Quantity ELSE 0 END) P11,
		SUM(CASE WHEN Prod_id = '14' THEN Order_Quantity ELSE 0 END) P14,
		SUM(Order_Quantity) TOTAL_PROD
FROM combined_table
GROUP BY Cust_id 
HAVING 
	    SUM(CASE WHEN Prod_id = '11' THEN Order_Quantity ELSE 0 END) >=1 AND
		SUM(CASE WHEN Prod_id = '14' THEN Order_Quantity ELSE 0 END) >=1
)
SELECT Cust_id, P11, P14, TOTAL_PROD,
	   ROUND(CAST( P11 as float)/CAST (TOTAL_PROD as float), 2) RATIO_P11,
	   ROUND(CAST( P14 as float)/CAST (TOTAL_PROD as float), 2) RATIO_P14
FROM T1
ORDER BY Cust_id



--/////////////////



--CUSTOMER RETENTION ANALYSIS



--1. Create a view that keeps visit logs of customers on a monthly basis. (For each log, three field is kept: Cust_id, Year, Month)
--Use such date functions. Don't forget to call up columns you might need later.

CREATE VIEW customer_logs AS

SELECT cust_id,
				DATEPART(YEAR,Order_Date) AS [YEAR],
				DATEPART(MONTH, Order_date) AS [MONTH]

FROM combined_table


SELECT * FROM customer_logs
ORDER BY 1,2,3


--//////////////////////////////////


--2. Create a view that keeps the number of monthly visits by users. (Separately for all months from the business beginning)
--Don't forget to call up columns you might need later.


CREATE VIEW NUMBER_OF_VISIT AS

SELECT Cust_id, [YEAR], [MONTH], COUNT(*) NUM_OF_LOG
FROM customer_logs
GROUP BY Cust_id, [YEAR],[MONTH]

SELECT * FROM NUMBER_OF_VISIT
ORDER BY 1,2,3

--//////////////////////////////////


--3. For each visit of customers, create the next month of the visit as a separate column.
--You can number the months with "DENSE_RANK" function.
--then create a new column for each month showing the next month using the numbering you have made. (use "LEAD" function.)
--Don't forget to call up columns you might need later.

CREATE VIEW NEXT_VISIT AS
SELECT *,
		LEAD(CURRENT_MONTH,1) OVER (PARTITION BY Cust_id ORDER BY CURRENT_MONTH) NEXT_VISIT_MONTH
FROM
(SELECT *,
		DENSE_RANK () OVER(ORDER BY  [YEAR], [MONTH]) AS CURRENT_MONTH 
FROM NUMBER_OF_VISIT) A




--/////////////////////////////////



--4. Calculate the monthly time gap between two consecutive visits by each customer.
--Don't forget to call up columns you might need later.

CREATE VIEW TIME_GAPS AS

SELECT *, NEXT_VISIT_MONTH - CURRENT_MONTH AS TIME_GAPS			
FROM NEXT_VISIT

SELECT * From TIME_GAPS



--/////////////////////////////////////////


--5.Categorise customers using time gaps. Choose the most fitted labeling model for you.
--  For example: 
--	Labeled as churn if the customer hasn't made another purchase in the months since they made their first purchase.
--	Labeled as regular if the customer has made a purchase every month.
--  Etc.

SELECT *,
		CASE WHEN AVG_TIME_GAP IS NULL THEN 'Churn'
			WHEN AVG_TIME_GAP = 1 THEN 'Regular'
			WHEN AVG_TIME_GAP > 1 THEN 'Irregular' END CUST_LABELS	

FROM
	(SELECT Cust_id, AVG(TIME_GAPS) AS AVG_TIME_GAP
	FROM TIME_GAPS
	GROUP BY Cust_id) A


--/////////////////////////////////////




--MONTH-WÝSE RETENTÝON RATE


--Find month-by-month customer retention rate  since the start of the business.

--1. Find the number of customers retained month-wise. (You can use time gaps)
--Use Time Gaps

SELECT *,  COUNT(Cust_id) OVER(PARTITION BY NEXT_VISIT_MONTH) RETENTITON_MONTH_WISE
FROM TIME_GAPS 
WHERE TIME_GAPS=1
ORDER BY Cust_id, NEXT_VISIT_MONTH



--//////////////////////


--2. Calculate the month-wise retention rate.

--Basic formula: o	Month-Wise Retention Rate = 1.0 * Total Number of Customers in The Previous Month / Number of Customers Retained in The Next Nonth

--It is easier to divide the operations into parts rather than in a single ad-hoc query. It is recommended to use View. 
--You can also use CTE or Subquery if you want.

--You should pay attention to the join type and join columns between your views or tables.


CREATE VIEW CURRENT_NUM_OF_CUST AS

SELECT	DISTINCT cust_id, [YEAR],
		[MONTH],
		CURRENT_MONTH,
		COUNT (cust_id)	OVER (PARTITION BY CURRENT_MONTH) CURRENT_CUST
FROM	TIME_GAPS




CREATE VIEW NEXT_NUM_OF_CUST AS

SELECT	DISTINCT cust_id, [YEAR],
		[MONTH],
		CURRENT_MONTH,
		NEXT_VISIT_MONTH,
		COUNT (cust_id)	OVER (PARTITION BY CURRENT_MONTH) NEXT_CUST
FROM	TIME_GAPS
WHERE TIME_GAPS=1 AND CURRENT_MONTH>1


--1
SELECT DISTINCT B.[YEAR],B.[MONTH], ROUND(CAST ( B.NEXT_CUST AS FLOAT)/A.CURRENT_CUST,2) AS RETENTION_RATE
FROM CURRENT_NUM_OF_CUST A INNER JOIN NEXT_NUM_OF_CUST B
ON A.CURRENT_MONTH+1 =B.NEXT_VISIT_MONTH
--2
select*, lag(RETENTION_RATE,1) OVER(ORDER BY [YEAR],[MONTH]) FROM 
(SELECT DISTINCT B.[YEAR],
				B.[MONTH],
				B.CURRENT_MONTH,
				ROUND(CAST(B.NEXT_CUST AS FLOAT)/A.CURRENT_CUST,2) AS RETENTION_RATE
FROM CURRENT_NUM_OF_CUST A INNER JOIN NEXT_NUM_OF_CUST B
ON A.CURRENT_MONTH+1 = B.NEXT_VISIT_MONTH) C



---///////////////////////////////////
--Good luck!
