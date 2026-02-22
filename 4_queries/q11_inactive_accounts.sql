-- Счета без операций дольше указанного количества дней
WITH last_operations AS (
    SELECT
        product_id,
        MAX(created_at) AS last_operation_date
    FROM operation
    GROUP BY product_id
)
SELECT p.*
FROM product p
LEFT JOIN last_operations lo ON lo.product_id = p.id
WHERE lo.last_operation_date IS NULL OR lo.last_operation_date <= CURRENT_DATE - INTERVAL '30 days';
-- Ваш SQL код здесь
