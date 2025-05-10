import createError from "http-errors";
import { AuthService } from "../../core/services/index.js";
import {
  CheckMissingFields,
  FormatResult,
  ThrowNewError,
} from "../../utils/index.js";

class AuthController {
  async handleRegister(req, res, next) {
    try {
      const { email, fullName, password, confirmPassword } = req.body;
      CheckMissingFields({ email, fullName, password, confirmPassword });
      const data = await AuthService.Register({
        email,
        fullName,
        password,
        confirmPassword,
      });
      console.log("🚀 ~ AuthController ~ handleRegister ~ data:", data);
      res.status(200).json(FormatResult("success", data));
    } catch (err) {
      next(createError(400, err));
    }
  }

  async handleLogin(req, res, next) {
    try {
      const { email, password } = req.body;
      CheckMissingFields({ email, password });
      const url = req.originalUrl.replace("/api/", "");

      let data;
      if (url.includes("admin")) {
        data = await AuthService.Login({ email, password }, true);
      } else {
        data = await AuthService.Login({ email, password });
      }

      res
        .cookie("accessToken", data.accessToken, {
          httpOnly: true,
          signed: true,
          sameSite: "strict",
          maxAge: 24 * 60 * 60 * 1000,
        })
        .cookie("refreshToken", data.refreshToken, {
          httpOnly: true,
          signed: true,
          sameSite: "strict",
          maxAge: 24 * 60 * 60 * 1000,
        })
        .header("Authorization", data.accessToken)
        .status(200)
        .json(FormatResult("success", data));
    } catch (err) {
      next(createError(401, err));
    }
  }

  async handleRefreshToken(req, res, next) {
    try {
      let refreshToken;
      if (req.body?.refreshToken) {
        refreshToken = req.body.refreshToken;
      } else if (req.signedCookies?.refreshToken) {
        refreshToken = req.signedCookies.refreshToken;
      } else {
        ThrowNewError("AuthenticationError", "Refresh Token does not provided");
      }

      // Get new Access Token
      const data = await AuthService.RefreshToken(refreshToken);
      res
        .header("Authorization", data.accessToken)
        .status(200)
        .json(FormatResult("success", data));
    } catch (err) {
      next(createError(401, err));
    }
  }

  async handleLogout(req, res, next) {
    try {
      let refreshToken;
      if (req.body?.refreshToken) {
        refreshToken = req.body.refreshToken;
      } else if (req.signedCookies?.refreshToken) {
        refreshToken = req.signedCookies.refreshToken;
      } else {
        ThrowNewError("AuthenticationError", "Refresh Token does not provided");
      }

      const data = await AuthService.Logout(refreshToken);
      res
        .clearCookie("accessToken")
        .clearCookie("refreshToken")
        .status(200)
        .json(FormatResult("success", data));
    } catch (err) {
      next(createError(401, err));
    }
  }

  async handleForgotPassword(req, res, next) {
    try {
      const { email } = req.body;
      CheckMissingFields({ email });

      const data = await AuthService.ForgotPassword(email);
      res.status(200).json(FormatResult("success", data));
    } catch (err) {
      res.status(400);
      next(err);
    }
  }

  async handleResetPassword(req, res, next) {
    try {
      const { email, token, newPassword, confirmPassword } = req.body;
      CheckMissingFields({ email, token, newPassword, confirmPassword });

      if (newPassword !== confirmPassword) {
        ThrowNewError("UserInputInvalid", "Confirm password does not match");
      }

      const data = await AuthService.ResetPassword({
        email,
        token,
        newPassword,
      });
      res.status(200).json(FormatResult("success", data));
    } catch (err) {
      next(createError(401, err));
    }
  }

  async handleChangePassword(req, res, next) {
    try {
      const { _id } = req.user;
      const { currentPassword, newPassword, confirmPassword } = req.body;
      CheckMissingFields({ currentPassword, newPassword, confirmPassword });

      if (newPassword !== confirmPassword) {
        ThrowNewError("UserInputInvalid", "Confirm password does not match");
      }
      const data = await AuthService.ChangePassword({
        id: _id,
        currentPassword,
        newPassword,
      });
      res.status(200).json(FormatResult("success", data));
    } catch (err) {
      next(createError(400, err));
    }
  }
}

export default new AuthController();
