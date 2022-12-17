-- Args
--
-- $1::integer              - Order id

INSERT INTO chats (order_id, updated_at)
VALUES ($1, NOW());
