import { OrderModel } from "../models/index.js";

export default class OrderRepository {
  async CreateOrder(input = {}) {
    const {
      userId = null,
      items = [],
      subtotal = 0,
      coupon = null,
      loyaltyPointsUsed = 0,
      shippingFee = 0,
      taxAmount = 0,
      totalAmount = 0,
      shippingAddress,
      paymentMethod = "credit_card",
      status = "pending",
    } = input;

    const newOrder = new OrderModel({
      userId,
      items,
      subtotal,
      coupon,
      loyaltyPointsUsed,
      shippingFee,
      taxAmount,
      totalAmount,
      shippingAddress,
      paymentMethod,
      status,
    });
    console.log("🚀 ~ OrderRepository ~ CreateOrder ~ newOrder:", newOrder);

    await newOrder.save();
    return newOrder;
  }

  async FindById(id) {
    const order = await OrderModel.findById(id);
    return order;
  }

  async FindByUserId(userId) {
    const orders = await OrderModel.find({ userId });
    return orders;
  }

  async UpdateStatus(id, status) {
    const order = await OrderModel.findByIdAndUpdate(
      id,
      { status, updatedAt: new Date() },
      { new: true }
    );
    return order;
  }

  async FindAll() {
    const orders = await OrderModel.find();
    return orders;
  }

  async DeleteById(id) {
    const order = await OrderModel.findByIdAndDelete(id);
    return order;
  }
}
