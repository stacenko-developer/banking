-- Клиенты с суммой снятий свыше 1000000 руб. за месяц
SELECT p.client_id, SUM(o.amount), COUNT(o.id) FILTER (WHERE o.amount > 100000) FROM product p
JOIN product_type pt ON p.product_type_id = pt.id
JOIN operation o ON p.id = o.product_id
JOIN operation_type ot ON ot.id = o.operation_type_id
WHERE ot.name = 'Снятие' AND pt.name = 'Накопительный счет' AND o.created_at >= CURRENT_TIMESTAMP - INTERVAL '1 MONTH'
GROUP BY p.client_id
HAVING SUM(o.amount) > 1000000
ORDER BY SUM(o.amount) DESC;
-- Ваш SQL код здесь
