

--DBMD LECTURE
--UNIVERSITY DATABASE PROJECT 



--CREATE DATABASE


--//////////////////////////////


--CREATE TABLES 


--Make sure you add the necessary constraints.
--You can define some check constraints while creating the table, but some you must define later with the help of a scalar-valued function you'll write.
--Check whether the constraints you defined work or not.
--Import Values (Use the Data provided in the Github repo). 
--You must create the tables as they should be and define the constraints as they should be. 
--You will be expected to get errors in some points. If everything is not as it should be, you will not get the expected results or errors.
--Read the errors you will get and try to understand the cause of the errors.







--////////////////////


--CONSTRAINTS

--1. Students are constrained in the number of courses they can be enrolled in at any one time. 
--	 They may not take courses simultaneously if their combined points total exceeds 180 points.









--------///////////////////


--2. The student's region and the counselor's region must be the same.









--///////////////////////////////



------ADDITIONALLY TASKS



--1. Test the credit limit constraint.

INSERT INTO Course VALUES('Math', 50)

/*Msg 547, Level 16, State 0, Line 70
The INSERT statement conflicted with the CHECK constraint "check_credit". The conflict occurred in database "UNIVERSITY", table "dbo.Course", column 'Credit'.
The statement has been terminated.
 */


--//////////////////////////////////

--2. Test that you have correctly defined the constraint for the student counsel's region. 

UPDATE Staff SET RegionID = 5 WHERE StaffID=1

/* Msg 547, Level 16, State 0, Line 81
The UPDATE statement conflicted with the FOREIGN KEY constraint "FK__Staff__RegionID__398D8EEE". The conflict occurred in database "UNIVERSITY", table "dbo.Region", column 'RegionID'.
The statement has been terminated.*/




--/////////////////////////


--3. Try to set the credits of the History course to 20. (You should get an error.)

UPDATE Course SET Credit = 20 WHERE Title='History'

/*Msg 547, Level 16, State 0, Line 93
The UPDATE statement conflicted with the CHECK constraint "check_credit". The conflict occurred in database "UNIVERSITY", table "dbo.Course", column 'Credit'.
The statement has been terminated.*/ 


--/////////////////////////////

--4. Try to set the credits of the Fine Arts course to 30.(You should get an error.)

UPDATE Course SET Credit = 30 WHERE Title='Fine Arts'

/* Msg 547, Level 16, State 0, Line 107
The UPDATE statement conflicted with the CHECK constraint "check_credit2". The conflict occurred in database "UNIVERSITY", table "dbo.Course".
The statement has been terminated.*/


--////////////////////////////////////

--5. Debbie Orange wants to enroll in Chemistry instead of German. (You should get an error.)








--//////////////////////////


--6. Try to set Tom Garden as counsel of Alec Hunter (You should get an error.)

UPDATE student SET StaffID = 4 WHERE StudentID=1



--/////////////////////////

--7. Swap counselors of Ursula Douglas and Bronwin Blueberry.






--///////////////////


--8. Remove a staff member from the staff table.
--	 If you get an error, read the error and update the reference rules for the relevant foreign key.





 



















