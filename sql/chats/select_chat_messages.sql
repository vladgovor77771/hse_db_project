-- Args
--
-- $1::integer              - Order id

SELECT
    cm.chat_id,
    cm.person_id,
    cm.message,
    cm.created_at,
    cm.status,
    c.updated_at as chat_updated_at
FROM chat_messages cm
LEFT JOIN chats c ON c.id = cm.chat_id
WHERE c.order_id = $1::integer;
