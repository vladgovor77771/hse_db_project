import { faker } from "@faker-js/faker";
import * as lodash from "lodash";

import {
  Car,
  ChatMessage,
  Sender,
  Courier,
  Item,
  PersonalData,
  Point,
  Order,
  OrderItem,
  Waybill,
  WaybillPoint,
  visitOrderToPointType,
  OrderStatus,
  Chat,
  PointCoordinate,
} from "./models";

export const randomBetween = (from: number, to?: number) => {
  if (!to) {
    to = from;
    from = 0;
  }
  return Math.floor(from + Math.random() * (to - from));
};

export const generatePersonalData = (): PersonalData => ({
  firstName: faker.name.firstName().replace(/'/g, "‘"),
  lastName: faker.name.lastName().replace(/'/g, "‘"),
  birthday: faker.date.birthdate(),
  phoneNumber: faker.phone.number(),
});

export const generateCar = (): Car => ({
  carNumber: faker.vehicle.vrm(),
  brand: faker.vehicle.manufacturer(),
  model: faker.vehicle.model(),
  manufactureYear: randomBetween(1995, 2022),
});

export const generateDriver = (personalDataId: number, carNumber?: string): Courier => ({
  personalDataId,
  carNumber,
  driverLicenseNumber: faker.vehicle.vin(),
});

export const generateCustomer = (personalDataId: number): Sender => ({
  personalDataId,
});

export const generatePointCoordinate = (): PointCoordinate => ({
  longitude: +faker.address.longitude(),
  latitude: +faker.address.latitude(),
});

export const generatePoint = (coordinates: PointCoordinate[]): Point => ({
  coordinatesId: randomBetween(1, coordinates.length),
  address: faker.address.streetAddress().replace(/'/g, "‘"),
});

export const generateItem = (): Item => ({
  name: faker.commerce.product().replace(/'/g, "‘"),
  description: faker.commerce.productDescription().replace(/'/g, "‘"),
  length: Math.random() * 3,
  width: Math.random() * 3,
  height: Math.random() * 3,
  weight: Math.random() * 3,
  minAge: randomBetween(12, 22),
});

export const generateChatMessage = (chatId: number, personId: number): ChatMessage => ({
  chatId,
  personId,
  message: `${faker.word.noun()} ${faker.word.noun()}`.replace(/'/g, "‘"),
  createdAt: faker.date.past(),
  status: faker.helpers.arrayElement(["sent", "received", "read"]),
});

export function generateMany<T>(
  generator: (...args: any[]) => T,
  amount: number,
  ...args: any[]
): T[] {
  const res = [];
  for (let i = 0; i < amount; ++i) {
    res.push(generator(...args));
  }
  return res;
}

export function withIds<T>(arr: T[], startFrom = 1) {
  for (let v of arr) {
    (v as any)["id"] = startFrom++;
  }
  return arr;
}

export function nRandomElementsFromArray<T>(arr: T[], amount: number) {
  let used: { [key: number]: boolean } = {};
  while (Object.keys(used).length != amount) {
    used[Math.floor(Math.random() * arr.length)] = true;
  }
  let res: T[] = [];
  for (let i of Object.keys(used).map(x => +x)) {
    res.push(arr[i]);
  }
  return res;
}

export const generateOrder = (senders: Sender[], points: Point[]): Order => {
  const p = nRandomElementsFromArray(points, 3);
  return {
    customerId: faker.helpers.arrayElement(senders).personalDataId,
    sourcePointId: p[0].id!,
    deliveryPointId: p[1].id!,
    returnPointId: p[2].id!,
    recipientName: faker.name.fullName().replace(/'/g, "‘"),
    recipientPhone: faker.phone.number().replace(/'/g, "‘"),
    status: "new",
  };
};

export const generateOrderItems = (orders: Order[], items: Item[]): OrderItem[] => {
  let res: OrderItem[] = [];
  for (let order of orders) {
    const amountOfItems = Math.floor(Math.random() * 20);
    const chosenItems = nRandomElementsFromArray(items, amountOfItems);
    for (let item of chosenItems) {
      res.push({
        itemId: item.id!,
        orderId: order.id!,
        number: randomBetween(1, 5),
      });
    }
  }
  return res;
};

export const generateWaybillsWithPoints = (orders: Order[], drivers: Courier[]) => {
  const ordersToPack = orders.slice(
    0,
    randomBetween(Math.round(orders.length / 2), orders.length)
  );

  let waybills: Waybill[] = [];
  let points: WaybillPoint[] = [];
  let ids = 1;

  for (let i = 0; i < ordersToPack.length; ) {
    const ordersInWaybillAmount = randomBetween(1, Math.min(5, ordersToPack.length - i));
    const ordersInWaybill = ordersToPack.slice(i, i + ordersInWaybillAmount);
    i += ordersInWaybillAmount;
    const driver = nRandomElementsFromArray(drivers, 1)[0];

    let waybill: Waybill = {
      id: ids++,
      courierId: driver.personalDataId!,
    };
    let usedPoints: { [orderId: string]: number } = Object.fromEntries(
      ordersInWaybill.map(x => [x.id! + "", 0])
    );
    let localPoints: WaybillPoint[] = [];
    while (localPoints.length != ordersInWaybillAmount * 3) {
      const maybeChoose = Object.keys(usedPoints).filter(
        (x: string) => usedPoints[x] < 3
      );
      const currentOrderId = faker.helpers.arrayElement(maybeChoose);
      const currentOrder = ordersInWaybill.find(x => x.id == +currentOrderId)!;

      localPoints.push({
        pointId:
          currentOrder[`${visitOrderToPointType(usedPoints[currentOrderId])}PointId`],
        orderId: +currentOrderId,
        type: visitOrderToPointType(usedPoints[currentOrderId]),
        visitOrder: localPoints.length + 1,
        visited: false,
      });
      ++usedPoints[currentOrderId];
    }
    for (let order of ordersInWaybill) {
      order.waybillId = waybill.id;
    }
    waybills.push(waybill);
    points = points.concat(localPoints);
  }

  return { waybills, points };
};

export const makeOrderStatuses = (orders: Order[]) => {
  const ordersByWaybills: { [key: number]: Order[] } = Object.fromEntries(
    lodash.uniq(orders.filter(x => !!x.waybillId).map(x => x.waybillId)).map(x => [x, []])
  );
  for (let order of orders) {
    if (order.waybillId) {
      ordersByWaybills[order.waybillId!].push(order);
      order.status = "courier_found";
      continue;
    }
    const choose = Math.random();
    if (choose < 0.2) {
      order.status = "accepted";
    } else if (choose < 0.4) {
      order.status = "cancelled";
    } else if (choose < 0.6) {
      order.status = "courier_lookup";
    } else if (choose < 0.8) {
      order.status = "failed";
    }
  }

  for (let ords of Object.values(ordersByWaybills)) {
    const choose = Math.random();
    let targetStatus: OrderStatus;
    if (choose < 0.5) {
      targetStatus = "finished";
    } else if (choose < 0.75) {
      targetStatus = "courier_found";
    } else if (choose < 0.9) {
      targetStatus = "returned";
    } else {
      targetStatus = "failed";
    }

    for (let o of ords) {
      o.status = targetStatus;
    }
  }
};

export const generateChatsWithMessages = (
  orders: Order[],
  waybills: Waybill[],
  drivers: Courier[],
  senders: Sender[]
) => {
  const waybillsById = Object.fromEntries(waybills.map(x => [x.id! + "", x]));
  const driversById = Object.fromEntries(drivers.map(x => [x.personalDataId! + "", x]));
  const sendersById = Object.fromEntries(senders.map(x => [x.personalDataId! + "", x]));
  const ordersWithPerformer = orders.filter(x => !!x.waybillId);
  const chats: Chat[] = [];
  const messages: ChatMessage[] = [];
  let ids = 1;

  for (let order of ordersWithPerformer) {
    const chat = {
      id: ids++,
      orderId: order.id!,
      updatedAt: new Date(),
    };
    const waybill = waybillsById[order.waybillId! + ""];
    const driver = driversById[waybill.courierId + ""];
    const customer = sendersById[order.customerId + ""];
    const localMessagesAmount = randomBetween(0, 10);
    const localMessages = generateMany(generateChatMessage, localMessagesAmount, 0, 0);
    for (let msg of localMessages) {
      msg.chatId = chat.id;
      msg.personId = faker.helpers.arrayElement([
        driver.personalDataId,
        customer.personalDataId,
      ]);
      messages.push(msg);
    }
    chats.push(chat);
  }
  return { chats, messages };
};
