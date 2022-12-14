import {
  insertCars,
  insertChatMessages,
  insertChats,
  insertSenders,
  insertCouriers,
  insertItems,
  insertOrderItems,
  insertOrders,
  insertPersonalDatas,
  insertPoints,
  insertWaybillPoints,
  insertWaybills,
  insertPointsCoordinates,
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
  generatePointCoordinate,
  generateWaybillsWithPoints,
  makeOrderStatuses,
  withIds,
} from "./random";

const main = () => {
  const personalDatas = withIds(generateMany(generatePersonalData, 20));
  const cars = generateMany(generateCar, 10);
  const drivers = generateMany(generateDriver, 10, 0, 0);
  for (let i = 0; i < 10; ++i) {
    drivers[i].carNumber = cars[i].carNumber;
    drivers[i].personalDataId = i + 1;
  }
  const senders = generateMany(generateCustomer, 10, 0);
  for (let i = 0; i < 10; ++i) {
    senders[i].personalDataId = i + 11;
  }
  const items = withIds(generateMany(generateItem, 50));
  const coordinates = withIds(generateMany(generatePointCoordinate, 50));
  const points = withIds(generateMany(generatePoint, 50, coordinates));
  const orders = withIds(generateMany(generateOrder, 50, senders, points));
  const orderItems = generateOrderItems(orders, items);
  const { waybills, points: waybillPoints } = generateWaybillsWithPoints(orders, drivers);
  const { chats, messages } = generateChatsWithMessages(
    orders,
    waybills,
    drivers,
    senders
  );
  makeOrderStatuses(orders);

  console.log(insertPersonalDatas(personalDatas));
  console.log(insertCars(cars));
  console.log(insertCouriers(drivers));
  console.log(insertSenders(senders));
  console.log(insertItems(items));
  console.log(insertPointsCoordinates(coordinates));
  console.log(insertPoints(points));
  console.log(insertWaybills(waybills));
  console.log(insertOrders(orders));
  console.log(insertOrderItems(orderItems));
  console.log(insertWaybillPoints(waybillPoints));
  console.log(insertChats(chats));
  console.log(insertChatMessages(messages));
};

main();
