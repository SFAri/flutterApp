import { CouponModel } from "../models/index.js";

export default class CouponRepository {
  async CreateCoupon(input = {}) {
    const {
      code,
      discountAmount = 0,
      usageLimit = 10,
      createdBy,
      isActive = true,
    } = input;

    const newCoupon = new CouponModel({
      code,
      discountAmount,
      usageLimit,
      isActive,
      createdBy,
    });

    await newCoupon.save();
    return newCoupon;
  }

  async FindByCode(code) {
    const coupon = await CouponModel.findOne({ code });
    return coupon;
  }

  async IncrementUsage(code) {
    const coupon = await CouponModel.findOneAndUpdate(
      { code },
      { $inc: { usedCount: 1 } },
      { new: true }
    );
    return coupon;
  }

  async DeactivateCoupon(code) {
    const coupon = await CouponModel.findOneAndUpdate(
      { code },
      { isActive: false },
      { new: true }
    );
    return coupon;
  }

  async FindAll() {
    const coupons = await CouponModel.find();
    return coupons;
  }

  async DeleteByCode(code) {
    const coupon = await CouponModel.findOne({ code });

    return coupon;
  }

  async UpdateByCode(code, input = {}) {
    const coupon = await CouponModel.findOneAndUpdate({ code }, input, {
      new: true,
    });
    return coupon;
  }
}
