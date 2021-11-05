
--------------How to use Window functions in SQL Server--------------------

--Introduction to Window functions

/*

Window functions operate on a set of rows and return a single aggregated value for each row.
The term Window describes the set of rows in the database on which the function will operate.

We define the Window (set of rows on which functions operates) using an OVER() clause. 
We will discuss more about the OVER() clause in the article below.

		Types of Window functions

		Aggregate Window Functions
		SUM(), MAX(), MIN(), AVG(), COUNT()

		Ranking Window Functions

		RANK(), DENSE_RANK(), ROW_NUMBER(), NTILE()

		Value Window Functions
		LAG(), LEAD(), FIRST_VALUE(), LAST_VALUE()


--Syntax
 
window_function ( [ ALL ] expression ) 
OVER ( [ PARTITION BY partition_list ] [ ORDER BY order_list] )

***Arguments***

ALL

ALL is an optional keyword. When you will include ALL it will count all values including duplicate ones.
DISTINCT is not supported in window functions.

expression

The target column or expression that the functions operates on. In other words, 
the name of the column for which we need an aggregated value. For example, a column
containing order amount so that we can see total orders received.

OVER

Specifies the window clauses for aggregate functions.

PARTITION BY partition_list

Defines the window (set of rows on which window function operates) for window functions. 
We need to provide a field or list of fields for the partition after PARTITION BY clause.
Multiple fields need be separated by a comma as usual. If PARTITION BY is not specified, 
grouping will be done on entire table and values will be aggregated accordingly.

ORDER BY order_list
Sorts the rows within each partition. If ORDER BY is not specified, ORDER BY uses the entire table.

Examples
*/

CREATE TABLE [my_table]
(
	order_id INT,
	order_date DATE,
	customer_name VARCHAR(250),
	city VARCHAR(100),	
	order_amount MONEY
)

INSERT INTO [my_table]
SELECT '10011','05/01/2017','David Smith','GuildFord',10010
UNION ALL	  
SELECT '10021','05/02/2017','David Jones','Arlington',20010
UNION ALL	  
SELECT '10031','05/03/2017','John Smith','Shalford',5010
UNION ALL	  
SELECT '10041','05/04/2017','Michael Smith','GuildFord',15010
UNION ALL	  
SELECT '10051','05/05/2017','David Williams','Shalford',7010
UNION ALL	  
SELECT '10061','05/06/2017','Paum Smith','GuildFord',25010
UNION ALL	 
SELECT '10071','05/10/2017','Andrew Smith','Arlington',15010
UNION ALL	  
SELECT '1008','05/11/2017','David Brown','Arlington',2010
UNION ALL	  
SELECT '10091','05/20/2017','Robert Smith','Shalford',1010
UNION ALL	  
SELECT '10101','05/25/2017','Peter Smith','GuildFord',510

select * from my_table


--Aggregate Window Functions--

/*

Sum()

We all know the SUM() aggregate function. It does the sum of specified field for
specified group (like city, state, country etc.) or for the entire table if group is not specified. 
We will see what will be the output of regular SUM() aggregate function and window SUM() aggregate function.


The following is an example of a regular SUM() aggregate function. It sums the order amount for each city.

You can see from the result set that a regular aggregate function groups multiple rows into a single output row,
which causes individual rows to lose their identity.

*/

SELECT city, SUM(order_amount) as total_order_amount
from my_table
group by city

/*
This does not happen with window aggregate functions. Rows retain their identity and also 
show an aggregated value for each row. In the example below the query does the same thing,
namely it aggregates the data for each city and shows the sum of total order amount for each 
of them.However, the query now inserts another column for the total order amount so that each 
row retains its identity. The column marked grand_total is the new column in the example below.
*/

SELECT order_id, order_date, customer_name, city, order_amount,
SUM(order_amount) OVER(PARTITION BY city) as grand_total
from my_table
 
SELECT order_id, order_date, customer_name, city, order_amount,
SUM(order_amount) OVER(PARTITION BY order_date ) as grand_total
from my_table
 



 /*

   AVG()

AVG or Average works in exactly the same way with a Window function.

The following query will give you average order amount for each city and for each month 
(although for simplicity we’ve only used data in one month).We specify more than one average
by specifying multiple fields in the partition list.It is also worth noting that that you can
use expressions in the lists like MONTH(order_date) as shown in below query. As ever you can 
make these expressions as complex as you want so long as the syntax is correct!

*/

select order_id, order_date, customer_name, city, order_amount,
AVG(order_amount) OVER(PARTITION BY city, day(order_date) order by order_amount desc) asavarage_order_amount 
from my_table

/*
   MIN()

The MIN() aggregate function will find the minimum value for a specified group or for the entire table
if group is not specified.
For example, we are looking for the smallest order (minimum order) for each city we would use the following query.
*/

SELECT order_id, order_date, customer_name, city, order_amount,
MIN(order_amount)  OVER(PARTITION BY city, month(order_date)) as minimum_order_amount
FROM my_table
/*
MAX()

Just as the MIN() functions gives you the minimum value, the MAX() function will identify the largest value of a specified field for a specified group of rows or for the entire table if a group is not specified.

let’s find the biggest order (maximum order amount) for each city.
*/

SELECT order_id, order_date, customer_name, city, order_amount,
MAX(order_amount) OVER(PARTITION BY city) as maximum_order_amount 
FROM my_table
 
 
 /*
 
 COUNT()

The COUNT() function will count the records / rows.

Note that DISTINCT is not supported with window COUNT() function whereas it is supported for the regular COUNT() 
function. DISTINCT helps you to find the distinct values of a specified field.

For example, if we want to see how many customers have placed an order in April 2017, we cannot directly 
count all customers. It is possible that the same customer has placed multiple orders in the same month.

COUNT(customer_name) will give you an incorrect result as it will count duplicates. 
Whereas COUNT(DISTINCT customer_name) will give you the correct result as it counts each unique customer
only once.
*/
 Valid for regular COUNT() function:


SELECT city,
COUNT(DISTINCT customer_name) number_of_customers
FROM my_table
GROUP BY city
 

 Invalid for window COUNT() function:

SELECT order_id, order_date, customer_name, city, order_amount,
COUNT(DISTINCT customer_name) OVER(PARTITION BY city) as number_of_customers
FROM my_table



 Now, let’s find the total order received for each city using window COUNT() function.

 SELECT order_id, order_date, customer_name, city, order_amount,
 COUNT(order_id)
 OVER(PARTITION BY city) as total_orders
 FROM my_table
 
 
 
 select city , max(total_orders) from 
 (SELECT order_id, order_date, customer_name, city, order_amount,
 COUNT(order_id)
 OVER(PARTITION BY city) as total_orders
 FROM my_table) as mehmet
 group by city



 --Ranking Window Functions-

 /*
     Just as Window aggregate functions aggregate the value of a specified field, RANKING functions will
 rank the values of a specified field and categorize them according to their rank.

     The most common use of RANKING functions is to find the top (N) records based on a certain value. 
For example, Top 10 highest paid employees, Top 10 ranked students, Top 50 largest orders etc.

The following are supported RANKING functions:

RANK(), DENSE_RANK(), ROW_NUMBER(), NTILE()

Let’s discuss them one by one.

RANK()

The RANK() function is used to give a unique rank to each record based on a specified value,
for example salary, order amount etc.

If two records have the same value then the RANK() function will assign the same rank to both 
records by skipping the next rank. This means – if there are two identical values at rank 2, it
will assign the same rank 2 to both records and then skip rank 3 and assign rank 4 to the next record.

Let’s rank each order by their order amount.
*/

SELECT  order_id, order_date, customer_name, city,order_amount,
RANK ()  OVER (PARTITION BY city ORDER BY order_amount desc ) as rank_
from my_table

DENSE_RANK()

The DENSE_RANK() function is identical to the RANK() function except that it does not skip any rank. 
This means that if two identical records are found then DENSE_RANK() will assign the same rank to both
records but not skip then skip the next rank.

Let’s see how this works in practice.


SELECT order_id, order_date, customer_name, city, order_amount,
DENSE_RANK () OVER(ORDER BY order_amount DESC) [Rank]
FROM my_table


--ROW_NUMBER()
/*
The name is self-explanatory. These functions assign a unique row number to each record.

The row number will be reset for each partition if PARTITION BY is specified. 
Let’s see how ROW_NUMBER() works without PARTITION BY and then with PARTITION BY.
*/

ROW_NUMBER() without PARTITION BY

SELECT order_id, order_date, customer_name, city, order_amount,
ROW_NUMBER () OVER (ORDER BY order_id) as [row_number]
from my_table

ROW_NUMBER() with PARTITION BY

SELECT order_id,order_date,customer_name,city, order_amount,
ROW_NUMBER() OVER(PARTITION BY city ORDER BY order_amount DESC) [row_number]
FROM my_table
/*
NTILE()

NTILE() is a very helpful window function. It helps you to identify what percentile 
(or quartile, or any other subdivision) a given row falls into.

This means that if you have 100 rows and you want to create 4 quartiles based on a 
specified value field you can do so easily and see how many rows fall into each quartile.

Let’s see an example. In the query below, we have specified that we want to create four 
quartiles based on order amount. We then want to see how many orders fall into each quartile.
*/

SELECT order_id,order_date,customer_name,city, order_amount,
NTILE(20) OVER(ORDER BY order_amount desc) [row_number]
FROM my_table

-- Value Window Functions

Value window functions are used to find first, last, previous and next values. 

The functions that can be used are LAG(), LEAD(), FIRST_VALUE(), LAST_VALUE()

LAG() and LEAD()


The LAG function allows to access data from the previous row in the same result set without use of any SQL joins.
You can see in below example, using LAG function we found previous order date.

 
SELECT order_id,customer_name,city, order_amount,order_date,
 --in below line, 1 indicates check for previous row of the current row
 LAG(order_date,1) OVER(ORDER BY order_date) prev_order_date
FROM my_table

Script to find next order date using LEAD() function:

 
SELECT order_id,customer_name,city, order_amount,order_date,
 --in below line, 1 indicates check for next row of the current row
 LEAD(order_date,1) OVER(ORDER BY order_date) next_order_date
FROM my_table


FIRST_VALUE() and LAST_VALUE()

These functions help you to identify first and last record within a partition or entire table 
if PARTITION BY is not specified.

Let’s find the first and last order of each city from our existing dataset. Note ORDER BY clause is mandatory
for FIRST_VALUE() and LAST_VALUE() functions

SELECT order_id,order_date,customer_name,city, order_amount,
FIRST_VALUE(order_date) OVER(PARTITION BY city ORDER BY city) first_order_date,
LAST_VALUE(order_date) OVER(PARTITION BY city ORDER BY city) last_order_date
FROM my_table