-- Продукты, по которым ставка изменялась хотя бы раз за последний год
SELECT * FROM product p
WHERE EXISTS (
	SELECT 1 FROM interest_rate_history irh
	WHERE irh.product_type_id = p.product_type_id AND irh.started_at >= CURRENT_DATE - INTERVAL '1 YEAR'
);
-- Ваш SQL код здесь
