-- Args
--
-- $1::integer              - Waybill point id

UPDATE waybill_points
SET
    visited = TRUE
WHERE id = $1::integer;
