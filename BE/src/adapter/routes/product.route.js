import { Router } from "express";
const router = Router();

import { authUser, checkRole } from "../middlewares/index.js";
import { ProductController } from "../controllers/index.js";

/* GET products listing. */
router
  .route("/")
  .get(ProductController.getListProduct)
  .post(
    authUser,
    checkRole(["admin", "write"]),
    ProductController.createProduct
  );

router.route("/filter").post(ProductController.filterProduct);

router
  .route("/:id")
  .get(ProductController.getProductDetail)
  .put(authUser, checkRole(["admin", "write"]), ProductController.updateProduct)
  .delete(
    authUser,
    checkRole(["admin", "write"]),
    ProductController.deleteProduct
  );

export default router;
