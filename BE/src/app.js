import createError from "http-errors";
import { json, urlencoded } from "express";
import session from "express-session";
import cookieParser from "cookie-parser";
import logger from "morgan";
import cors from "cors";
import helmet from "helmet";
import compression from "compression";

import {
  AuthRoute,
  UserRoute,
  ProductRoute,
  CouponRoute,
  OrderRoute,
} from "./adapter/routes/index.js";
import { notFound, errorHandler } from "./utils/handlerErrors.js";
import { rateLimit } from "./adapter/middlewares/index.js";
// import { UserService } from "./services/index.js";
import configs from "./configs/index.js";
const {
  secret_key: { my_secret_key },
} = configs;

export default async (app) => {
  app.use(logger("dev")); // Log HTTP requests
  app.use(cors()); //Enable CORS
  app.use(helmet()); // Add security headers
  app.disable("x-powered-by"); // Hide Express server information
  app.use(compression());
  app.use(json());
  app.use(urlencoded({ extended: true }));
  app.use(cookieParser(my_secret_key));

  app.use(
    session({
      cookie: {
        secure: true,
        httpOnly: true,
        maxAge: 3 * 60 * 60 * 1000,
      },
      secret: my_secret_key,
      resave: false,
      saveUninitialized: true,
    })
  );

  // Apply the rate limit
  app.use(rateLimit);

  app.use("/api/auth", AuthRoute);
  app.use("/api/users", UserRoute);
  app.use("/api/products", ProductRoute);
  app.use("/api/coupons", CouponRoute);
  app.use("/api/orders", OrderRoute);
  // app.use("/", HomeRoute);

  // Handle error
  app.use(notFound);
  app.use(errorHandler);
};
