-- Args
--
-- $1::double precision     - longitude
-- $2::double precision     - latitude
-- $3::varchar              - address

INSERT INTO points (longitude, latitude, address)
VALUES ($1, $2, $3);
