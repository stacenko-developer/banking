-- Вывести все счета клиента, доступные для операций, с суммой операций за октябрь 2025
SELECT
	p.id AS product_id,
	pt.name AS product_name,
	s.name AS status_name,
	COALESCE(SUM(o.amount), 0)
FROM product p
JOIN product_type pt ON p.product_type_id = pt.id
JOIN status s ON s.id = p.status_id
LEFT JOIN operation o ON o.product_id = p.id AND o.created_at >= '2025-10-01' AND o.created_at <= '2025-10-31'
WHERE p.client_id = 1 AND s.name = 'OPEN'
GROUP BY p.id, pt.name, s.name;
-- Ваш SQL код здесь
