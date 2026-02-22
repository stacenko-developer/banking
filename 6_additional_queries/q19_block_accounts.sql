-- Заблокировать счета с суммой операций за октябрь 2025 > 1_000_000 и вывести их
WITH products_to_block AS (
    SELECT
        p.id AS product_id
    FROM product p
    JOIN operation o ON o.product_id = p.id AND o.created_at >= '2025-10-01' AND o.created_at <= '2025-10-31'
    GROUP BY p.id
    HAVING SUM(o.amount) > 1000000
),
blocked_products AS (
    UPDATE product p
    SET status_id = (SELECT id FROM status WHERE name = 'BLOCKED')
    FROM products_to_block ptb
    WHERE p.id = ptb.product_id
    RETURNING p.id AS product_id, p.status_id
)
INSERT INTO product_status_history (product_id, status_id)
SELECT
    bp.product_id,
    bp.status_id
FROM blocked_products bp
RETURNING
    product_id,
    (SELECT name FROM product_type WHERE id = (
        SELECT product_type_id FROM product WHERE id = product_id
    )) AS product_type,
    (SELECT name FROM status WHERE id = status_id) AS new_status;
-- Ваш SQL код здесь
