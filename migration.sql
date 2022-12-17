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
  "id" serial PRIMARY KEY NOT NULL,
  "first_name" varchar NOT NULL,
  "last_name" varchar NOT NULL,
  "birthday" date,
  "phone_number" varchar NOT NULL
);

CREATE TABLE "cars" (
  "id" serial PRIMARY KEY NOT NULL,
  "number" varchar NOT NULL,
  "brand" varchar NOT NULL,
  "model" varchar NOT NULL,
  "manufacture_year" integer NOT NULL
);

CREATE TABLE "drivers" (
  "id" serial PRIMARY KEY NOT NULL,
  "personal_data_id" integer NOT NULL,
  "car_id" integer NOT NULL,
  "driver_license_number" varchar NOT NULL
);

CREATE TABLE "customers" (
  "id" serial PRIMARY KEY NOT NULL,
  "personal_data_id" integer NOT NULL
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
  "longitude" double precision NOT NULL,
  "latitude" double precision NOT NULL,
  "address" varchar NOT NULL
);

CREATE TABLE "waybills" (
  "id" serial PRIMARY KEY NOT NULL,
  "driver_id" integer NOT NULL
);

CREATE TABLE "waybill_points" (
  "point_id" integer NOT NULL,
  "order_id" integer NOT NULL,
  "waybill_id" integer NOT NULL,
  "type" point_type NOT NULL,
  "visit_order" integer NOT NULL,
  "visited" boolean NOT NULL DEFAULT FALSE,
  PRIMARY KEY ("order_id", "waybill_id", "type")
);

CREATE TABLE "orders" (
  "id" serial PRIMARY KEY NOT NULL,
  "customer_id" integer NOT NULL,
  "source_point_id" integer NOT NULL,
  "delivery_point_id" integer NOT NULL,
  "return_point_id" integer NOT NULL,
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
  "id" serial PRIMARY KEY NOT NULL,
  "order_id" integer NOT NULL,
  "updated_at" timestamptz NOT NULL
);

CREATE TABLE "chat_messages" (
  "id" serial PRIMARY KEY NOT NULL,
  "chat_id" integer NOT NULL,
  "person_id" integer NOT NULL,
  "message" varchar NOT NULL,
  "created_at" timestamptz NOT NULL,
  "status" message_status NOT NULL
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
  "visit_order" integer
);