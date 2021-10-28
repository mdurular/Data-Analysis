

--DAwSQL Session -8 

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

SELECT COUNT(DISTINCT Cust_id) AS num_of_cust
FROM combined_table
WHERE YEAR(Order_Date)=2011 AND MONTH(Order_Date)=1


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





--//////////////////////////////////////

--7. Write a query that returns customers who purchased both product 11 and product 14, 
--as well as the ratio of these products to the total number of products purchased by the customer.
--Use CASE Expression, CTE, CAST AND such Aggregate Functions




--/////////////////



--CUSTOMER RETENTION ANALYSIS



--1. Create a view that keeps visit logs of customers on a monthly basis. (For each log, three field is kept: Cust_id, Year, Month)
--Use such date functions. Don't forget to call up columns you might need later.




--//////////////////////////////////


--2. Create a view that keeps the number of monthly visits by users. (Separately for all months from the business beginning)
--Don't forget to call up columns you might need later.






--//////////////////////////////////


--3. For each visit of customers, create the next month of the visit as a separate column.
--You can number the months with "DENSE_RANK" function.
--then create a new column for each month showing the next month using the numbering you have made. (use "LEAD" function.)
--Don't forget to call up columns you might need later.



--/////////////////////////////////



--4. Calculate the monthly time gap between two consecutive visits by each customer.
--Don't forget to call up columns you might need later.







--/////////////////////////////////////////


--5.Categorise customers using time gaps. Choose the most fitted labeling model for you.
--  For example: 
--	Labeled as churn if the customer hasn't made another purchase in the months since they made their first purchase.
--	Labeled as regular if the customer has made a purchase every month.
--  Etc.








--/////////////////////////////////////




--MONTH-WÝSE RETENTÝON RATE


--Find month-by-month customer retention rate  since the start of the business.


--1. Find the number of customers retained month-wise. (You can use time gaps)
--Use Time Gaps





--//////////////////////


--2. Calculate the month-wise retention rate.

--Basic formula: o	Month-Wise Retention Rate = 1.0 * Total Number of Customers in The Previous Month / Number of Customers Retained in The Next Nonth

--It is easier to divide the operations into parts rather than in a single ad-hoc query. It is recommended to use View. 
--You can also use CTE or Subquery if you want.

--You should pay attention to the join type and join columns between your views or tables.







---///////////////////////////////////
--Good luck!