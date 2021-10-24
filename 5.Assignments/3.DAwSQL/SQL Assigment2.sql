/*
1. Conversion Rate
Below you see a table of the actions of customers visiting the website by clicking on two different types of advertisements given by an E-Commerce company. 
Write a query to return the conversion and cancellation rates for each Advertisement type.
Actions:
Visitor_ID	Adv_Type	Action
1	A	Left
2	A	Order
3	B	Left
4	A	Order
5	A	Review
6	A	Left
7	B	Left
8	B	Order
9	B	Review
10	A	Review


Desired_Output:

Adv_Type	Conversion_Rate
A	0.33
B	0.25


*/
-- 1. a.	Create above table (Actions) and insert values

CREATE TABLE Actions 
(
Visitor_ID int,
Adv_Type VARCHAR(10),
Action_m VARCHAR(10),
);
	 INSERT INTO Actions (Visitor_ID, Adv_Type,Action_m)
 VALUES 
(1,'A','Left'),
(2,'A','Order'),
(3,'B','Left'),
(4,'A','Order'),
(5,'A','Review'),
(6,'A','Left'),
(7,'B','Left'),
(8,'B','Order'),
(9,'B','Review'),
(10,'A','Review');

--2. b.	Retrieve count of total Actions, and Orders for each Advertisement Type

SELECT Adv_Type, Count(Action_m) As Num_Action, (SELECT Count(Action_m) FROM Actions WHERE Action_m = 'Order' AND Adv_Type = 'A' ) As Num_order 
FROM Actions
WHERE Adv_Type = 'A'
GROUP BY Adv_Type

UNION 

SELECT Adv_Type, Count(Action_m) As Num_Action, (SELECT Count(Action_m) FROM Actions WHERE Action_m = 'Order' AND Adv_Type = 'B' ) As Num_order 
FROM Actions
WHERE Adv_Type = 'B'
GROUP BY Adv_Type

--3.Calculate Orders (Conversion) rates for each Advertisement Type by dividing by total count of actions casting as float by multiplying by 1.0.


SELECT Adv_Type, ROUND(CAST( Num_Order as float)/CAST (Num_Action as float), 2)  AS Conversion_Rate
FROM  (SELECT Adv_Type, Count(Action_m) As Num_Action, (SELECT Count(Action_m) FROM Actions WHERE Action_m = 'Order' AND Adv_Type = 'A' ) As Num_order 
FROM Actions
WHERE Adv_Type = 'A'
GROUP BY Adv_Type

UNION 

SELECT Adv_Type, Count(Action_m) As Num_Action, (SELECT Count(Action_m) FROM Actions WHERE Action_m = 'Order' AND Adv_Type = 'B' ) As Num_order 
FROM Actions
WHERE Adv_Type = 'B'
GROUP BY Adv_Type
) New_table
