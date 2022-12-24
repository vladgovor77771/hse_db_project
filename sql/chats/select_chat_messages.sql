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
WHERE cm.chat_id = $1::integer;
