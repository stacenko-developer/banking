-- Клиенты с более чем одним вкладом или счётом
SELECT
	c.id,
	COUNT(p.id)
FROM client c
JOIN product p ON p.client_id = c.id
JOIN product_type pt ON pt.id = p.product_type_id
WHERE pt.name IN ('Вклад', 'Накопительный счет')
GROUP BY c.id
HAVING COUNT(p.id) > 1;
-- Ваш SQL код здесь
