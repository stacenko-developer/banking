-- Общий объём средств на счетах определённого типа
WITH ranked_operations AS (
	SELECT
		o.balance_after_operation,
		ROW_NUMBER() OVER (
			PARTITION BY p.id
			ORDER BY o.created_at DESC
		) as rank
	FROM operation o
	JOIN product p ON o.product_id = p.id
	JOIN product_type pt ON p.product_type_id = pt.id
	WHERE pt.name = 'Накопительный счет'
)
SELECT COALESCE(SUM(ro.balance_after_operation), 0) FROM ranked_operations ro
WHERE ro.rank = 1;
-- Ваш SQL код здесь
