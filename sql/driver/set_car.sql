-- Args
--
-- $1::integer              - Driver id
-- $2::varchar              - Car number
-- $3::varchar              - Car brand
-- $4::varchat              - Car model
-- $5::integer              - Car manufacture year

WITH new_car AS (
    INSERT INTO "cars" (number, brand, model, manufacture_year) VALUES
    ($2::varchar, $3::varchar, $4::varchar, $5::integer)
    RETURNING id
)

UPDATE drivers
SET car_id = (SELECT id FROM new_car)
WHERE id = $1::integer;