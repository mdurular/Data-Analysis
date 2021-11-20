--====================================================================================================
-------------------------------------- SQL PROGRAMMING WITH T-SQL ------------------------------------
--====================================================================================================

-------------------------- STORED PROCEDURE BASICS --------------------------

---------- To Create a Stored Procedure:

USE movies
GO -- This 'GO' should be put here since 'create procedure' should be the first statement in one batch

CREATE PROCEDURE (OR PROC) spfilmlist
AS
BEGIN
	SELECT *
	FROM tblfilm
	ORDER BY filmname ASC
END

---------- To Execute a Stored Procedure:

EXECUTE spfilmlist -- EXECUTE yerine EXEC de kullanilabilir

---------- To Modify a Stored Procedure:

    -- If we still have the code in hand:

USE movies
GO 

ALTER PROCEDURE (OR PROC) spfilmlist
AS
BEGIN
	SELECT *
	FROM tblfilm
	ORDER BY filmname DESC
END

    -- If we don't have the code in hand:

/* Explorer menusunden hangi database'de isek o secilir, onun altinda stored procedure secilir, sonrasinda
programmability'den belirtilen stored procedure secilir ve sag ile tiklanarak modify secilir. Bundan
sonra ekrana stored procedure'un kodu gelir. Bu kod uzerinden degisiklik yapilabilir. */

---------- To Delete a Stored Procedure:

DROP PROC spfilmlist

-------------------------- STORED PROCEDURE PARAMETERS -----------------------

---------- To Create a Stored Procedure with a Parameter:

use movies
go

create proc spfilmcriteria(@minlength as int)
as
begin
	select filmname, filmruntimeminutes
	from tblfilm
	where filmruntimeminutes > @minlength
	order by filmruntimeminutes asc
end

---------- To Execute the Procedure:

exec spfilmcriteria 180

---------- To Add Multiple Parameters:

use movies
go

alter proc spfilmcriteria
	(@minlength as int,
	@maxlength as int)
as
begin
	select filmname, filmruntimeminutes
	from tblfilm
	where filmruntimeminutes >= @minlength and
				filmruntimeminutes <= @maxlength
	order by filmruntimeminutes asc
end

---------- To Execute the Above Code:

exec spfilmcriteria 150, 180 

exec spfilmcriteria @minlength=150, @maxlength=180  -- Bu sekilde de olur, hatta daha da net olur.

---------- To Add a Text Parameter:

use movies
go

alter proc spfilmcriteria
	(@minlength as int,
	@maxlength as int,
	@title as varchar(max))
as
begin
	select filmname, filmruntimeminutes
	from tblfilm
	where filmruntimeminutes >= @minlength and
				filmruntimeminutes <= @maxlength and
				filmname like '%' + @title + '%'
	order by filmruntimeminutes asc
end

---------- To Execute the Above Code:

exec spfilmcriteria @minlength=150, @maxlength=180, @title='star'

---------- To Add an Optional Parameter:

use movies
go

alter proc spfilmcriteria
	(@minlength as int = 0,
	@maxlength as int,
	@title as varchar(max))
as
begin
	select filmname, filmruntimeminutes
	from tblfilm
	where filmruntimeminutes >= @minlength and
				filmruntimeminutes <= @maxlength and
				filmname like '%' + @title + '%'
	order by filmruntimeminutes asc
end

---------- To Execute the Above Code:

exec spfilmcriteria @maxlength=180, @title='die'
            -- minlength icin zaten default bir deger oldugu icin bir deger assign etmek zorunda degilim.
            -- Ancak, istersem yeni bir deger atayabilirim.

---------- To Add an Optional Parameter as Null:

        -- Eger parametrelere hangi sinirlari koyacagimizdan emin degilsek, bu durumda
        -- null atamasi yapabiliriz. Ancak bu durumu where clause'da duzeltmemiz gerekir.
use movies
go

alter proc spfilmcriteria
	(@minlength as int = null,
	@maxlength as int = null,
	@title as varchar(max))
as
begin
	select filmname, filmruntimeminutes
	from tblfilm
	where (@minlenght is null or filmruntimeminutes >= @minlength) and
				(@maxlength is null or filmruntimeminutes <= @maxlength) and
				filmname like '%' + @title + '%'
	order by filmruntimeminutes asc
end
        /* Eger stored procedure cagirilirken minlength ve maxlength icin bir deger
        girilmezse, bu iki degiskenin bir anlami kalmiyor. Sadece deger girildiginde 
        anlam ifade ediyor. */

--------------------------------- VARIABLES ----------------------------------

---------- To Declare a Variable and Assign a Value to the Variable:

declare @mydate as datetime

set @mydate = '1970-01-01'

select filmname as name, filmreleasedate as date
from tblfilm
where filmreleasedate >= @mydate

----------

declare @mydate as datetime
declare @numfilms as int

set @mydate = '1970-01-01'
set @numfilms = (select count(*) from tblfilms where filmreleasedate >= @mydate)

select 'number of films', @numfilms

----------

print 'number of films' + cast(@numfilms as varchar(max))
        -- Bu sekilde print ile kullanilirsa tablo olarak degil de messages olarak gorunur.

----------

SET NOCOUNT ON
        /* Eger query'nin en basina yazarsam ciktida kac row'un bu query'den etkilendigi 
        ile ilgili bir bilgilendirme olmayacak. */

---------- To Assign Values to Variables in the Select Statement:

declare @id int
declare @name varchar(max)
declare @date datetime

select top 1 @id = actorid, @name = actorname, @date = actordob
from tblactor
where actordob >= '1970-01-01'
order by actordob asc

---------- To Accumulate Values in Variables:

declare @namelist varchar(max)
set @namelist = ''

select @namelist = @namelist + actorname + ', '
from tblactor
where year(actordob) = 1970

----------

declare @namelist varchar(max)
set @namelist = ''

select @namelist = @namelist + actorname + char(10)
from tblactor
where year(actordob) = 1970
    -- char(10) kullandigimizda tum degerleri alt alta yazdirmis oluruz.
    -- python'daki \n karakterinin yaptigi isi yapiyor.

---------- Global Variables:

select @@servername -- servername ne ise onu gosteriyor

select @@version -- calistigim versiyonu veriyor

select @@rowcount -- calisan kod sonucunda kac satir donduyse onu gosteriyor

------------------------------- OUTPUT PARAMETERS AND RETURN VALUES ------------------------------

---------- To Create:

use movies
go 

create proc spfilmsinyear
	(@year int,
	 @filmlist varchar(max) output, 
	 @filmcount int output)
as
begin 
	declare @films varchar(max)
	set @films = ''

	select @films = @films + filmname + ', '
	from tblfilm
	where year(filmreleasedate) = @year
	order by filmname asc

	set @filmcount = @@rowcount
	set @filmlist = @films
end

---------- To Execute the Above Code:

declare @names varchar(max)
declare @count int

exec spfilmsinyear
	@year = 2000,
	@filmlist = @names output,
	@filmcount = @count output

select @count as numberoffilms, @names as listoffilms

---------- To Add a Return Value to a Procedure:

use movies
go

create proc spfilmsinyear(@year int)
as
begin
	select filmname
	from tblfilm
	where year(filmreleasedate) = @year
	order by filmname asc

	return @@rowcount -- Buraya istenildigi kadar return value eklenebilir,
					  -- tek durum sayisal bir deger olmali
end

---------- To Execute the Above Code:

declare @row_count int

exec @row_count = spfilmsinyear @year = 2000

select @row_count as numberoffilms

-------------------------------- IF STATEMENTS ------------------------------------

declare @numfilms int

set @numfiles = (select count(*) from tblfilms where filmgenreid= 3)

if @numfilms > 5
	print 'There are too many romantic films in the database.'
else
	print 'There are no more than five romantic films.'

------------

declare @numfilms int

set @numfiles = (select count(*) from tblfilms where filmgenreid= 3)

if @numfilms > 5
	begin
		print 'Warning'
		print 'There are too many romantic films in the database.'
		end
else
	begin
		print 'Information'
		print 'There are no more than five romantic films.'
	end
        /* Eger IF icerisinde birden fazla satir islem yazilacaksa
            burada begin - end clause'lari yazilmak zorunda. */

---------- Nesting IF Statements

declare @romanticfilms int
declare @actionfilms int

set @romanticfilms = (select count(*) from tblfilms where filmgenreid= 3)
set @actionfilms = (select count(*) from tblfilms where filmgenreid= 1)

if @romanticfilms > 0
	begin
		print 'Warning'
		print 'There are too many romantic films in the database.'
		if @actionfilms > 10
			begin
				print 'Phew! There are enough action films.'
			end
		else
			begin
				print 'There are not enough action films either.'
			end
	end
else
	begin
		print 'Information'
		print 'There are no more than five romantic films.'
	end

---------- Using SELECT Statements in an IF:

use movies
go 

create proc spvariabledata
	(@infotype varchar(9) -- This can be ALL, AWARD or FINANCIAL
as
begin
	if @infotype = 'ALL'
		begin 
			(select * from tblfilm)
			return -- Return ile stored procedure islemini bitiriyoruz.
		end

	if @infotype = 'AWARD'
		begin
			(select filmname, filmoscarnominations from tblfilms)
			return
		end

	if @infotype = 'FINANCIAL'
		begin
			(select filmname, filmbudgetdollars from tblfilms)
			return
		end

	select 'You must choose ALL, AWARD or FINANCIAL.'
end

------------------------------------- WHILE LOOPS ------------------------------------

---------- In SQL Server there is only one type of loop: a WHILE loop.

declare @counter int

set @counter = 1

while @counter <= 10
	begin
		print @counter
		set @counter = @counter + 1
	end

---------- Using SELECT Statements in a Loop:

declare @counter int
declare @maxoscars int
declare @numfilms int

set @maxoscars = (select max(filmoscarwins) from tblfilm)
set @counter = 0

while @counter <= @maxoscars
	begin
		set @numfilms = (select count(*) from tblfilm where filmoscarwins = @counter)
		print cast(@numfilms as varchar(3)) + ' films have won' 
					cast(@counter as varchar(2)) + ' Oscars.'
		set @counter = @counter + 1
	end

---------- Using BREAK to Exit a Loop:

declare @counter int
declare @maxoscars int
declare @numfilms int

set @maxoscars = (select max(filmoscarwins) from tblfilm)
set @counter = 0

while @counter <= @maxoscars
	begin
		set @numfilms = (select count(*) from tblfilm where filmoscarwins = @counter)

		if @numfilms = 0 break

		print cast(@numfilms as varchar(3)) + ' films have won' 
					cast(@counter as varchar(2)) + ' Oscars.'
		set @counter = @counter + 1
	end

---------- How to Stop an Endless Loop:

declare @counter int
declare @maxoscars int
declare @numfilms int

set @maxoscars = (select max(filmoscarwins) from tblfilm)
set @counter = 0

while @counter <= @maxoscars
	begin
		set @numfilms = (select count(*) from tblfilm where filmoscarwins = @counter)

		if @numfilms = 0 break

		print cast(@numfilms as varchar(3)) + ' films have won' 
					cast(@counter as varchar(2)) + ' Oscars.'
		set @counter = @counter + 1
		/* Yukaridaki kodu yazmayi unuttugumuzda sonsuz donguye girecegi icin elle
		durdurma islemi yapmak zorundayiz. */
	end

---------- Using Loops with Cursors:

declare @filmid int
declare @filmname varchar(max)

declare filmcursor cursor for
	select filmid, filmname from tblfilm

open filmcursor

fetch next from filmcursor into @filmid, @filmname

while @@fetch_status = 0 -- Which means it is succesfully selecting a new record.
                         -- A new record means a new film in the film database.
	begin
		print 'Characters in the film ' + @filmname
		select castcharactername from tblcast where castfilmid = @filmid

		fetch next from filmcursor into @filmid, @filmname
		-- If I don't write the above code, the while loop will go to infinity.
	end

close filmcursor
deallocate filmcursor

------------------------------------ USER-DEFINED SCALAR FUNCTIONS -----------------------------------

select
	FilmName,
	,datename(DW,FilmReleaseDate) + ' ' +
	datename(D,FilmReleaseDate) + ' ' +
	datename(M,FilmReleaseDate) + ' ' +
	datename(YY,FilmReleaseDate)
from
tblFilm

---------- To Create a New Function:

use movies
go 

create function fnlongdate
	(@fulldate as datetime) -- the parameter that the function will ask for
returns varchar(max) -- the data type of the result that the function will return
as
begin
	return DATENAME(DW,@fulldate) + ' ' +
	DATENAME(D,@fulldate) + ' ' +
	DATENAME(M,@fulldate) + ' ' +
	DATENAME(YY,@fulldate)
end
        -- then we execute the code

---------- To Execute the Above Function:

SELECT
	FilmName,
	,filmreleasedate
	,dbo.fnlongdate(filmreleasedate) -- dbo ile baslamak zorundayiz
FROM
tblFilm

---------- To Modify a Function:

use movies 
go 

alter function fnlongdate
	(@fulldate as datetime) 
returns varchar(max) 
as
begin
	return datename(DW,@fulldate) + ' ' +
	datename(D,@fulldate) + ' ' +
	case
		when day(@fulldate) in (1,21,31) then 'st'
		when day(@fulldate) in (2,22) then 'nd'
		when day(@fulldate) in (3,23) then 'rd'
		else 'th'
	end + ' ' +
	datename(M,@fulldate) + ' ' +
	datename(YY,@fulldate)
end

-- This function is reusable in any query within the movie database.

select actorname, actordob, dbo.fnlongdate(actordob)
from tblactor

----------- Complex Expressions:

use movies
go 

create function fnfirstname
	(
		@fulllname as varchar(max)
	)
returns varchar(max)
as 
begin
	declare @spaceposition as int
	declare @answer as varchar(max)
	set @spaceposition = charindex(' ', @fullname)
	/* Eger Sting gibi bir sanatci ismi ile karsilasirsa, yani bosluk bulamazsa
	0 donecek ve spaceposition degiskenine 0 degerini atayacak. */
	
	if @spaceposition = 0
		set @answer = @fullname
	else
		set @answer = left(@fullname, @spaceposition - 1)

	return @answer
end

-- Then, we execute:

select actorname, dbo.fnfirstname(actorname)
from tblactor

------------------------------------ TEMPORARY TABLES ----------------------------------

---------- To Create a Temporary Table, Method 1:

select filmname, filmreleasedate 
into #tempfilms -- Temporary table icin table name oncesinde # isareti gerekli
from tblfilm
where filmname like '%star%'

select * from #tempfilms

---------- To Create a Temporary Table, Method 2:

create table #tempfilms
(
	title varchar(max),
	releasedate datetime
)
insert into #tempfilms
select filmname, filmreleasedate 
from tblfilm
where filmname like '%star%'

select * from #tempfilms

        /* Olusturulan bu temporary table sadece uretildigi dosya icerisinde calisiyor.
            Yeni bir sql file acilirsa orada calismayacak. */

---------- Global Temporary Tables:

create table ##tempfilms
(
	title varchar(max),
	releasedate datetime
)
insert into ##tempfilms
select filmname, filmreleasedate 
from tblfilm
where filmname like '%star%'

select * from #tempfilms

        -- ## ile global temporary table olusturuldu. Database icerisinde istedigimiz dosyada calisir.
        -- Eger temporary table'in olusturuldugu dosya silinirse, temporary table da siliniyor. Global da olsa siliniyor.

---------- To Explicitly Remove Temporary Tables:

drop table #tempfilms

---------- To Use Temporary Tables in Stored Procedures:

use movies 
go

create proc spinsertintotemp(@text as varchar(max))
as 
begin
	insert into #tempfilms
	select filmname, filmreleasedate
	from tblfilm
	where filmname like '%' + @text + '%'
end

----

use movies 
go 

create proc spselectfromtemp
as 
begin 
	select *
	from #tempfilms
	order by release desc
end

        -- Temporary table oncesinde iki adet stored procedure tanimlaniyor.

create table #tempfilms
(
	title varchar(max),
	release datetime
)

exec spinsertintotemp 'star'
exec spselectfromtemp

        -- Yukaridaki iki kodu ayni instance icerisinde calistirmamiz gerekiyor, yoksa hata verir.

------------------------------------- TABLE VARIABLES -----------------------------------

---------- To Declare a Table Variable:

declare @temppeople table -- Buradaki table declare ettigimiz degiskenin turu
(
	personname varchar(max),
	persondob datetime
)

----

insert into @temppeople
select actorname, actordob
from tblactor
where actordob < '1950-01-01'

----

select * from @temppeople

----------

create table #tempfilms
(
	title varchar(max),
	releasedate datetime
)
insert into #tempfilms
select filmname, filmreleasedate 
from tblfilm
where filmname like '%star%'

/* Yukaridaki kodlar incelendiginde temporary table ile table variable arasinda kodlari disinda islevsel olarak bir fark yok. 
Bu durumda, neden iki farkli kullanim var? 

1. Temporary table olusturulduktan sonra icinde olusturdugumuz file kapatilinca yok olacak. Bunun disinda table'i olustururken
kullandigimiz kodda bir degisiklik yaptigimizda kod yeniden calismayacak. Cunku ayni isimde bir tablo oldugunu belirtecek.
Bu durumda, ya farkli bir adla yeni bir tablo olusturmak gerekiyor ya da once bu tablo drop table ile drop edilecek ve sonrasinda ayni adla yeni kod calistirilacak.
2. Table variables'da ise boyle bir seye ihtiyac yok. Ayni python'daki gibi query calistikca table variable'a yeni degerler atanabilecek ve bir sorun cikmayacak. */

----------

select column_name into #temptable
from table_name

/* Bu kod temporary table icin calisirken # yerine @ yazdigimizda yani table variable kullanmak istedigimizde calismayacak, 
cunku sql server'da her degiskenin once declare edilmesi gerekiyor. */

----------------------------------- TABLE VALUED FUNCTIONS (TVF) ---------------------------------

---------- To Create a TVF:

use movies
go

create function filmsinyear
(
	@filmyear int
)
returns table -- Table data tipinde bir deger donusu olacak.
as
return 
	select filmname, filmreleasedate, filmruntimeminutes
	from tblfilm
	where year(filmreleasedate) = @filmyear

-- Then, execute this code.

---------- Using a TVF in a Query:

select filmname, filmreleasedate, filmruntimeminutes
from dbo.fimsinyear(2000)

-- Fonksiyonlardan once dbo yazilmasi zorunlu.

---------- To Modify a TVF:

use movies 
go

alter function filmsinyear
(
	@startyear int,
	@endyear int
)
returns table
as
return 
	select filmname, filmreleasedate, filmruntimeminutes
	from tblfilm
	where year(filmreleasedate) between @startyear and @endyear

----

select filmname, filmreleasedate, filmruntimeminutes
from dbo.fimsinyear(2000, 2002)

---------- Multi-Statement TVF (MSTVF):
---- To Define a MSTVF: 

use movies
go
 
create function peopleinyear
(
	@birthyear int
)
returns @t table
(
	personname varchar(max),
	persondob datetime,
	personjob varchar(8)
)
as
begin
	insert into @t
	select directorname, directordob, 'director'
	from tbdirector
	where year(directordob) = @birthyear

	insert into @t
	select actorname, actordob, 'actor'
	from tblactor
	where year(actordob) = @birthyear

	return
end

----

select *
from dbo.peopleinyear(1945)

----------------------------------- COMMON TABLE EXPRESSIONS (CTEs) ----------------------------------

with earlyfilms as
(
	select filmname, filmreleasedate, filmruntimeminutes
	from tblfilm
	where filmreleasedate < '2000-01-01'
)
select *
from earlyfilms
where filmruntimeminutes > 120

----------

with filmcounts(country, numberoffilms) as
(
	select filmcountryid, count(*)
	from tblfilm
	group by filmcountryid
)
select country, numberoffilms
from filmcounts

-- Yukaridaki gibi sutun isimlerini CTE'nin isminden sonra tanimlayabiliyoruz.

---------- Multiple CTEs:

with earlyfilms as
(
	select filmname, filmreleasedate, filmruntimeminutes
	from tblfilm
	where filmreleasedate < '2000-01-01'
),
recentfilms as
(
	select filmname, filmreleasedate, filmruntimeminutes
	from tblfilm
	where filmreleasedate >= '2000-01-01'
)
select *
from earlyfilms a join recentfilms b on a.filmname=bfilmname

-- Bu kod ayni isimle 2000 oncesinde de 2000 sonrasinda da cekilen filmleri getirecek.

---------------------------------------- CURSORS ---------------------------------------

---------- To Declare a Cursor:

declare filmcursor cursor -- Data tipi cursor oldugu icin cursor yazdik.
	for select filmid, filmname, filmreleasedate from tblfilm

open filmcursor

	fetch next from filmcursor

	while @@fetch_status = 0 -- which means that cursor successfully fetches a new record in each time.
		fetch next from filmcursor							

close filmcursor
deallocate filmcursor

----------

declare filmcursor cursor scroll
	for select filmid, filmname, filmreleasedate from tblfilm

open filmcursor

	fetch first from filmcursor -- first yerine last da diyebilirim
	                            -- last dedigimde asagida prior diyebilirim

	while @@fetch_status = 0
		fetch next from filmcursor								
		-- fetch next yerine fetch prior diyebilirim
close filmcursor
deallocate filmcursor

----------

declare filmcursor cursor scroll
	for select filmid, filmname, filmreleasedate from tblfilm

open filmcursor

	fetch absolute 10 from filmcursor

	while @@fetch_status = 0 
		fetch relative 10 from filmcursor								

close filmcursor
deallocate filmcursor

-- Bu sekilde 10'uncu record'dan baslayacak ve her seferinde 10 record atlayarak fetch islemini gerceklestirecek;
-- Eger yukarida 10 yerine her ikisi icin de -10 yazarsam, bu islemi en sondan baslayarak geriye dogru onar onar atlayarak yapacak.

---------- To Read Values into Variables:

declare @id int
declare @name varchar(max)
declare @date datetime

declare filmcursor cursor
	for select filmid, filmname, filmreleasedate from tblfilm

open filmcursor

	fetch next from filmcursor
		into @id, @name, @date

	while @@fetch_status = 0 
		fetch next from filmcursor		
			into @id, @name, @date						

close filmcursor
deallocate filmcursor

---------- To Execute Statements in a Cursor:

declare @id int
declare @name varchar(max)
declare @date datetime

declare filmcursor cursor
	for select filmid, filmname, filmreleasedate from tblfilm

open filmcursor

	fetch next from filmcursor
		into @id, @name, @date

	while @@fetch_status = 0 
		begin
			print @name + ' released on ' + convert(char(10), @date, 103),
			print '====================================================='
			print 'List of Characters'

			select castcharactername
			from tblcast
			where castfilmid=@id

			fetch next from filmcursor		
			into @id, @name, @date		
		end				

close filmcursor
deallocate filmcursor

---------- To Use Cursors in Stored Procedures:

use movies
go 

create proc splistcharacters
(
	@filmid int,
	@filmname varchar(max),
	@filmdate datetime
)
as
begin
	print @name + ' released on ' + convert(char(10), @date, 103),
	print '====================================================='
	print 'List of Characters'
	
	select castcharactername
	from tblcast
	where castfilmid=@id	
end	

-- bu kodu calistiriyoruz

declare @id int
declare @name varchar(max)
declare @date datetime

declare filmcursor cursor
	for select filmid, filmname, filmreleasedate from tblfilm

open filmcursor

	fetch next from filmcursor
		into @id, @name, @date

	while @@fetch_status = 0 
		begin

			exec splistcharacters @id, @name, @date

			fetch next from filmcursor		
			into @id, @name, @date		
		end				

close filmcursor
deallocate filmcursor

---------------------------------------- DYNAMIC SQL ---------------------------------------

---------- Using a System Stored Procedure:

execute ('select * from tblfilm') 
-- bu kodda select clause string olsa da calisiyor

----------

exec sp_executesql N'select * from tblfilm'
-- Bu kod da calisir. Yukaridaki kodla ayni degerleri dondurur.

---------- Concetenating a Dynamic SQL String:

declare @tablename nvarchar(128)
declare @sqlstring nvarchar(max)

set @tablename = N'tblfilm'

set @sqlstring = N'select * from ' + @tablename

exec sp_executesql @sqlstring

-- Bu sekilde tblfilm tablosundaki degerleri dondurebiliriz.
-- Dadece tblfilm'de degisiklik yaparak istedigimiz tablonun degerlerini dondurebiliriz.

---------- Concatenation with Numbers:

declare @number int
declare @numberstring nvarchar(4)
declare @sqlstring nvarchar(max)

set @number = 10
set @numberstring = cast(@number as nvarchar(4))

set @sqlstring = N'select top ' + @numberstring + N' * from tblfilm'

exec sp_executesql @sqlstring

-- Sadece number degiskenine atadigimiz degeri degistirerek tablonun dondurecegi degerleri degistirebiliriz.

---------- Creating a Stored Procedure:

use movies
go
 
create proc spvariabletable
(
	@tablename nvarchar(128)
)
as 
begin
	declare @sqlstring nvarchar(max)
	set @sqlstring = N'select * from ' + @tablename

	exec sp_executesql @sqlstring
end

-- Bu kodu calistirdiktan sonra,

exec spvariabletable 'tblfilm' 
-- Bu kod tblfilm tablosundaki butun degerleri dondurur.

---------- Adding Multiple Parameters:

use movies
go

create proc spvariabletable
(
	@tablename nvarchar(128),
	@number int
)
as 
begin

	declare @sqlstring nvarchar(max)
	declare @numberstring nvarchar(4)

	set @numberstring = cast(@number as nvarchar(4))
	set @sqlstring = N'select top ' + @numberstring + N' from ' + @tablename

	exec sp_executesql @sqlstring
end

-- Bu kodu calistirdiktan sonra,

exec spvariabletable 'tblfilm' 
-- Bu kod tblfilm tablosundaki butun degerleri dondurur.

---------- Using the IN Operator:

use movies 
go 

create proc spfilmyears
(
	@yearlist nvarchar(max)
)
as 
begin
	declare @sqlstring nvarchar(max)

	set @sqlstring = 
			N'select * 
				from tblfilm 
				where year(filmreleasedate) in (' + @yearlist + N')
				order by filmreleasedate'
	
	exec sp_executesql @sqlstring

end

-- Bu kodu calistirdiktan sonra,

exec spfilmyears '2000, 2001, 2002'

---------- Parameters of sp_executesql:

exec sq_executesql 
	N'select filmname, filmreleasedate, filmruntimeminutes
	from tblfilm
	where filmruntimeminutes > @length'
	,N'@length int'
	,@length = 120

/* Normalde sq_executesql stored procedure'u bir tane parametre aliyor, o da bizim query'miz. 
Ancak istersek yukarida oldugu gibi yeni bir parametreyi string olarak tanimlayip sonrasinda 
set ile deger atamasi yapabiliyoruz. */

----------

exec sq_executesql 
	N'select filmname, filmreleasedate, filmruntimeminutes
	from tblfilm
	where filmruntimeminutes > @length
	and filmreleasedate > @startdate'
	,N'@length int, @startdate datetime'
	,@length = 120
	,@startdate = '2000-01-01'

-- Birden fazla da yeni parametre eklenebiliyor.

---------- SQL Injection:

exec spvariabletable 'tblactor; drop table tbltest'

/* Buradaki durum su sekilde: arama motorlari arka planda dynamic sql calistiriyorsa, bu sekilde server'daki
bazi bilgileri tahmin ederek birden fazla islemi yaptirabilirler. Dynamic sql kullanirken bunun da farkinda olmakta fayda var. */

------------------------------------------- TRANSACTIONS ----------------------------------------------

-- In SQL Server, a transaction is like an event which occurs whenever something changes a data in your  database.

---------- Beginning a Transaction:

begin transaction -- transaction yerine tran da yazilabilir

---------- Committing a Transaction:

begin tran

insert into tblfilm (filmname, filmreleasedate)
values ('Iron Man 3', '2013-04-25')

commit -- Buraya commit, commit transaction veya commit tran da yazilabilir.

---------- Rolling Back a Transaction:

begin tran

insert into tblfilm (filmname, filmreleasedate)
values ('Iron Man 3', '2013-04-25')

select * from tblfilm where filmname = 'Iron Man 3'

rollback -- buraya rollback, rollback transaction veya rollback tran yazilabilir

select * from tblfilm where filmname = 'Iron Man 3'

/* Burada insert isleminden sonra iki select statement calisacak. Ilkinde istenilen bilgiler donecek,
ikincisinde ise insert islemi rollback yapilacagindan insert isleminde yapilanlar select ile gosterilemeyecek. */

---------- Naming a Transaction:

begin tran addironman3

insert into tblfilm (filmname, filmreleasedate)
values ('Iron Man 3', '2013-04-25')

commit addironman3

---------- Using IF Statements with Transactions:

declare @ironman int

begin tran addironman3

insert into tblfilm (filmname, filmreleasedate)
values ('Iron Man 3', '2013-04-25')

select @ironman = count(*) from tblfilm where filmname = 'Iron Man 3'

if @ironman > 1
	begin
		rollback tran addironman3
		print 'Iron Man 3 was already there.'
	end
else
	begin
		commit tran addironman3
		print 'Iron Man 3 added to database.'
	end

/* Bu kod calistirildiginda Iron Man 3 filmi ile ilgili bilgiler database'e eklenecek. 
Sonrasinda ironman degiskenine database'deki Iron Man 3 filmi bilgisi saydiriliyor. 
Eger bu sayi 1'den fazla cikarsa yapilan transaction geri aliniyor. Eger cikmazsa onceden 
database'de bu film olmadigi ve simdi eklememizle 1 oldugu sonucu cikacak. Bu durumda commit 
yaparak kalici hale getiriyoruz. */

---------- Transactions with Error Handling:

begin try
	begin tran addim
	
	insert into tblfilm (filmname, filmreleasedate)
	values ('Iron Man 3', '2013-04-25')
	
	update tblfilm
	set filmdirectorid = 'Shane Black' -- Burada, id int olmasi gerekirken string oldugu icin hata verecek.
	where filmname = 'Iron Man 3'
	
	commit tran addim
end try
	begin catch 
	rollback tran addim
	print 'Adding Iron Man failed - check data types'
end catch

/* Bu kodu calistirdigimizda kod ilk basta insert islemini yapacak, sonrasinda filmdirectorid'de hata verecek
ve catch clause'a inecek, burada da rollback yaparak insert islemini geri alacak. */

---------- Creating Nested Transactions:

begin tran tran1
	print @@trancount
	begin tran tran2
		print @@trancount
	commit tran tran2
	print @@trancount
commit tran tran1

/* Bu kodu calistirdigimizda,
1
2
1
sonucunu aliriz. @@trancount acik olan transaction sayisini veriyor. Ilk anda 1 oldugu icin ve
sonrasinda nested transaction ile acik transaction sayisi 2'ye ciktigi icin 2 yazdiriyor. En son yine 1'e dusuyor. */

---------- Transactions in Stored Procedures:

use movies 
go

create proc spgetdirector(@directorname varchar(max))
as 
begin

	declare @id int

	save tran adddirector -- eger bunu yazmasaydik rollback bu noktaya gelemeyecekti

	insert into tbldirector (directorname)
	values (@directorname)

	if (select count(*) from tbldirector where directorname = @directorname) > 1
		begin
			print 'Director already existed'
			rollback tran adddirector
		end

	select @id = directorid from tbldirector where directorname = @directorname

	return @id
end 

----

declare @directorid int

begin tran addim

	insert into tblfilm (filmname, filmreleasedate)
	values ('Iron Man 3', '2013-04-25')

	-- call stored procedure to get directorid

	exec @directorid = spgetdirector 'Shane Black'

	update tblfilm
	set filmdirectorid = @directorid
	where filmname = 'Iron Man 3'

commit tran addim

--------------------------------------- DATA MANIPULATION LANGUAGE (DML) TRIGGERS ----------------------------------------------

-- INSERT, UPDATE, AND DELETE

---------- Creating a Simple DML Trigger:

-- Ilk once hangi tabloya trigger islemi uygulayacagimizi belirlememiz gerekiyor.

use movies
go

create trigger trgactorschanged
on tblactor -- burada hangi tabloya uyarladigimizi belirtiyoruz
after insert, update, delete -- burada "after" ya da "instead of" kullanilir
as
begin
	print 'Something happened to the Actor Table'
end
go

---------- Testing a Trigger:

-- Yukaridaki trigger kodunu calistirdiktan sonra:

--turn off row counts
set nocount on

--insert a new record into the actor table
insert into tblactor (actorid, actorname)
values (999, 'test actor')

--update a record in the actor table
update tblactor
set actordob = getdate()
where actorid = 999

--delete a record from the actor table
delete from tblactor
where actorid = 999

-- Bu uc kod calistirildiginda alt alta uc defa
'Something happened to the Actor Table' -- yazdirir.

---------- Modifying a Trigger:

-- Burada trigger kodundaki create ifadesi alter ile degistirilir ve kodda istenilen degisiklikler yapilir.

use movies
go 

alter trigger trgactorschanged
on tblactor -- Burada hangi tabloya uyarladigimizi belirtiyoruz.
after insert, update, delete -- Burada "after" ya da "instead of" kullanilabilir.
as
begin
	print 'Data was changed in the Actor Table'
end
go

---------- Deleting a Trigger:

drop trigger trgactorschanged

---------- Creating INSTEAD OF Triggers:

create trigger trgactorsinserted
on tblactor -- burada hangi tabloya uyarladigimizi belirtiyoruz
instead of insert
as
begin
	raiseerror ('No more actors can be inserted.', 16, 1)
end
go

-- Yukaridaki kodu calistirdiktan sonra,

set nocount on

insert into tblactor(actorid, actorname)
values (999, 'New Actor')
go

select * from tblactor where actorid=999

/* Bu kodu calistirdigimizda hata verir ve trigger'da belirtilen hata mesaji ekrana yazdirilir. 
Ayrica select clause calisir ancak 999 numarali actor tabloya insert edilemedigi icin bos tablo doner. */

---------- The Inserted and Deleted Tables:

use movies 
go 

create trigger trgactorinserted
on tblactor
after insert
as
begin 
	select * from inserted -- inserted (deleted) tablosu database'de otomatik olusuyor.
end
go

-- Yukaridaki koddan sonra,

set nocount on

insert into tblactor(actorid, actorname)
values (999, 'New Actor')
go

/* Bu kodu calistirdigimizda ayrica bir select statement olmamasina ragmen insert yaptigimiz bilgiler
tablo seklinde dondurecek, cunku trigger'da bunu yapmasini istedik. */

----------

create trigger trgcastmemberadded
on tblcast
after insert
as
begin

	if exists (
			select *
			from tblactor a inner join inserted i on a.actorid=i.castactorid
			where actordateofdeath is not null
			)
	begin
		raiseerror ('Sorry, that actor has expired', 16,1)
		rollback transaction
		return
	end
end

/* Burada yapmaya calisilan sey su: bizim iki tablomuz var, actor tablosu ve cast tablosu. 
Cast tablosuna yeni bir veri girisi yapmak istedigimizde eger veri girisi yapilacak actorun 
actor tablosunda olum tarihi varsa yani olum tarihi null degilse, hata versin ve yapilan insert islemini geri alsin. */

-- Yukaridaki kod calistirildiktan sonra:

insert into tblcast (castid, castactorid, castfilmid, castcharactername)
values (9999, 999, 333, 'Random Red Shirt')

/* Burada, 999 numarali cast actor tablosunda ayni id ile kayitli ve bir olum tarihi var. 
Bu sebeple kod calistirildiginda hata verecek ve insert islemi gerceklesmeyecek, daha dogrusu gerceklestirildikten sonra geri alinacak. */

------------------------------------ DATA DEFINITION LANGUAGE (DDL) TRIGGERS ----------------------------------------

-- CREATE, ALTER AND DROP

-- Scoped to a databasee or a server

---------- Creating a Simple DDL Trigger:

use movies
go

create trigger trgnonewtables
on database
for create table -- Buraya yazilabilecek bircok event var, bunlar icin google'dan ddl event yazarak aramak gerekli.
as
begin 
	print 'No new tables please'
	rollback -- Yapilan create table islemini geri alacak.
end

---------- Testing a Trigger:

create table tbltest(id int)
go

/* Trigger'da verilen mesaji yazdiracak ve yeni tabloyu olusturmayacak ancak sadece movies database'inde 
gecerli bir trigger oldugu icin farkli bir database'de ayni sekilde tablo olusturdugumuzda tablo olusacaktir. */

---------- Modifying a Trigger:

use movies
go

alter trigger trgnonewtables
on database
for create table, alter table, drop table
as
begin 
	print 'No changes to tables please'
	rollback -- Yapilan create table islemini geri alacak.
end

---------- Removing a Trigger:

drop trigger trgnonewtables on database

---------- Disabling and Enabling Triggers:

use movies
go

disable trigger trgnonewtables on database -- to disable
go

enable trigger trgnonewtables on database -- to enable
go

---------- Disabling and Enabling All Triggers:

use movies
go

disable trigger all on database -- to disable all triggers in the movies database
go

enable trigger all on database -- to enable all triggers in the movies database
go

---------- Creating a Server-Scoped Trigger:

use movies
go

create trigger trgnonewtables
on all server
for create table, alter table, drop table
as
begin 
	print 'No changes to tables please'
	rollback -- Yapilan create table islemini geri alacak.
end

-- Enabling and disabling islemlerinde yukari kodlardaki gibi, sadece database yerine 'all server' yazilacak.

---------- Changing the Firing Order of Triggers:

-- Server triggers will always fire before database triggers.

use movies
go

exec sp_settriggerorder -- built-in bir stored procedure
	@triggername = 'trgfirsttrigger'
	,@order = 'first' -- Buraya first, last ya da none yazilabilir.
	,@stmttype = 'create table'
	,@namespace = 'database' -- Server icin sadece 'server' yazilmali

-- Buradaki dort parametrenin doldurulmasi zorunlu

-- Yukaridaki kod calistirildiktan sonra,

create trigger trgsecondtrigger on database
for create table as
	print 'This is the second trigger'
go

create trigger trgfirsttrigger on database
for create table as
	print 'This is the first trigger'
go

----

create table tbltest (id int)
go

/* Bu kod calistirilirsa ilk olarak 'This is the first trigger' mesaji yazdirilir, sonrasinda 
'This is the second trigger' mesaji yazdirilir. Ancak yukaridaki ilk kod calistirilmadan create table 
yapilsaydi ilk once second sonra first mesaji yazdirilacakti. */

----------------------------------------- THE PIVOT OPERATOR -----------------------------------------

select * from
	(select countryname, filmid
	from tblcountry as c inner join tblfilm as f 
			on c.countryid=f.filmcountryid) as basedata
pivot (
	count(filmid)
	for countryname
	in ([China], [France], [Germany]) -- Burayi elle yazmamak icin asagidaki kod kullanilabilir.
) as pivottable

--

select ',' + quotename(countryname, '[]') -- Ikinci parametre countryname'leri neyin icine 
										  -- almak istiyoruz. Burada default deger []
from tblcountry

-- Bu kod calistirildiktan sonra cikan sonuc kopyalanip IN operatorunun yanindaki parantezin icine yapistirilabilir.

---------- Adding Row Groups to a Pivot Table:

select * from
	(select countryname, year(filmreleasedate) as filmyear, filmid
	from tblcountry as c inner join tblfilm as f 
			on c.countryid=f.filmcountryid) as basedata
pivot (
	count(filmid)
	for countryname
	in ([China], [France], [Germany]) -- burayi elle yazmamak icin asagidaki kod
) as pivottable

/* Bu kodu calistirdigimizda ayrica birsey yapmamiza gerek kalmadan yillara gore ve ulkelere gore 
gruplandirilmis filmid count'lari pivot table'da gosterilecek. Parantez icindeki select clause'da 
filmyear degiskeni yanina baska degiskenler de eklenerek row groups sayisi artirilabilir. Ornegin 
datename(mm, filmreleasedate) denilerek her yildaki aylar da tabloda gosterilebilir.

En sonunda order by ile ortaya cikan tablo farkli sekilde siralanabilir, 'order by filmyear desc' seklinde.

Ancak sutunlari yer degistirmek ancak onlari IN operatoru icine attigimiz sekliyle mumkun. Yani ilk 
olarak hangi ulkeyi gormek istiyorsak o ulkeyi ilk siraya yazmaliyiz.*/

---------------------------------------- DYNAMIC PIVOT TABLES -----------------------------------------

declare @columnnames nvarchar(max) = ''

select @columnnames += quotename(countryname) + ','
from tblcountry

set @columnnames = left(@columnnames, len(@columnnames) - 1)

select * from
	(select countryname, filmid
	from tblcountry as c inner join tblfilm as f 
			on c.countryid=f.filmcountryid) as basedata
pivot (
	count(filmid)
	for countryname
	in ([China], [France], [Germany]) -- burayi elle yazmamak icin asagidaki kod
) as pivottable

/* Burada olusturdugumuz @columnnames degiskenini pivot table icerisindeki IN operatorunun icine direkt
olarak yazip kullanamiyoruz, bu sebeple: */

declare @columnnames nvarchar(max) = ''
declare @sql nvarchar(max) = ''

select @columnnames += quotename(countryname) + ','
from tblcountry

set @columnnames = left(@columnnames, len(@columnnames) - 1)

set @sql = 
'select * from
	(select countryname, filmid
	from tblcountry as c inner join tblfilm as f 
			on c.countryid=f.filmcountryid) as basedata
pivot (
	count(filmid)
	for countryname
	in (' + @columnnames + ')
) as pivottable'

-- Eger:
print @sql -- kodunu calistirirsak istedigimiz query'yi string olarak elde etmis oluruz.

---------- Executing a Dynamic SQL Statement:

declare @columnnames nvarchar(max) = ''
declare @sql nvarchar(max) = ''

select @columnnames += quotename(countryname) + ','
from tblcountry

set @columnnames = left(@columnnames, len(@columnnames) - 1)

set @sql = 
'select * from
	(select countryname, filmid
	from tblcountry as c inner join tblfilm as f 
			on c.countryid=f.filmcountryid) as basedata
pivot (
	count(filmid)
	for countryname
	in (' + @columnnames + ') -- burayi elle yazmamak icin asagidaki kod
) as pivottable'

execute sp_executesql @sql -- sp_executesql bir system stored procedure

/* Bu sekilde ne elde ettik: eger country tablomuzda degisiklik olursa, yeni ulkeler eklenir veya 
cikarilirsa, pivot tablosuna elle herhangi bir ekleme yapmak zorunda kalmayacagiz. Onceki halinde 
ulkeleri elle eklemek zorundaydik. */

--============================================================================================================
--------------------------------------------------- THE END ---------------------------------------------------
--============================================================================================================