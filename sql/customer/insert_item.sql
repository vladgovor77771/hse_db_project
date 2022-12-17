-- Args
--
-- $1::varchar              - Name 
-- $2::varchar              - Description
-- $3::double precision     - length
-- $4::double precision     - width
-- $5::double precision     - height
-- $6::double precision     - weight
-- $7::integer              - min age

INSERT INTO items (name, description, length, width, height, weight, min_age) 
VALUES ($1, $2, $3, $4, $5, $6, $7)
RETURNING id;
