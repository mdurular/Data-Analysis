CREATE DATABASE UNIVERSITY;
use UNIVERSITY;
---
-- Table structure for table 'Region'
---
  CREATE TABLE Region(
  RegionID INT PRIMARY KEY NOT NULL,
  RegionName VARCHAR (256) NOT NULL
  );

---
-- Table structure for table 'Staff'
---

  CREATE TABLE Staff (
  StaffID INT NOT NULL IDENTITY(1,1)
  CONSTRAINT staff_pk PRIMARY KEY (StaffID),
  FirstName VARCHAR (256),
  LastName VARCHAR (256),
  RegionID INT NOT NULL
  FOREIGN KEY (RegionID) REFERENCES Region (RegionID) 
  );

---
-- Table structure for table 'Student'
---

CREATE TABLE student (
  StudentID INT NOT NULL IDENTITY (1,1)
  CONSTRAINT student_pk PRIMARY KEY (StudentID),
  FirstName VARCHAR (256),
  LastName VARCHAR (256),
  Register_date DATE  NOT NULL,
  RegionID INT NOT NULL ,
  StaffID INT  NOT NULL,
  CONSTRAINT fk1_region_no FOREIGN KEY (RegionID)  REFERENCES Region (RegionID),
  CONSTRAINT fk1_staff_no FOREIGN KEY (StaffID) REFERENCES Staff (StaffID)
  );

---
-- Table structure for table 'Course'
---
  CREATE TABLE Course(

  CourseID INT NOT NULL IDENTITY (1,1)
  CONSTRAINT Course_pk PRIMARY KEY (CourseID),
  Title VARCHAR (256) NOT NULL,
  Credit INT NOT NULL 
  CONSTRAINT check_credit CHECK (Credit=15 OR Credit=30)
  
  );

---
-- Table structure for table 'Enrollment'
---

CREATE TABLE Enrollment(
StudentID INT NOT NULL,
CourseID INT NOT NULL
Constraint PK_Enrollment PRIMARY KEY (StudentID , CourseID),
FOREIGN KEY (StudentID) REFERENCES Student (StudentID),
FOREIGN KEY (courseID)  REFERENCES Course (CourseID));

---
-- Table structure for table 'StaffCourse'
---

CREATE TABLE StaffCourse( 
StaffID INT NOT NULL,
CourseID INT NOT NULL,
Constraint PK_StaffCourse PRIMARY KEY (StaffID, CourseID),
FOREIGN KEY (StaffID)  REFERENCES Staff (StaffID),
FOREIGN KEY (CourseID) REFERENCES Course (CourseID)
);


--CONSTRAINTS

--- Region Check

CREATE FUNCTION check_region()
RETURNS INT
AS
BEGIN
DECLARE @region int
IF EXISTS(SELECT *
FROM Region r JOIN student s ON r.RegionID=s.RegionID JOIN Staff ss ON ss.RegionID = r.RegionID
WHERE s.RegionID != ss.RegionID)
SELECT @region =1 ELSE SELECT @region = 0;
RETURN @region;
END;


ALTER TABLE Staff
ADD CONSTRAINT check_region1 CHECK(dbo.check_region() = 0);

--- Credit Check

create function check_credit1 (
    @Title varchar(256),
    @Credit int
)
returns varchar(10)
as 
begin
    declare @credit_real tinyint
    declare @credit_result varchar(10)
    if @Title in ('Fine Arts', 'German', 'Biology')
        set @credit_real = 15
    else 
        set @credit_real = 30 
    if @Credit = @credit_real 
        set @credit_result = 'True'
    else 
        set @credit_result = 'False'
    return @credit_result
end

ALTER TABLE Course
ADD CONSTRAINT check_credit2 CHECK(dbo.check_credit1(Title, Credit) = 'True');

--- Check Course Credit

create function enrollment_constraint (
    @StudentID int,
    @CourseID int
)
returns varchar(10)
as 
begin 
    declare @total_credit int 
    declare @new_credit int
    declare @result varchar(10)
    select @total_credit = sum(c.Credit) from Course c join Enrollment e on e.CourseID = c.CourseID JOIN student s ON s.StudentID = e.StudentID where e.StudentID = @StudentID
    select @new_credit = Credit from Course where CourseID = @CourseID
    if @total_credit + @new_credit > 180
        set @result = 'False'
    else 
        set @result = 'True'
    return @result
end

ALTER TABLE Enrollment
ADD CONSTRAINT check_enrollment1 CHECK(dbo.enrollment_constraint(StudentID,CourseID) = 'True');