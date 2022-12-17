-- Args
--
-- $1::integer              - Customer id
-- $2::varchar[]            - Statuses to show

SELECT
    o.status,
    json_strip_nulls(json_agg(json_build_object(
        'id', o.id,
        'source_address', p1.address,
        'delivery_address', p2.address,
        'return_address', p3.address
    ))) AS orders
FROM orders o
LEFT JOIN points p1 ON p1.id = o.source_point_id
LEFT JOIN points p2 ON p2.id = o.delivery_point_id
LEFT JOIN points p3 ON p3.id = o.return_point_id
WHERE customer_id = $1::integer AND status = ANY($2::varchar[])
GROUP BY o.status
