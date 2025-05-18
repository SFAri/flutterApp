import { Schema as _Schema, model } from "mongoose";
const Schema = _Schema;

const OrderItemSchema = Schema({
  productId: { type: Schema.Types.ObjectId, required: true, ref: "Product" },
  productName: { type: String, required: true },
  variantId: { type: String, required: true },
  quantity: { type: Number, required: true },
  unitPrice: { type: Number, required: true },
  discountPerProduct: { type: Number, default: 0 },
});

const OrderSchema = Schema(
  {
    userId: { type: Schema.Types.ObjectId, ref: "User", default: null },
    items: [OrderItemSchema],
    subtotal: { type: Number, required: true },
    coupon: {
      code: { type: String },
      discountAmount: { type: Number },
    },
    loyaltyPointsUsed: { type: Number, default: 0 },
    shippingFee: { type: Number, required: true },
    totalAmount: { type: Number, required: true },
    shippingAddress: { type: Schema.Types.ObjectId, ref: "address" },
    paymentMethod: {
      type: String,
      required: true,
      enum: ["credit_card", "paypal", "cod"],
    },
    status: {
      type: String,
      default: "pending",
      enum: ["pending", "paid", "shipped", "cancelled"],
    },
  },
  {
    timestamps: true,
  }
);

const OrderModel = model("Order", OrderSchema);
export default OrderModel;
