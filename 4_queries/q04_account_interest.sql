-- Сумма начисленных процентов на конкретный счёт за период
SELECT COALESCE(SUM(o.amount), 0)
FROM operation o
JOIN operation_type ot ON o.operation_type_id = ot.id
WHERE o.product_id = 5 AND ot.name = 'Начисление процентов' AND o.created_at >= '2016-01-01' AND o.created_at < '2017-01-01';
-- Ваш SQL код здесь
