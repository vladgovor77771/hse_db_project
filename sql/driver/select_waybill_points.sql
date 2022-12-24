-- Args
--
-- $1::integer              - Waybill id

SELECT
    wp.point_id,
    wp.order_id,
    wp.waybill_id,
    wp.type,
    wp.visit_order,
    wp.visited,
    p.address,
    pc.longitude,
    pc.latitude
FROM waybill_points wp
LEFT JOIN points p ON p.id = wp.point_id
LEFT JOIN points_coordinates pc ON pc.id = p.coordinates_id
WHERE wp.waybill_id = $1::integer
ORDER BY wp.visit_order ASC;
