-- Args
--
-- $1::integer           - Order id

BEGIN;

DO $$
    DECLARE system_fee decimal(10, 2);
    DECLARE order_price decimal(10, 2);
    DECLARE sender_wallet_id int;
    DECLARE courier_wallet_id int;

    BEGIN

        SELECT fee INTO system_fee FROM system_wallet;
        SELECT price INTO order_price FROM orders WHERE id = $1::integer;
        
        SELECT
            w1.personal_data_id INTO sender_wallet_id,
            w2.personal_data_id INTO couriers_wallet_id,
        FROM orders o
        LEFT JOIN wallets w1 ON w1.person_id = o.sender_id
        LEFT JOIN waybills w ON w.id = o.waybill_id
        LEFT JOIN wallets w2 ON w2.person_id = w.courier_id
        WHERE o.id = $1::integer;
        
        UPDATE wallets
        SET balance = balance - order_price
        WHERE personal_data_id = sender_wallet_id;

        UPDATE wallets
        SET balance = balance + order_price * (1.0 - system_fee)
        WHERE personal_data_id = courier_wallet_id;

        UPDATE system_money
        SET balance = balance + order_price * system_fee;

        UPDATE orders
        SET
            status = 'finished'
        WHERE id = $1::integer;

    EXCEPTION WHEN OTHERS
    THEN
        ROLLBACK;
    END
$$;

COMMIT;
