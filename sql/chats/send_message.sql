-- Args
--
-- $1::integer              - Chat id
-- $2::integer              - Personal data id
-- $3::varchar              - Message

INSERT INTO chat_messages (chat_id, person_id, message, created_at, status)
VALUES ($1, $2, $3, NOW(), 'sent');
