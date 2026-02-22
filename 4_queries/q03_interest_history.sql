-- Хронологическая история изменений процентной ставки для продуктов с активными счетами
SELECT
	pt.name,
	irh.interest_rate,
	irh.started_at
FROM interest_rate_history irh
JOIN product_type pt ON irh.product_type_id = pt.id
WHERE EXISTS (
	SELECT 1 FROM product p
	JOIN status s ON s.id = p.status_id
	WHERE irh.product_type_id = p.product_type_id AND s.name = 'OPEN'
)
ORDER BY pt.name, irh.started_at;
-- Ваш SQL код здесь
