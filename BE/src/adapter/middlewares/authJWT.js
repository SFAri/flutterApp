import createError from "http-errors";
import { ThrowNewError, VerifyToken } from "../../utils/index.js";
import configs from "../../configs/index.js";
const {
  tokens: { access_token_key },
} = configs;
import { UserModel } from "../../infras/models/index.js";

export default async (req, res, next) => {
  try {
    // Get access Token from header
    const authHeader = req.headers.authorization || req.headers.Authorization;
    let accessToken;
    if (authHeader) {
      if (!authHeader?.startsWith("Bearer ")) {
        ThrowNewError(
          "AuthenticationError",
          "Invalid authentication information"
        );
      }
      accessToken = authHeader.split(" ")[1]; //Remove 'Beares' at the first header.
    } else if (req.signedCookies?.accessToken) {
      // If dont have access Token in header, then get it in cookies.
      accessToken = req.signedCookies.accessToken;
    } else {
      ThrowNewError("AuthenticationError", "Access Token does not provided");
    }
    // Verify the access token provided.
    const verified = await VerifyToken(accessToken, access_token_key);
    const _id = verified.payload.id;
    const user = await UserModel.findById({ _id });
    if (!user) {
      ThrowNewError("UserError", "User does not exist");
    }
    // Get user information
    req.user = user;
    return next();
  } catch (err) {
    next(createError(401, err));
  }
};
