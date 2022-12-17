CREATE TYPE "point_type" AS ENUM (
  'source',
  'delivery',
  'return'
);

CREATE TYPE "order_status" AS ENUM (
  'new',
  'accepted',
  'driver_lookup',
  'driver_found',
  'driver_pickuped',
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

CREATE TABLE "personal_datas" (
  "id" serial PRIMARY KEY,
  "first_name" varchar,
  "last_name" varchar,
  "birthday" date,
  "phone_number" varchar
);

CREATE TABLE "cars" (
  "id" serial PRIMARY KEY,
  "number" varchar,
  "brand" varchar,
  "model" varchar,
  "manufacture_year" integer
);

CREATE TABLE "drivers" (
  "id" serial PRIMARY KEY,
  "personal_data_id" integer,
  "car_id" integer,
  "driver_license_number" varchar
);

CREATE TABLE "customers" (
  "id" serial PRIMARY KEY,
  "personal_data_id" integer
);

CREATE TABLE "items" (
  "id" serial PRIMARY KEY,
  "name" varchar,
  "description" varchar,
  "length" double precision,
  "width" double precision,
  "height" double precision,
  "weight" double precision,
  "min_age" integer
);

CREATE TABLE "points" (
  "id" serial PRIMARY KEY,
  "longitude" double precision,
  "latitude" double precision,
  "address" varchar
);

CREATE TABLE "waybills" (
  "id" serial PRIMARY KEY,
  "driver_id" integer
);

CREATE TABLE "waybill_points" (
  "point_id" integer,
  "order_id" integer,
  "waybill_id" integer,
  "type" point_type,
  "visit_order" integer,
  "visited" boolean,
  PRIMARY KEY ("order_id", "waybill_id", "type")
);

CREATE TABLE "orders" (
  "id" serial PRIMARY KEY,
  "customer_id" integer,
  "source_point_id" integer,
  "delivery_point_id" integer,
  "return_point_id" integer,
  "waybill_id" integer,
  "status" order_status
);

CREATE TABLE "order_items" (
  "item_id" integer,
  "order_id" integer,
  "number" integer,
  PRIMARY KEY ("item_id", "order_id")
);

CREATE TABLE "chats" (
  "id" serial PRIMARY KEY,
  "order_id" integer,
  "updated_at" timestamptz
);

CREATE TABLE "chat_messages" (
  "id" serial PRIMARY KEY,
  "chat_id" integer,
  "person_id" integer,
  "message" varchar,
  "created_at" timestamptz,
  "status" message_status
);

ALTER TABLE "waybill_points" 
  ADD FOREIGN KEY ("point_id") REFERENCES "points" ("id"),
  ADD FOREIGN KEY ("order_id") REFERENCES "orders" ("id"),
  ADD FOREIGN KEY ("waybill_id") REFERENCES "waybills" ("id");

ALTER TABLE "drivers" 
  ADD FOREIGN KEY ("personal_data_id") REFERENCES "personal_datas" ("id"),
  ADD FOREIGN KEY ("car_id") REFERENCES "cars" ("id");

ALTER TABLE "customers" 
  ADD FOREIGN KEY ("personal_data_id") REFERENCES "personal_datas" ("id");

ALTER TABLE "orders" 
  ADD FOREIGN KEY ("customer_id") REFERENCES "customers" ("id"),
  ADD FOREIGN KEY ("source_point_id") REFERENCES "points" ("id"),
  ADD FOREIGN KEY ("return_point_id") REFERENCES "points" ("id"),
  ADD FOREIGN KEY ("delivery_point_id") REFERENCES "points" ("id"),
  ADD FOREIGN KEY ("waybill_id") REFERENCES "waybills" ("id");

ALTER TABLE "chats"
  ADD FOREIGN KEY ("order_id") REFERENCES "orders" ("id");

ALTER TABLE "chat_messages" 
  ADD FOREIGN KEY ("chat_id") REFERENCES "chats" ("id"),
  ADD FOREIGN KEY ("person_id") REFERENCES "personal_datas" ("id");

ALTER TABLE "order_items" 
  ADD FOREIGN KEY ("item_id") REFERENCES "items" ("id"),
  ADD FOREIGN KEY ("order_id") REFERENCES "orders" ("id");

ALTER TABLE "waybills"
  ADD FOREIGN KEY ("driver_id") REFERENCES "drivers" ("id");

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
  "waybill_id" integer,
  "type" point_type,
  "visit_order" integer,
);