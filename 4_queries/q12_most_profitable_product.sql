-- Для каждого клиента определить наиболее прибыльный продукт
WITH client_product_profit AS (
    SELECT
         c.id AS client_id,
         c.first_name,
         p.id AS product_id,
         pt.name AS product_type,
         COALESCE(SUM(o.amount * cu.rate_to_rub), 0) AS total_profit
    FROM client c
    JOIN product p ON p.client_id = c.id
	JOIN currency cu ON cu.id = p.currency_id
    JOIN product_type pt ON pt.id = p.product_type_id
    LEFT JOIN operation o ON o.product_id = p.id
        AND o.operation_type_id = (
            SELECT id FROM operation_type WHERE name = 'Начисление процентов'
        )
    GROUP BY c.id, c.first_name, p.id, pt.name
)
SELECT DISTINCT ON (client_id)
    client_id,
    first_name,
    product_id,
    product_type,
    total_profit
FROM client_product_profit
ORDER BY client_id, total_profit DESC;
-- Ваш SQL код здесь
