import createError from "http-errors";
import { check, validationResult, matchedData } from "express-validator";

const account = [
  check("email", "Email does not empty").trim().not().isEmpty(),
  check("email", "Email is invalid").trim().isEmail(),
  check("password", "Password does not empty").trim().not().isEmpty(),
  check("password", "Password must contain at least 6 characters")
    .trim()
    .isLength({ min: 6 }),
  (req, res, next) => {
    const error = validationResult(req);

    if (!error.isEmpty()) {
      return next(createError(400, error.array()[0].msg));
    }
    return next();
  },
];

const resetPassword = [
  check("newPassword", "New Password does not empty").trim().not().isEmpty(),
  check("newPassword", "New Password must contain at least 6 characters")
    .trim()
    .isLength({ min: 6 }),
  check("confirmPassword", "Confirm Password does not empty")
    .trim()
    .not()
    .isEmpty(),
  (req, res, next) => {
    const error = validationResult(req);

    if (!error.isEmpty()) {
      return next(createError(400, error.array()[0].msg));
    }
    return next();
  },
];

const changePassword = [
  check("currentPassword", "Current Password does not empty")
    .trim()
    .not()
    .isEmpty(),
  check("newPassword", "New Password does not empty").trim().not().isEmpty(),
  check("newPassword", "New Password must contain at least 6 characters")
    .trim()
    .isLength({ min: 6 }),
  check("confirmPassword", "Confirm Password does not empty")
    .trim()
    .not()
    .isEmpty(),
  (req, res, next) => {
    const error = validationResult(req);

    if (!error.isEmpty()) {
      return next(createError(400, error.array()[0].msg));
    }
    return next();
  },
];

export default { account, resetPassword, changePassword };
