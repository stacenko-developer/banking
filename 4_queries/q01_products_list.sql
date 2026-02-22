-- Список всех активных вкладов или накопительных счетов конкретного клиента с названием продукта
SELECT
    p.id,
    p.opened_at,
    pt.name,
	c.name,
    p.interest_rate
FROM product p
JOIN product_type pt ON p.product_type_id = pt.id
JOIN currency c ON p.currency_id = c.id
JOIN status s ON p.status_id = s.id
WHERE p.client_id = 2 AND s.name = 'OPEN' AND pt.name IN ('Вклад', 'Накопительный счет');
-- Ваш SQL код здесь
