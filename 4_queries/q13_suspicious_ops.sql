-- Счета с подозрительно большим числом операций за короткий период
SELECT
	o.product_id,
	COUNT(o.id)
FROM operation o
WHERE o.created_at >= '2015-01-01 00:00:00' AND o.created_at < '2015-01-02 00:00:00'
GROUP BY o.product_id
HAVING COUNT(o.id) > 100;
-- Ваш SQL код здесь
