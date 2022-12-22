-- Args
--
-- $1::integer              - Person id

SELECT * FROM wallets WHERE person_id = $1::integer;
