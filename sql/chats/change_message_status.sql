-- Args
--
-- $1::integer            - Chat id
-- $2::integer            - Person id
-- $3::timestamptz        - Created at
-- $4::varchar            - New status

UPDATE chat_message
SET status = $2::varchar
WHERE chat_id = $1::integer
    AND person_id = $2::integer
    AND created_at = $3::timestamptz;