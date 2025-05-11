import { UserRepository } from "../../infras/index.js";
import { FormatData, EncryptPass, ThrowNewError } from "../../utils/index.js";

class UserService {
  constructor() {
    this.repository = new UserRepository();
  }

  async GetListUser() {
    const listUser = await this.repository.FindAll();
    return FormatData(listUser);
  }

  async GetUserById(id) {
    const user = await this.repository.FindById(id);
    if (!user) {
      ThrowNewError("UserError", "User does not exist");
    }
    return FormatData(user);
  }

  async AddNewUser(input = {}) {
    const existingUser = await this.repository.FindUserByEmail({
      email: input.email,
    });
    if (existingUser) {
      ThrowNewError("EmailInvalid", "Email already exists");
    }

    const password = input.password;
    const encryptPassword = await EncryptPass(password); // Encrypt password
    const newUser = await this.repository.AddUser({
      email: input.email,
      password: encryptPassword,
    });

    return FormatData(newUser);
  }

  async UpdateUserById(id, input) {
    const updatedUser = await this.repository.UpdateById(id, input);
    if (!updatedUser) {
      ThrowNewError("UserError", "User does not exist");
    }
    return FormatData(updatedUser);
  }

  async DeleteUserById(id) {
    const deletedUser = await this.repository.DeleteById(id);
    if (!deletedUser) {
      ThrowNewError("UserError", "User does not exist");
    }
    return FormatData(null);
  }
}

export default new UserService();
