-- Args
--
-- $1::integer              - Customer id
-- $2::customer_item[]      - Type customer_order instance
-- $3::integer              - source point id
-- $4::integer              - delivery point id
-- $5::integer              - return point id

WITH order AS (
    INSERT INTO orders (
        customer_id,
        source_point_id,
        delivery_point_id,
        return_point_id,
        status
    ) VALUES ($1, $3, $4, $5, 'new')
    RETURNING id
)

INSERT INTO order_items (item_id, order_id, number)
SELECT item.item_id, (SELECT id FROM order), item.amount
FROM UNNEST($2::customer_item[]) item
RETURNING (SELECT id FROM order);