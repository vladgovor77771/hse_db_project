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
            w1.id INTO sender_wallet_id,
            w2.id INTO couriers_wallet_id,
        FROM orders o
        LEFT JOIN senders s ON s.id = o.sender_id
        LEFT JOIN wallets w1 ON w1.person_id = s.personal_data_id
        LEFT JOIN waybills w ON w.id = o.waybill_id
        LEFT JOIN couriers c ON c.id = w.courier_id
        LEFT JOIN wallets w2 ON w2.person_id = c.personal_data_id
        WHERE o.id = $1::integer;
        
        UPDATE wallets
        SET balance = balance - order_price
        WHERE id = sender_wallet_id;

        UPDATE wallets
        SET balance = balance + order_price * (1.0 - system_fee)
        WHERE id = courier_wallet_id;

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