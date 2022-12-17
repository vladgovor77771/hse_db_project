import {
  insertCars,
  insertChatMessages,
  insertChats,
  insertCustomers,
  insertDrivers,
  insertItems,
  insertOrderItems,
  insertOrders,
  insertPersonalDatas,
  insertPoints,
  insertWaybillPoints,
  insertWaybills,
} from "./sql";
import {
  generateCar,
  generateChatsWithMessages,
  generateCustomer,
  generateDriver,
  generateItem,
  generateMany,
  generateOrder,
  generateOrderItems,
  generatePersonalData,
  generatePoint,
  generateWaybillsWithPoints,
  makeOrderStatuses,
  withIds,
} from "./random";

const main = () => {
  const personalDatas = withIds(generateMany(generatePersonalData, 20));
  const cars = withIds(generateMany(generateCar, 10));
  const drivers = withIds(generateMany(generateDriver, 10, 0, 0));
  for (let i = 0; i < 10; ++i) {
    drivers[i].carId = i + 1;
    drivers[i].personalDataId = i + 1;
  }
  const customers = withIds(generateMany(generateCustomer, 10, 0));
  for (let i = 0; i < 10; ++i) {
    customers[i].personalDataId = i + 11;
  }
  const items = withIds(generateMany(generateItem, 50));
  const points = withIds(generateMany(generatePoint, 50));
  const orders = withIds(generateMany(generateOrder, 50, customers, points));
  const orderItems = generateOrderItems(orders, items);
  const { waybills, points: waybillPoints } = generateWaybillsWithPoints(orders, drivers);
  const { chats, messages } = generateChatsWithMessages(
    orders,
    waybills,
    drivers,
    customers
  );
  makeOrderStatuses(orders);

  console.log(insertPersonalDatas(personalDatas));
  console.log(insertCars(cars));
  console.log(insertDrivers(drivers));
  console.log(insertCustomers(customers));
  console.log(insertItems(items));
  console.log(insertPoints(points));
  console.log(insertWaybills(waybills));
  console.log(insertOrders(orders));
  console.log(insertOrderItems(orderItems));
  console.log(insertWaybillPoints(waybillPoints));
  console.log(insertChats(chats));
  console.log(insertChatMessages(messages));
};

main();
