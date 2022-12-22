-- Args
--
-- $1::integer              - Person id 
-- $2::decimal(10, 2)       - Diff

UPDATE wallets
SET
    balance = balance + $2::decimal(10, 2)
WHERE person_id = $1::integer;
