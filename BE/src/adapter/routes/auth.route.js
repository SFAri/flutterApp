import { Router } from "express";
const router = Router();

import { authUser } from "../middlewares/index.js";
import { validation } from "../middlewares/index.js";
import { AuthController } from "../controllers/index.js";

router.post("/register", AuthController.handleRegister);
router.post("/login", validation.account, AuthController.handleLogin);
router.post("/refresh", AuthController.handleRefreshToken);
router.post("/logout", AuthController.handleLogout);
router.post("/password/forgot", AuthController.handleForgotPassword);
router.post(
  "/password/reset",
  validation.resetPassword,
  AuthController.handleResetPassword
);
router.post(
  "/password/change",
  validation.changePassword,
  authUser,
  AuthController.handleChangePassword
);

router.post("/admin/login", validation.account, AuthController.handleLogin);

export default router;
