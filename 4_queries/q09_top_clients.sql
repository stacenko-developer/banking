-- Пять клиентов с наибольшим оборотом операций за период
SELECT
	c.id AS client_id,
	COALESCE(SUM(o.amount), 0) AS total_amount
FROM client c
LEFT JOIN product p ON p.client_id = c.id
LEFT JOIN operation o ON o.product_id = p.id AND o.created_at BETWEEN '2015-01-01' AND '2020-11-30'
GROUP BY c.id
ORDER BY total_amount DESC
LIMIT 5;
-- Ваш SQL код здесь
