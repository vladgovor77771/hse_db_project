-- Args
--
-- $1::integer              - Order id
-- $2::integer              - Personal data id
-- $3::varchar              - Message

WITH chat AS (
    SELECT chat_id FROM chats c
    LEFT JOIN orders o ON o.id = c.order_id
    WHERE o.id = $1::integer
)

INSERT INTO chat_messages (chat_id, person_id, message, created_at, status)
VALUES ((SELECT chat_id FROM chat), $2, $3, NOW(), 'sent');
