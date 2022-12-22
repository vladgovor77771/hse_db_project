# Сервис доставки

В нашем сервисе доставки пользователи могут оформить доставку из точки А в точку B и указать точку C, как return точку, в случае отмены заказа с предметами на руках у водителя. Пользователи могут смотреть, кто доставляет посылку и на какой машине. Водители могут зарегистрироваться на нашем сервисе и указать автомобиль, на котором будет осуществляться доставка. Заказы на водителей назначает система, но водитель может отказаться от предложения. Также между водителями и заказчиками доступен чат. 

Заказы формируются в маршрутный лист таким образом, что заказы будут обрабаываться параллельно. Пример: 2 заказа X1, X2 собираются в маршрутный лист. В каждом заказе есть 1 точка source A_i, 1 точка destination B_i и 1 точка return C_i. Маршрутный лист может выглядеть так: A1 -> A2 -> B1 -> B2 -> C1 -> C2, при этом точки C могут быть опущены, если заказы успешны.

# Дисклеймер по запросам

Все запросы в этом репозитории содержат аргументы, соответственно они должны передаваться приложением, которое исполняет эти запросы.

# Функциональные требования

- ✓ [Регистрация (указание персональных данных) + создание кошелька.](sql/registration.sql)
- ✓ [Обновление баланса (вывод или депозит)](sql/wallet/wallet_update.sql)
- ✓ [Получение баланса](sql/wallet/wallet_load.sql)

## Со стороны исполнителя

- ✓ [Создать профиль исполнителя.](sql/driver/create_driver_profile.sql)
- ✓ [Установить / заменить автомобиль.](sql/driver/set_car.sql)
- ✓ [Просмотр истории выполненных заказов.](sql/driver/select_orders_history.sql)
- ✓ [Просмотр заказов в маршрутном листе.](sql/driver/select_waybill_orders.sql)
- ✓ [Просмотр точек в маршрутном листе.](sql/driver/select_waybill_points.sql)
- ✓ [Пометить точку в маршрутом листе, как выполненную.](sql/driver/mark_point_visited.sql)
- ✓ [Пометить заказ как выполненный и получить за него деньги.](sql/transactions/finish_order.sql)

## Со стороны заказчика

- ✓ [Создать профиль заказчика.](sql/customer/create_customer_profile.sql)
- ✓ [Просмотр сгрупперованных по статусам заказов с фильтром по статусам.](sql/customer/select_orders.sql)
- ✓ [Получить список предметов.](sql/customer/select_items.sql)
- ✓ [Создать новый тип предмета.](sql/customer/insert_item.sql)
- ✓ [Сделать заказ с указанием предметов, которые доставлять, и точек A, B, C.](sql/customer/create_order.sql)

## Чаты

- ✓ [Создать чат по заказу.](sql/chats/create_chat.sql)
- ✓ [Прочитать чат по заказу.](sql/chats/select_chat_messages.sql)
- ✓ [Написать в чат по заказу.](sql/chats/send_message.sql)
- ✓ [Изменить статус сообщений.](sql/chats/change_messages_statuses.sql)

## Со стороны системы

- ✓ [Создать маршрутный лист из заказов.](sql/system/create_waybill.sql)
- ✓ [Изменить статус заказа.](sql/system/update_order_status.sql)
- ✓ [Создать новую физическую точку.](sql/system/create_point.sql)

# Транзакции

Некоторые запросы стоит делать транзакционно, чтобы в случае ошибки создания / изменения одной компоненты нормализованной схемы, ничего не сломалось. При этом контролировать создание транзакций и их наполнение может приложение, то есть не обязательно писать запросы с `BEGIN` / `COMMIT`, хотя, безусловно, это возможно.

В одну транзакцию стоит поместить:

- Вызовами из верхнего уровня: Создание заказа + Содзание чата по заказу (+ создание предметов в заказе, но оно уже и так в одном запросе с созданием заказа).
- Вызовами из верхнего уровня: Создание профиля водителя + создание автомобиля.
- [Вызовами из-под бд: перевод денег за выполненный заказ.](sql/transactions/finish_order.sql)
