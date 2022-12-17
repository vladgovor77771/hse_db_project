-- Args
--
-- $1::integer              - Driver id
-- $2::varchar              - Status

UPDATE orders
SET
    status = $2::varchar
WHERE id = $1::integer;
