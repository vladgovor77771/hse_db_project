-- Args
--
-- $1::varchar              - First name 
-- $2::varchar              - Last name
-- $3::date                 - Birthday
-- $4::varchar              - Phone number

WITH person AS (
    INSERT INTO personal_data (first_name, last_name, birthday, phone_number)
    VALUES ($1, $2, $3, $4)
    RETURNING id
)

INSERT INTO wallets (person_id) VALUES (SELECT id FROM person);
