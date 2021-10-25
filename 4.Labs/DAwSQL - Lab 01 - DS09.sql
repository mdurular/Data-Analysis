

-- DAwSQL-Lab1 (22.10.2021)

-- İlk olarak boş bir tablo oluşturuyoruz.
CREATE TABLE assignment1 
(
Sender_ID int,
Receiver_ID int,
Amount int,
Transaction_Date date
)
;

-- Tablomuzu test edelim
SELECT	*
FROM	assignment1;

-- Örnek olarak 1 satır verişi yapalım
INSERT INTO assignment1 (Sender_id, Receiver_id, Amount, Transaction_date)
VALUES (10, 100, 1000, '2021-10-22')
;

-- Sadece bir sütuna birden fazla satır veri girişi yapmak istiyorsak:
INSERT INTO assignment1 (Sender_id)
VALUES (11), (22), (22), (23)
;

-- Tablomuzu silip assignment için yeniden oluşturalım:
DROP TABLE assignment1;

-- Assignment da belirtilen verilerin girişini yapalım:
INSERT INTO assignment1 (Sender_id, Receiver_id, Amount, Transaction_date)
VALUES 
(55, 22, 500, '2021-05-18'),
(11, 33, 350, '2021-05-19'),
(22, 11, 650, '2021-05-19'),
(22, 33, 900, '2021-05-20'),
(33, 11, 500, '2021-05-21'),
(33, 22, 750, '2021-05-21'),
(11, 44, 300, '2021-05-22')
;

-- Herbir müşterinin aldığı toplam tutar
SELECT	sender_id, SUM(amount) AS send_amount
FROM	assignment1
GROUP BY sender_id
;

-- Herbir müşterinin gönderdiği toplam tutar
SELECT	receiver_id, SUM(amount) AS receive_amount
FROM	assignment1
GROUP BY receiver_id
;

-- Gönderilen ve alınan toplam tutar sonuçlarını FULL OUTER JOIN ile birleştiriyoruz.
-- Çıkan sonuçta NULL kayıtlardan dolayı COALESCE fonksiyonu ile doğru sonuçları derliyoruz.
SELECT	COALESCE(S.sender_id, R.receiver_id) AS Account_ID,
		COALESCE(R.receive_amount, 0) - COALESCE(S.send_amount, 0) AS Net_Change
FROM	(
		SELECT	sender_id, SUM(amount) AS send_amount
		FROM	assignment1
		GROUP BY sender_id
		) S
FULL OUTER JOIN	
		(
		SELECT	receiver_id, SUM(amount) AS receive_amount
		FROM	assignment1
		GROUP BY receiver_id
		) R
ON		S.Sender_id = R.receiver_id
;

-- Example (SampleSales Database)
-- Write a query that returns the average prices according to brands and categories.
SELECT	B.brand_name, C.category_name, AVG(P.list_price) average_price
FROM	product.product P
LEFT JOIN product.brand B
ON		B.brand_id = P.brand_id
LEFT JOIN product.category C
ON		P.category_id = C.category_id
GROUP BY B.brand_name, C.category_name
;