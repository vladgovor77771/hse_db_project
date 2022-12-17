-- Args
--
-- $1::varchar              - Name query or description query

SELECT * FROM items
WHERE 
    name LIKE $1::varchar OR description LIKE $1::varchar;
