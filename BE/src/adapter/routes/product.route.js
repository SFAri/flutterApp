import { Router } from "express";
const router = Router();

/* GET users listing. */
router.get("/", function (req, res, next) {
  res.send("respond with a Products");
});

export default router;
