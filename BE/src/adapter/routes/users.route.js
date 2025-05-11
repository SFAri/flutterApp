import { Router } from "express";
const router = Router();

import { authUser } from "../middlewares/index.js";
import { UserController } from "../controllers/index.js";

/* GET users listing. */
router
  .route("/")
  .get(UserController.getListUser)
  .post(authUser, UserController.createUser);

router
  .route("/profile")
  .get(authUser, UserController.getUserDetail)
  .put(authUser, UserController.updateUser);

router
  .route("/address")
  .get(authUser, UserController.getAddress)
  .post(authUser, UserController.createAddress);

router
  .route("/address/:id")
  .put(authUser, UserController.updateAddress)
  .delete(authUser, UserController.deleteAddress);

router
  .route("/:id")
  .get(UserController.getUserDetail)
  .put(authUser, UserController.updateUser)
  .delete(authUser, UserController.deleteUser);
export default router;
