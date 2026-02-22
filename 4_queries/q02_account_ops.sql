-- Все операции по выбранному счёту за период с названием продукта
SELECT
	o.id,
	o.created_at,
	o.amount,
	ot.name,
	o.balance_after_operation,
	pt.name,
	c.name
FROM operation o
JOIN operation_type ot ON o.operation_type_id = ot.id
JOIN product p ON o.product_id = p.id
JOIN currency c ON p.currency_id = c.id
JOIN product_type pt ON p.product_type_id = pt.id
WHERE o.product_id = 1 AND o.created_at >= '2015-01-01' AND o.created_at < '2016-01-01';
-- Ваш SQL код здесь
