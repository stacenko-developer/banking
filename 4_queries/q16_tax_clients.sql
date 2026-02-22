-- Клиенты с прибылью выше 250000 руб. и сумма налога 13%
SELECT p.client_id, (SUM(o.amount) - 250000) * 0.13 AS "Налог" FROM product p
JOIN operation o ON p.id = o.product_id
JOIN operation_type ot ON ot.id = o.operation_type_id
WHERE ot.name = 'Начисление процентов' AND o.created_at >= '2010-01-01' AND o.created_at < '2011-01-01'
GROUP BY p.client_id
HAVING SUM(o.amount) > 250000;
-- Ваш SQL код здесь
