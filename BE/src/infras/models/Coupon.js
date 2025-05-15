import { Schema as _Schema, model } from "mongoose";
const Schema = _Schema;

const CouponSchema = Schema(
  {
    code: {
      type: String,
      required: true,
      unique: true,
      uppercase: true,
      match: /^[A-Z0-9]{5}$/, // 5-character alphanumeric validation
    },
    discountAmount: { type: Number, required: true },
    usageLimit: {
      type: Number,
      required: true,
      default: 10,
      min: 1,
    },
    usedCount: { type: Number, default: 0 },
    isActive: { type: Boolean, default: true },
    createdBy: {
      type: Schema.Types.ObjectId,
      ref: "User", // assuming admin is a user
    },
  },
  {
    _id: false,
    timestamps: true,
  }
);

const CouponModel = model("Coupon", CouponSchema);
export default CouponModel;
