import {
  Car,
  Chat,
  ChatMessage,
  Customer,
  Driver,
  Item,
  Order,
  OrderItem,
  PersonalData,
  Point,
  Waybill,
  WaybillPoint,
} from "./models";

export function insert<T>(
  tableName: string,
  columns: string[],
  values: T[],
  toRow: (x: T) => string
) {
  return `INSERT INTO ${tableName} (${columns.join(", ")}) VALUES \n${values
    .map(x => `\t(${toRow(x)})`)
    .join(",\n")};`;
}

export function insertPersonalDatas(datas: PersonalData[]) {
  return insert(
    "personal_datas",
    ["first_name", "last_name", "birthday", "phone_number"],
    datas,
    (d: PersonalData) =>
      `'${d.firstName}', '${d.lastName}', '${d.birthday.toISOString()}', '${
        d.phoneNumber
      }'`
  );
}

export function insertDrivers(datas: Driver[]) {
  return insert(
    "drivers",
    ["personal_data_id", "car_id", "driver_license_number"],
    datas,
    (d: Driver) => `${d.personalDataId}, ${d.carId}, '${d.driverLicenseNumber}'`
  );
}

export function insertCars(datas: Car[]) {
  return insert(
    "cars",
    ["number", "brand", "model", "manufacture_year"],
    datas,
    (d: Car) => `'${d.carNumber}', '${d.brand}', '${d.model}', ${d.manufactureYear}`
  );
}

export function insertCustomers(datas: Customer[]) {
  return insert(
    "customers",
    ["personal_data_id"],
    datas,
    (d: Customer) => `${d.personalDataId}`
  );
}

export function insertItems(datas: Item[]) {
  return insert(
    "items",
    ["name", "description", "length", "width", "height", "weight", "min_age"],
    datas,
    (d: Item) =>
      `'${d.name}', '${d.description}', ${d.length}, ${d.width}, ${d.height}, ${d.weight}, ${d.minAge}`
  );
}

export function insertOrders(datas: Order[]) {
  return insert(
    "orders",
    [
      "customer_id",
      "source_point_id",
      "delivery_point_id",
      "return_point_id",
      "waybill_id",
      "status",
    ],
    datas,
    (d: Order) =>
      `${d.customerId}, ${d.sourcePointId}, ${d.deliveryPointId}, ${d.returnPointId}, ${
        d.waybillId ? d.waybillId : "NULL"
      }, '${d.status}'`
  );
}

export function insertPoints(datas: Point[]) {
  return insert(
    "points",
    ["longitude", "latitude", "address"],
    datas,
    (d: Point) => `${d.longitude}, ${d.latitude}, '${d.address}'`
  );
}

export function insertOrderItems(datas: OrderItem[]) {
  return insert(
    "order_items",
    ["item_id", "order_id", "number"],
    datas,
    (d: OrderItem) => `${d.itemId}, ${d.orderId}, ${d.number}`
  );
}

export function insertWaybills(datas: Waybill[]) {
  return insert("waybills", ["driver_id"], datas, (d: Waybill) => `${d.driverId}`);
}

export function insertWaybillPoints(datas: WaybillPoint[]) {
  return insert(
    "waybill_points",
    ["point_id", "order_id", "waybill_id", "type", "visit_order", "visited"],
    datas,
    (d: WaybillPoint) =>
      `${d.pointId}, ${d.orderId}, ${d.waybillId}, '${d.type}', ${d.visitOrder}, ${
        d.visited ? "TRUE" : "FALSE"
      }`
  );
}

export function insertChats(datas: Chat[]) {
  return insert(
    "chats",
    ["order_id", "updated_at"],
    datas,
    (d: Chat) => `${d.orderId}, NOW()`
  );
}

export function insertChatMessages(datas: ChatMessage[]) {
  return insert(
    "chat_messages",
    ["chat_id", "person_id", "message", "created_at", "status"],
    datas,
    (d: ChatMessage) => `${d.chatId}, ${d.personId}, '${d.message}', NOW(), '${d.status}'`
  );
}
