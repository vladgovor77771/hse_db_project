-- Args
--
-- $1::integer[]            - Message ids
-- $2::varchar              - Status

UPDATE chat_message
SET
    status = $2::varchar
WHERE id = ANY($1::integer[])
