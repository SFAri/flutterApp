import { FormatData, ThrowNewError } from "../../utils/index.js";
import { CouponRepository } from "../../infras/index.js";

class CouponService {
  constructor() {
    this.repository = new CouponRepository();
  }

  async CreateCoupon(input) {
    const { code, discountAmount, usageLimit, createdBy, isActive } = input;

    const existing = await this.repository.FindByCode(code);
    if (existing) ThrowNewError("CouponError", "Coupon code already exists");
    if (code.length !== 5) {
      ThrowNewError("CouponError", "Coupon code must be 5 characters");
    }

    const coupon = await this.repository.CreateCoupon({
      code,
      discountAmount,
      usageLimit,
      createdBy,
      isActive,
    });

    return FormatData(coupon);
  }

  async GetAllCoupons() {
    const coupons = await this.repository.FindAll();
    return FormatData(coupons);
  }

  async GetCouponByCode(code) {
    const coupon = await this.repository.FindByCode(code);
    if (!coupon) ThrowNewError("CouponError", "Coupon not found");
    return FormatData(coupon);
  }

  async UpdateCoupon(code, input) {
    const updated = await this.repository.UpdateByCode(code, input);
    if (!updated) ThrowNewError("CouponError", "Coupon not found");
    return FormatData(updated);
  }

  async DeleteCoupon(code) {
    const deleted = await this.repository.DeleteByCode(code);
    if (!deleted) ThrowNewError("CouponError", "Coupon not found");
    return FormatData([]);
  }

  async DeactivateCoupon(code) {
    const deactivated = await this.repository.DeactivateCoupon(code);
    if (!deactivated) ThrowNewError("CouponError", "Coupon not found");
    return FormatData(deactivated);
  }
}

export default new CouponService();
