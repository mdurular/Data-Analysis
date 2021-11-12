-- *** RECURSIVE CTEs ***

-- 1'DEN 10'A KADAR B�R �NCEK� SAYININ 2 �LE �ARPIMINI G�STER�N

with recur as 
(
    select 1 as num, 1 as num_2  -- bu sat�r �anchor�: tan�mlama yapar ve bir sefer �al���r
    union all                    -- num 10 oluncaya kadar 9 kez (d�ng�yle) ekleme yapar
    select num + 1, num_2 * 2 
    from recur 
    where num < 10               -- �nce from/where sonra select �al���r
)
select * from recur

-- EN �ST SATIRDA 10 YILDIZ, M�TEAK�P HER ALT SATIRDA B�R AZALAN YILZDIZ BASIN

WITH Recursive_CTE AS (
    
    SELECT 10 AS counter
    UNION ALL
    SELECT counter - 1
    FROM Recursive_CTE
    WHERE counter > 0
)
SELECT REPLICATE('* ', counter)
FROM Recursive_CTE

-- 1 RAKAMLARINDAN OLU�AN VE SA� A�A�IYA DO�RU GEN��LEYEN B�R D�K ��GEN, 
-- YANINDA 2 RAKAMLARINDAN OLU�AN VE SOL A�A�IYA DO�RU DARALAN B�R D�K ��GEN,
-- ONUN DA SA�INDA 3 RAKAMLARINDAN OLU�AN VE SA� A�A�IYA DO�RU GEN��LEYEN B�R D�K ��GEN, 
-- ONUN DA SA�INDA 4 RAKAMLARINDAN OLU�AN VE SOL A�A�IYA DO�RU DARALAN B�R D�K ��GEN,
-- HEPS�N�N B�RLE��M�NDEN OLU�AN VE KARE �EKL� ALAN TABLOYU OLU�TURUN.

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