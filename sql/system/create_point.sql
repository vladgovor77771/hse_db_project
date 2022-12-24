-- Args
--
-- $1::double precision     - longitude
-- $2::double precision     - latitude
-- $3::varchar              - address

WITH pc AS (
    INSERT INTO points_coordinates (longitude, latitude) VALUES ($1, $2)
    RETURNING ID
)

INSERT INTO points (coordinates_id, address)
VALUES ((SELECT id FROM pc), $3);
