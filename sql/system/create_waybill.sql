-- Args
--
-- $1::integer              - Driver id
-- $2::waybill_point[]      - Message ids

WITH waybill AS (
    INSERT INTO waybills (driver_id)
    VALUES ($1)
    RETURNING id
)

INSERT INTO waybill_points (point_id, order_id, waybill_id, type, visit_order, visited)
SELECT 
    wp.point_id,
    wp.order_id,
    (SELECT id FROM waybill),
    wp.type,
    wp.visit_order,
    FALSE
FROM UNNEST($2::waybill_point[]) wp
RETURNING (SELECT id FROM waybill);
