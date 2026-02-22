-- Количество операций за последний месяц по каждому клиенту
SELECT
    c.id AS client_id,
    COUNT(o.id) AS operations_count
FROM client c
LEFT JOIN product p ON p.client_id = c.id
LEFT JOIN operation o ON o.product_id = p.id AND o.created_at >= CURRENT_TIMESTAMP - INTERVAL '1 month'
GROUP BY c.id;
-- Ваш SQL код здесь
