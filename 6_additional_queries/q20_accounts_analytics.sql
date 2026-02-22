-- Аналитика по каждому клиенту: суммы и количество операций для открытых и заблокированных счетов за октябрь 2025
SELECT
	c.id,
	c.first_name,
	COALESCE(SUM(o.amount) FILTER (WHERE s.name = 'OPEN'), 0) AS open_products_amount,
	COALESCE(SUM(o.amount) FILTER (WHERE s.name = 'BLOCKED'), 0) AS blocked_products_amount,
	COALESCE(COUNT(o.id) FILTER (WHERE s.name = 'OPEN'), 0) AS open_products_operations_count,
	COALESCE(COUNT(o.id) FILTER (WHERE s.name = 'BLOCKED'), 0) AS blocked_products_operations_count
FROM client c
LEFT JOIN product p ON p.client_id = c.id
LEFT JOIN status s ON p.status_id = s.id
LEFT JOIN operation o ON p.id = o.product_id AND o.created_at >= '2025-10-01' AND o.created_at <= '2025-10-31'
GROUP BY c.id, c.first_name;
-- Ваш SQL код здесь
