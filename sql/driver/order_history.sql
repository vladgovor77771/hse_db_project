-- Args
--
-- $1::integer              - Driver id

SELECT
    o.id,
    o.customer_id,
    o.source_point_id,
    p1.address AS source_address,
    p2.address AS delivery_address,
    p3.address AS return_address,
    o.status,
    w.id AS waybill_id,
    d.first_name as customer_first_name,
    d.last_name as customer_last_name
FROM orders o
LEFT JOIN points p1 ON p1.id = o.source_point_id
LEFT JOIN points p2 ON p2.id = o.delivery_point_id
LEFT JOIN points p3 ON p3.id = o.return_point_id
LEFT JOIN customers c ON c.id = o.customer_id
LEFT JOIN personal_data d ON d.id = c.personal_data_id
RIGHT JOIN waybills w ON w.id = o.waybill_id
WHERE w.driver_id = $1::integer;