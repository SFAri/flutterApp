import createError from "http-errors";

/*
  0. Customer 
  1. Admin 
 */
const roles = {
  0: {
    can: ["customer", "read", "create", "update", "delete"],
  },
  1: {
    can: ["admin", "read", "write"],
  },
};

export default (requiredRoles) => (req, res, next) => {
  try {
    // Check user role
    if (
      !requiredRoles.some((role) => roles[req.user.role].can.includes(role))
    ) {
      throw new Error(
        "Account information is wrong or you do not have access to the system."
      );
    }

    return next();
  } catch (err) {
    next(createError(403, err));
  }
};
