CREATE TYPE "point_type" AS ENUM (
  'source',
  'delivery',
  'return'
);

CREATE TYPE "order_status" AS ENUM (
  'new',
  'accepted',
  'courier_lookup',
  'courier_found',
  'courier_pickuped',
  'delivered',
  'finished',
  'cancelled',
  'failed',
  'returned'
);

CREATE TYPE "message_status" AS ENUM (
  'sent',
  'received',
  'read'
);

CREATE TABLE "system_money" (
  "balance" decimal(10,2) NOT NULL DEFAULT 0.0,
  "fee" float NOT NULL DEFAULT 0.05
);

CREATE TABLE "personal_data" (
  "id" serial PRIMARY KEY NOT NULL,
  "first_name" varchar NOT NULL,
  "last_name" varchar,
  "birthday" date,
  "phone_number" varchar NOT NULL
);

CREATE TABLE "wallets" (
  "personal_data_id" integer PRIMARY KEY NOT NULL,
  "balance" decimal(10,2) NOT NULL DEFAULT 0.0
);

CREATE TABLE "cars" (
  "number" varchar PRIMARY KEY NOT NULL,
  "brand" varchar NOT NULL,
  "model" varchar NOT NULL,
  "manufacture_year" integer NOT NULL
);

CREATE TABLE "couriers" (
  "personal_data_id" integer PRIMARY KEY NOT NULL,
  "car_number" varchar,
  "driver_license_number" varchar
);

CREATE TABLE "senders" (
  "personal_data_id" integer PRIMARY KEY NOT NULL
);

CREATE TABLE "items" (
  "id" serial PRIMARY KEY NOT NULL,
  "name" varchar NOT NULL,
  "description" varchar NOT NULL,
  "length" double precision NOT NULL,
  "width" double precision NOT NULL,
  "height" double precision NOT NULL,
  "weight" double precision NOT NULL,
  "min_age" integer
);

CREATE TABLE "points" (
  "id" serial PRIMARY KEY NOT NULL,
  "address" varchar NOT NULL,
  "coordinates_id" integer
);

CREATE TABLE "points_coordinates" (
  "id" serial PRIMARY KEY NOT NULL,
  "longitude" double precision NOT NULL,
  "latitude" double precision NOT NULL
);

CREATE TABLE "waybills" (
  "id" serial PRIMARY KEY NOT NULL,
  "courier_id" integer NOT NULL
);

CREATE TABLE "waybill_points" (
  "point_id" integer NOT NULL,
  "order_id" integer NOT NULL,
  "type" point_type NOT NULL,
  "visit_order" integer NOT NULL,
  "visited" boolean NOT NULL DEFAULT FALSE,
  PRIMARY KEY ("order_id", "type")
);

CREATE TABLE "orders" (
  "id" serial PRIMARY KEY NOT NULL,
  "sender_id" integer NOT NULL,
  "source_point_id" integer NOT NULL,
  "delivery_point_id" integer NOT NULL,
  "return_point_id" integer NOT NULL,
  "recipient_name" varchar NOT NULL,
  "recipient_phone" varchar NOT NULL,
  "price" decimal(10,2) NOT NULL DEFAULT 0.0,
  "waybill_id" integer,
  "status" order_status NOT NULL
);

CREATE TABLE "order_items" (
  "item_id" integer NOT NULL,
  "order_id" integer NOT NULL,
  "number" integer NOT NULL,
  PRIMARY KEY ("item_id", "order_id")
);

CREATE TABLE "chats" (
  "order_id" integer PRIMARY KEY NOT NULL,
  "updated_at" timestamptz NOT NULL
);

CREATE TABLE "chat_messages" (
  "chat_id" integer NOT NULL,
  "person_id" integer NOT NULL,
  "message" varchar NOT NULL,
  "created_at" timestamptz NOT NULL,
  "status" message_status NOT NULL,
  PRIMARY KEY ("chat_id", "person_id", "created_at")
);

ALTER TABLE "points" ADD FOREIGN KEY (coordinates_id) REFERENCES "points_coordinates" ("id");

ALTER TABLE "wallets" ADD FOREIGN KEY (personal_data_id) REFERENCES "personal_data" ("id");

ALTER TABLE "waybill_points" 
  ADD FOREIGN KEY ("point_id") REFERENCES "points" ("id"),
  ADD FOREIGN KEY ("order_id") REFERENCES "orders" ("id");

ALTER TABLE "couriers" 
  ADD FOREIGN KEY ("personal_data_id") REFERENCES "personal_data" ("id"),
  ADD FOREIGN KEY ("car_number") REFERENCES "cars" ("number");

ALTER TABLE "senders" 
  ADD FOREIGN KEY ("personal_data_id") REFERENCES "personal_data" ("id");

ALTER TABLE "orders" 
  ADD FOREIGN KEY ("sender_id") REFERENCES "senders" ("personal_data_id"),
  ADD FOREIGN KEY ("source_point_id") REFERENCES "points" ("id"),
  ADD FOREIGN KEY ("return_point_id") REFERENCES "points" ("id"),
  ADD FOREIGN KEY ("delivery_point_id") REFERENCES "points" ("id"),
  ADD FOREIGN KEY ("waybill_id") REFERENCES "waybills" ("id");

ALTER TABLE "chats"
  ADD FOREIGN KEY ("order_id") REFERENCES "orders" ("id");

ALTER TABLE "chat_messages" 
  ADD FOREIGN KEY ("chat_id") REFERENCES "chats" ("order_id"),
  ADD FOREIGN KEY ("person_id") REFERENCES "personal_data" ("id");

ALTER TABLE "order_items" 
  ADD FOREIGN KEY ("item_id") REFERENCES "items" ("id"),
  ADD FOREIGN KEY ("order_id") REFERENCES "orders" ("id");

ALTER TABLE "waybills"
  ADD FOREIGN KEY ("courier_id") REFERENCES "couriers" ("personal_data_id");

CREATE TYPE customer_item AS (
  item_id integer,
  amount integer
);

CREATE TYPE customer_order AS (
  items customer_item[],
  source_point_id integer,
  delivery_point_id integer,
  return_point_id integer
);

CREATE TYPE waybill_point AS (
  "point_id" integer,
  "order_id" integer,
  "type" point_type,
  "visit_order" integer
);
