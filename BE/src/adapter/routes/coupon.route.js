import { Router } from "express";
const router = Router();

import { authUser, checkRole } from "../middlewares/index.js";
import { CouponController } from "../controllers/index.js";

/* GET coupon listing. */
router
  .route("/")
  .get(CouponController.getListCoupon)
  .post(authUser, checkRole(["admin", "write"]), CouponController.createCoupon);

// router.route("/filter").post(CouponController.filterProduct);
router
  .route("/:code")
  .get(CouponController.getCouponDetail)
  .put(authUser, checkRole(["admin", "write"]), CouponController.updateCoupon)
  .delete(
    authUser,
    checkRole(["admin", "write"]),
    CouponController.deleteCoupon
  );

export default router;
