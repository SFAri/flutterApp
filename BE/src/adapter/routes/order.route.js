import { Router } from "express";
const router = Router();

import { authUser, checkRole } from "../middlewares/index.js";
import { OrderController } from "../controllers/index.js";

/* GET order listing. */
router
  .route("/")
  .get(authUser, checkRole(["admin", "write"]), OrderController.getListOrder)
  .post(authUser, OrderController.createOrder);

router.route("/user").get(authUser, OrderController.getOrdersByUser);
router.route("/status/:id").put(authUser, OrderController.updateOrderStatus);
router
  .route("/:id")
  .get(OrderController.getOrderDetail)
  .delete(authUser, checkRole(["admin", "write"]), OrderController.deleteOrder);

export default router;
