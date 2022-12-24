export interface PersonalData {
  id?: number;
  firstName: string;
  lastName: string;
  birthday: Date;
  phoneNumber: string;
}

export interface Courier {
  personalDataId: number;
  carNumber?: string;
  driverLicenseNumber: string;
}

export interface Car {
  carNumber: string;
  brand: string;
  model: string;
  manufactureYear: number;
}

export interface Sender {
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

export interface PointCoordinate {
  latitude: number;
  longitude: number;
}

export interface Point {
  id?: number;
  address: string;
  coordinatesId: number;
}

export interface Waybill {
  id?: number;
  courierId: number;
}

export type OrderStatus =
  | "new"
  | "accepted"
  | "courier_lookup"
  | "courier_found"
  | "courier_pickuped"
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
  recipientName: string;
  recipientPhone: string;
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
  orderId: number;
  updatedAt: Date;
}

export type MessageStatus = "sent" | "received" | "read";

export interface ChatMessage {
  chatId: number;
  personId: number;
  message: string;
  createdAt: Date;
  status: MessageStatus;
}
