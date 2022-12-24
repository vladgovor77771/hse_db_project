-- Args
--
-- $1::integer              - Person id

SELECT * FROM wallets WHERE personal_data_id = $1::integer;
