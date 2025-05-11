// import fs from "fs";
// import Handlebars from "handlebars";

import { UserRepository, AddressRepository } from "../../infras/index.js";
import {
  FormatData,
  EncryptPass,
  ComparePass,
  // EncryptMail,
  // CompareMail,
  GenerateToken,
  DecodeToken,
  ThrowNewError,
} from "../../utils/index.js";
// import { sendEmail } from "../utils/mailer.js";
import configs from "../../configs/index.js";
const {
  tokens: {
    access_token_key,
    access_token_expiration,
    refresh_token_key,
    refresh_token_expiration,
  },
} = configs;

class AuthService {
  constructor() {
    this.repository = new UserRepository();
    this.addressRepository = new AddressRepository();
  }

  async GetTokens(id) {
    const payload = {
      id,
    };
    //generate new JWT
    const tokens = {
      accessToken: await GenerateToken(
        payload,
        access_token_key,
        access_token_expiration
      ),
      refreshToken: await GenerateToken(
        payload,
        refresh_token_key,
        refresh_token_expiration
      ),
    };

    if (!tokens.accessToken || !tokens.refreshToken) {
      ThrowNewError("GenerateTokenFail", "Generate token fail");
    }

    //save refreshToken
    await this.repository.UpdateById(id, { refreshToken: tokens.refreshToken });

    return tokens;
  }

  async Register(input = {}) {
    const {
      email,
      fullName,
      password,
      province,
      district,
      ward,
      detailAddress,
    } = input;

    const existingUser = await this.repository.FindUserByEmail({ email });
    if (existingUser) {
      ThrowNewError("EmailInvalid", "Email already exists");
    }

    const encryptPassword = await EncryptPass(password); // Encrypt password
    const newUser = await this.repository.AddUser({
      email,
      fullName,
      role: 0,
      password: encryptPassword,
    });

    const newAddress = await this.addressRepository.AddNewAddress(newUser, {
      email,
      fullName,
      province,
      district,
      ward,
      detailAddress,
      isDefault: true,
    });

    if (!newUser || !newAddress) ThrowNewError("RegisterFail", "Register fail");

    return FormatData(newUser);
  }

  async Login(input = {}, isAdmin = false) {
    const { email, password } = input;
    let existingUser;
    if (isAdmin) {
      existingUser = await this.repository.FindUserRoleAdmin({ email });
    } else {
      existingUser = await this.repository.FindUserByEmail({ email });
    }

    if (!existingUser)
      ThrowNewError(
        "InformationLoginInvalid",
        "Account does not exist or password is incorrect"
      );

    const isPasswordValid = await ComparePass(password, existingUser.password);
    if (!isPasswordValid)
      ThrowNewError(
        "InformationLoginInvalid",
        "Account does not exist or password is incorrect"
      );
    const tokens = await this.GetTokens(existingUser._id);

    return FormatData(tokens);
  }

  async RefreshToken(refreshToken) {
    const decoded = await DecodeToken(
      refreshToken.toString(),
      refresh_token_key
    );

    const id = decoded.payload.id;
    const existingUser = await this.repository.FindById(id);

    if (!existingUser || refreshToken !== existingUser.refreshToken) {
      console.log(refreshToken);
      console.log(existingUser.refreshToken);

      ThrowNewError("JwtIsInvalid", "Token authentication is invalid");
    }

    const tokens = await this.GetTokens(id);

    //update refreshToken
    await this.repository.UpdateById(id, { refreshToken: tokens.refreshToken });

    return FormatData(tokens);
  }

  async Logout(refreshToken) {
    const decoded = await DecodeToken(
      refreshToken.toString(),
      refresh_token_key
    );

    const id = decoded.payload.id;
    const existingUser = await this.repository.FindById(id);

    if (!existingUser || refreshToken !== existingUser.refreshToken) {
      ThrowNewError("JwtIsInvalid", "Token authentication is invalid");
    }

    //delete refeshToken
    await this.repository.UpdateById(id, { refreshToken: null });
    return FormatData(null);
  }

  async RenderFile(filename, data) {
    const source = fs.readFileSync(filename, "utf8").toString();
    const template = Handlebars.compile(source);
    const output = template(data);
    return output;
  }

  async ForgotPassword(email) {
    const existingUser = await this.repository.FindUserByEmail({ email });
    if (!existingUser) ThrowNewError("EmailInvalid", "Email does not exist");
    // const hashedEmail = await EncryptMail(email);

    // const data = {
    //   username:
    //     existingUser.alumni?.firstName ||
    //     existingUser.admin?.firstName ||
    //     existingUser.superadmin?.firstName ||
    //     null,
    //   resetPasswordLink: `http://localhost:5000/changePassword?email=${email}&token=${hashedEmail}`,
    // };
    // const htmlContent = await this.RenderFile(
    //   "./src/views/resetPassword.hbs",
    //   data
    // );

    // // Send email to change new password
    // sendEmail(email, "Xác nhận yêu cầu khôi phục mật khẩu", htmlContent);

    return FormatData(null);
  }

  async ResetPassword(input) {
    const { email, token, newPassword } = input;

    const existingUser = await this.repository.FindUserByEmail({ email });
    if (!existingUser)
      if (!existingUser) ThrowNewError("EmailInvalid", "Email does not exist");

    const isEmailValid = await CompareMail(email, token);
    if (!isEmailValid)
      ThrowNewError("EmailTokenInvalid", "Token authentication is invalid");

    const encryptPassword = await EncryptPass(newPassword); // Encrypt password
    // Update new password
    await this.repository.UpdateById(existingUser.id, {
      password: encryptPassword,
    });

    return FormatData(null);
  }

  async ChangePassword(input) {
    const { id, currentPassword, newPassword } = input;

    const existingUser = await this.repository.FindById(id);

    if (!existingUser) ThrowNewError("UserError", "User does not exist");

    const isPasswordValid = await ComparePass(
      currentPassword,
      existingUser.password
    );
    if (!isPasswordValid)
      ThrowNewError("UserInputInvalid", "Current password is incorrect");

    const encryptNewPassword = await EncryptPass(newPassword); // Encrypt new password
    // Update new password
    await this.repository.UpdateById(id, { password: encryptNewPassword });

    return FormatData(null);
  }
}
export default new AuthService();
