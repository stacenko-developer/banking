-- Рейтинг продуктов по приросту активов за 90 дней
SELECT
	p.id,
	COALESCE(SUM(o.amount), 0) AS totat_amount FROM product p
LEFT JOIN operation o ON o.product_id = p.id
LEFT JOIN operation_type ot ON ot.id = o.operation_type_id
WHERE ot.name IS NULL OR o.created_at >= CURRENT_TIMESTAMP - INTERVAL '90 DAYS'
GROUP BY p.id
ORDER BY totat_amount DESC;
-- Ваш SQL код здесь
