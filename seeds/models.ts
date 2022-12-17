export interface PersonalData {
  id?: number;
  firstName: string;
  lastName: string;
  birthday: Date;
  phoneNumber: string;
}

export interface Driver {
  id?: number;
  personalDataId: number;
  carId?: number;
  driverLicenseNumber: string;
}

export interface Car {
  id?: number;
  carNumber: string;
  brand: string;
  model: string;
  manufactureYear: number;
}

export interface Customer {
  id?: number;
  personalDataId: number;
}

export interface Item {
  id?: number;
  name: string;
  description: string;
  length: number;
  width: number;
  height: number;
  weight: number;
  minAge: number;
}

export interface Point {
  id?: number;
  longitude: number;
  latitude: number;
  address: string;
}

export interface Waybill {
  id?: number;
  driverId: number;
}

export type OrderStatus =
  | "new"
  | "accepted"
  | "driver_lookup"
  | "driver_found"
  | "driver_pickuped"
  | "delivered"
  | "finished"
  | "cancelled"
  | "failed"
  | "returned";

export interface Order {
  id?: number;
  customerId: number;
  sourcePointId: number;
  deliveryPointId: number;
  returnPointId: number;
  waybillId?: number;
  status: OrderStatus;
}

export interface OrderItem {
  itemId: number;
  orderId: number;
  number: number;
}

export type PointType = "source" | "delivery" | "return";

export interface WaybillPoint {
  pointId: number;
  orderId: number;
  waybillId: number;
  type: PointType;
  visitOrder: number;
  visited: boolean;
}

export function visitOrderToPointType(order: number): PointType {
  if (order == 0) return "source";
  if (order == 1) return "delivery";
  if (order == 2) return "return";
  throw new Error("Only 3 points in order now");
}

export interface Chat {
  id?: number;
  orderId: number;
  updatedAt: Date;
}

export type MessageStatus = "sent" | "received" | "read";

export interface ChatMessage {
  id?: number;
  chatId: number;
  personId: number;
  message: string;
  createdAt: Date;
  status: MessageStatus;
}
