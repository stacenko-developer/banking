-- Клиенты с переводами, значительно превышающими средние значения по системе
WITH avg_transfer AS (
	SELECT COALESCE(AVG(o.amount), 0) avg_transfer_value
	FROM operation o
	JOIN operation_type ot ON o.operation_type_id = ot.id
	WHERE ot.name = 'Снятие'
)
SELECT * FROM client c
WHERE EXISTS (
	SELECT 1 FROM operation o
	JOIN product p ON o.product_id = p.id
	JOIN operation_type ot ON o.operation_type_id = ot.id
	WHERE ot.name = 'Снятие' AND c.id = p.client_id AND o.amount > (SELECT avg_transfer_value FROM avg_transfer) * 2
);
-- Ваш SQL код здесь
