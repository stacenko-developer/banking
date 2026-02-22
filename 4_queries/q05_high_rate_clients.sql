-- Клиенты с хотя бы одним продуктом со ставкой выше указанного значения
SELECT c.*
FROM client c
WHERE EXISTS (
    SELECT 1
    FROM product p
    WHERE p.client_id = c.id AND p.interest_rate > 12
);
-- Ваш SQL код здесь
