import createError from "http-errors";
import { CouponService } from "../../core/services/index.js";
import { CheckMissingFields, FormatResult } from "../../utils/index.js";

class CouponController {
  async createCoupon(req, res, next) {
    try {
      const { code, discountAmount, usageLimit } = req.body;
      const isActive = String(req.body.isActive).toLowerCase() === "true";

      CheckMissingFields({
        code,
        discountAmount,
        usageLimit,
      });

      const newCoupon = {
        code,
        discountAmount,
        usageLimit,
        isActive,
      };

      const data = await CouponService.CreateCoupon(newCoupon);
      res.status(201).json(FormatResult("success", data));
    } catch (err) {
      next(createError(400, err));
    }
  }

  async getCouponDetail(req, res, next) {
    const code = req.params.id;

    try {
      const data = await CouponService.GetCouponByCode(code);
      res.status(200).json(FormatResult("success", data));
    } catch (err) {
      next(createError(400, err));
    }
  }

  async getListCoupon(req, res, next) {
    try {
      const data = await CouponService.GetAllCoupons();
      res.status(200).json(FormatResult("success", data));
    } catch (err) {
      next(createError(400, err));
    }
  }

  async filterCoupon(req, res, next) {
    const { sortBy, filter } = req.body || {};

    try {
      const data = await CouponService.GetCouponByFilter(filter, sortBy);
      res.status(200).json(FormatResult("success", data));
    } catch (err) {
      next(createError(400, err));
    }
  }

  async updateCoupon(req, res, next) {
    const code = req.params.code;

    try {
      const updatedCoupon = req.body;
      const data = await CouponService.UpdateCoupon(code, updatedCoupon);
      res.status(200).json(FormatResult("success", data));
    } catch (err) {
      next(createError(400, err));
    }
  }

  async deleteCoupon(req, res, next) {
    const code = req.params.code;

    try {
      const data = await CouponService.DeleteCoupon(code);
      res.status(200).json(FormatResult("success", data));
    } catch (err) {
      next(createError(400, err));
    }
  }
}

export default new CouponController();
