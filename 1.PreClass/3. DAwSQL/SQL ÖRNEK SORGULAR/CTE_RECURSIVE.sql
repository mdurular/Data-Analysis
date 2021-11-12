-- *** RECURSIVE CTEs ***

-- 1'DEN 10'A KADAR BÝR ÖNCEKÝ SAYININ 2 ÝLE ÇARPIMINI GÖSTERÝN

with recur as 
(
    select 1 as num, 1 as num_2  -- bu satýr “anchor”: tanýmlama yapar ve bir sefer çalýþýr
    union all                    -- num 10 oluncaya kadar 9 kez (döngüyle) ekleme yapar
    select num + 1, num_2 * 2 
    from recur 
    where num < 10               -- önce from/where sonra select çalýþýr
)
select * from recur

-- EN ÜST SATIRDA 10 YILDIZ, MÜTEAKÝP HER ALT SATIRDA BÝR AZALAN YILZDIZ BASIN

WITH Recursive_CTE AS (
    
    SELECT 10 AS counter
    UNION ALL
    SELECT counter - 1
    FROM Recursive_CTE
    WHERE counter > 0
)
SELECT REPLICATE('* ', counter)
FROM Recursive_CTE

-- 1 RAKAMLARINDAN OLUÞAN VE SAÐ AÞAÐIYA DOÐRU GENÝÞLEYEN BÝR DÝK ÜÇGEN, 
-- YANINDA 2 RAKAMLARINDAN OLUÞAN VE SOL AÞAÐIYA DOÐRU DARALAN BÝR DÝK ÜÇGEN,
-- ONUN DA SAÐINDA 3 RAKAMLARINDAN OLUÞAN VE SAÐ AÞAÐIYA DOÐRU GENÝÞLEYEN BÝR DÝK ÜÇGEN, 
-- ONUN DA SAÐINDA 4 RAKAMLARINDAN OLUÞAN VE SOL AÞAÐIYA DOÐRU DARALAN BÝR DÝK ÜÇGEN,
-- HEPSÝNÝN BÝRLEÞÝMÝNDEN OLUÞAN VE KARE ÞEKLÝ ALAN TABLOYU OLUÞTURUN.

WITH Recursive_CTE AS (
    SELECT 1 AS c1, 10 AS c2, 1 AS c3, 10 AS c4
    UNION ALL
    SELECT c1 + 1, c2 - 1, c3 + 1, c4 - 1
    FROM Recursive_CTE
    WHERE c1 < 10
)
SELECT REPLICATE('1', c1), REPLICATE('2', c2), REPLICATE('3', c3), REPLICATE('4', c4),
REPLICATE('1', c1) + '-' + REPLICATE('2', c2) + '-' + REPLICATE('3', c3) + '-' + REPLICATE('4', c4)
FROM Recursive_CTE