-- Args
--
-- $1::integer              - Personal data id
-- $2::varchar              - Driver license number (nullable)

INSERT INTO couriers (personal_data_id, driver_license_number) VALUES ($1, $2);
