import { FormatData, ThrowNewError } from "../../utils/index.js";
import {
  OrderRepository,
  UserRepository,
  CouponRepository,
  AddressRepository,
} from "../../infras/index.js";

class OrderService {
  constructor() {
    this.repository = new OrderRepository();
    this.userRepository = new UserRepository();
    this.addressRepository = new AddressRepository();
    this.couponRepository = new CouponRepository();
  }

  async CreateOrder(input = {}) {
    const {
      userId,
      cartItems,
      couponCode,
      shippingAddressId,
      paymentMethod = "credit_card",
    } = input;
    const user = await this.userRepository.FindById(userId);
    if (!user) ThrowNewError("UserError", "User does not exist");

    let discount = 0;
    if (couponCode) {
      const coupon = await this.couponRepository.FindByCode(couponCode);
      if (!coupon || !coupon.isActive || coupon.usageLimit < 0) {
        ThrowNewError("CouponError", "Invalid or expired coupon");
      }
      discount = coupon.discountAmount;

      await this.couponRepository.IncrementUsage(couponCode);
    }

    let shippingAddress = {};
    if (shippingAddressId) {
      const address = await this.addressRepository.FindAddressById(
        shippingAddressId
      );
      if (!address) ThrowNewError("AddressError", "Address not found");
      shippingAddress = address;
    }

    const subtotal = cartItems.reduce(
      (sum, item) => sum + item.unitPrice * item.quantity,
      0
    );
    const taxAmount = subtotal * 0.1;
    const shippingFee = 5;
    const totalAmount = subtotal + taxAmount + shippingFee - discount;

    const order = await this.repository.CreateOrder({
      userId,
      items: cartItems,
      subtotal,
      coupon: {
        code: couponCode,
        discountAmount: discount,
      },
      shippingFee,
      taxAmount,
      totalAmount,
      shippingAddress: shippingAddress.id,
      paymentMethod,
      status: "pending",
    });

    return FormatData(order);
  }

  async GetOrderById(id) {
    const order = await this.repository.FindById(id);
    if (!order) ThrowNewError("OrderError", "Order not found");
    return FormatData(order);
  }

  async GetOrdersByUserId(userId) {
    const orders = await this.repository.FindByUserId(userId);
    return FormatData(orders);
  }

  async UpdateOrderStatus(orderId, status) {
    const order = await this.repository.UpdateStatus(orderId, status);
    if (!order) ThrowNewError("OrderError", "Failed to update order status");
    return FormatData(order);
  }

  async GetAllOrders() {
    const orders = await this.repository.FindAll();
    return FormatData(orders);
  }

  async DeleteOrderById(orderId) {
    const order = await this.repository.DeleteById(orderId);
    if (!order) ThrowNewError("OrderError", "Order not found");
    return FormatData([]);
  }
}

export default new OrderService();
