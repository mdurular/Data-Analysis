



CREATE DATABASE LibraryDatabase;

USE LibraryDatabase


CREATE SCHEMA Book;
---
CREATE SCHEMA Person;




--create Book.Author table



CREATE TABLE [Book].[Author](
	[Author_ID] [int],
	[Author_FirstName] [nvarchar](50) Not NULL,
	[Author_LastName] [nvarchar](50) Not NULL
	);



	
--create Publisher Table

CREATE TABLE [Book].[Publisher](
	[Publisher_ID] [int] PRIMARY KEY IDENTITY(1,1) NOT NULL,
	[Publisher_Name] [nvarchar](100) NULL
	);



--create Book.Book table
CREATE TABLE [Book].[Book](
	[Book_ID] [int] PRIMARY KEY NOT NULL,
	[Book_Name] [nvarchar](50) NOT NULL,
	Author_ID INT NOT NULL,
	Publisher_ID INT NOT NULL
	);



--create Person.Person table

CREATE TABLE [Person].[Person](
	[SSN] [bigint] PRIMARY KEY NOT NULL,
	[Person_FirstName] [nvarchar](50) NULL,
	[Person_LastName] [nvarchar](50) NULL
	);


--cretae Person.Person_Mail table

CREATE TABLE [Person].[Person_Mail](
	[Mail_ID] INT PRIMARY KEY IDENTITY (1,1),
	[Mail] NVARCHAR(MAX) NOT NULL,
	[SSN] BIGINT UNIQUE NOT NULL	
	);


	--cretae Person.Person_Phone table

CREATE TABLE [Person].[Person_Phone](
	[Phone_Number] INT PRIMARY KEY NOT NULL,
	[SSN] [bigint] NOT NULL	
	);



--create Person.Loan table

CREATE TABLE [Person].[Loan](
	[SSN] BIGINT NOT NULL,
	[Book_ID] INT NOT NULL,
	PRIMARY KEY ([SSN], [Book_ID])
	);



--INSERT 



INSERT INTO Person.Person (SSN, Person_FirstName, Person_LastName) VALUES (75056659595,'Zehra', 'Tekin')

INSERT Person.Person (SSN, Person_FirstName, Person_LastName) VALUES (75056659595,'Zehra', 'Tekin')


INSERT INTO Person.Person (SSN, Person_FirstName) VALUES (889623212466,'Kerem', 'ATLI')

INSERT INTO Person.Person (SSN, Person_FirstName) VALUES (889623212466,'Kerem')


INSERT INTO Person.Person VALUES (889623212886,'Kerem', NULL)


INSERT Person.Person VALUES (88232556264,'Metin','Sakin')
INSERT Person.Person VALUES (35532888963,'Ali','Tekin')


INSERT INTO Person.Person_Mail (Mail, SSN) 
VALUES ('zehtek@gmail.com', 75056659595),
	   ('meyet@gmail.com', 15078893526),
	   ('metsak@gmail.com', 35532558963)



SELECT * FROM Person.Person_Mail 



--SELECT INTO


SELECT * FROM Person.Person_2


select * into Person.Person_2 from Person.Person


---INSERT INTO SELECT

SELECT * FROM Person.Person_2


INSERT Person.Person_2 (SSN, Person_FirstName, Person_LastName)

SELECT * 
FROM Person.Person 
where Person_FirstName like 'A%'



SELECT * FROM Book.Publisher

--Insert default values

INSERT Book.Publisher
DEFAULT VALUES



---UPDATE



SELECT * FROM Person.Person_2

SELECT * FROM Person.Person

UPDATE Person.Person_2 SET Person_LastName = 'DEFAULT' 


UPDATE Person.Person_2 SET Person_LastName = 'Atýcý' WHERE SSN = 889623212886




UPDATE Person.Person
SET Person_LastName = B.Person_LastName 
FROM Person.Person A, Person.Person_2 B 
WHERE A.SSN = B.SSN
AND	A.SSN = 889623212886


UPDATE Person.Person SET Person_LastName = (SELECT Person_LastName FROM Person.Person_2 WHERE SSN = 889623212466) WHERE SSN = 889623212466

SELECT * FROM Person.Person


----

--DELETE

insert Book.Publisher values ('Ýþ Bankasý Kültür Yayýncýlýk'), ('Can Yayýncýlýk'), ('Ýletiþim Yayýncýlýk')


SELECT * FROM Book.Publisher


DELETE FROM Book.Publisher WHERE Publisher_Name IS NULL


DELETE FROM Book.Publisher


insert Book.Publisher values ('ÝLETÝÞÝM')



---


DROP TABLE Person.Person_2;--Artýk ihtiyacýmýz yok.

TRUNCATE TABLE Person.Person_Mail;
TRUNCATE TABLE Person.Person;
TRUNCATE TABLE Book.Publisher;



-------------------

--Author
ALTER TABLE Book.Author ADD CONSTRAINT pk_author PRIMARY KEY (Author_ID)

ALTER TABLE Book.Author ALTER COLUMN Author_ID INT NOT NULL


---Book

ALTER TABLE Book.Book ADD CONSTRAINT FK_Author FOREIGN KEY (Author_ID) REFERENCES Book.Author (Author_ID)


ALTER TABLE Book.Book ADD CONSTRAINT FK_Publisher FOREIGN KEY (Publisher_ID) REFERENCES Book.Publisher (Publisher_ID)


--person.person_mail

Alter table Person.Person_Mail add constraint FK_Person4 Foreign key (SSN) References Person.Person(SSN)


--person.person_phone



Alter table Person.Person_Phone add constraint FK_Person2 Foreign key (SSN) References Person.Person(SSN)


---person.loan

ALTER TABLE Person.Loan ADD CONSTRAINT FK_PERSON FOREIGN KEY (SSN) REFERENCES Person.Person (SSN)
ON UPDATE cascade
ON DELETE NO ACTION


ALTER TABLE Person.Loan ADD CONSTRAINT FK_book FOREIGN KEY (Book_ID) REFERENCES Book.Book (Book_ID)
ON UPDATE NO ACTION
ON DELETE CASCADE

