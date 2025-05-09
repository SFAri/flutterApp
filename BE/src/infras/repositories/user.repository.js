import { UserModel } from "../models/index.js";

export default class UserRepository {
  async AddUser(input = {}) {
    const { email, password } = input;
    const newUser = new UserModel({
      email,
      password,
    });

    await newUser.save();
    return newUser;
  }

  async FindUserByEmail({ email }) {
    const user = await UserModel.findOne({ email });
    return user;
  }

  async FindUserRoleAdmin({ email }) {
    const user = await UserModel.findOne({
      email,
      userType: { $in: [1] },
    });
    return user;
  }

  async FindAll() {
    const users = await UserModel.find()
      .select({ password: 0, refreshToken: 0 })
      .lean();
    return users;
  }

  async FindById(id) {
    const user = await UserModel.findById(id);
    return user;
  }

  async FindByFilter(filter = {}, page = null, perPage = null) {
    let users = {};
    if (page !== null && perPage !== null) {
      const count = await UserModel.countDocuments(filter);
      const totalPage = Math.ceil(count / perPage);
      const previous = page - 1 === 0 ? -1 : page - 1;
      const next = page + 1 > totalPage ? -1 : page + 1;

      const usersPagination = await UserModel.find(filter)
        .select({ password: 0, refreshToken: 0 })
        .lean()
        .skip(perPage * (page - 1))
        .limit(perPage)
        .exec();

      users = {
        data: usersPagination,
        pagination: {
          previous,
          next,
          page: page,
          limit: perPage,
          totalPage,
        },
      };
    } else {
      users = await UserModel.find(filter)
        .select({ password: 0, refreshToken: 0 })
        .lean();
    }
    return users;
  }

  async UpdateById(id, input = {}) {
    const user = await UserModel.findByIdAndUpdate(id, input, {
      new: true,
    });
    return user;
  }

  async DeleteById(id) {
    const user = await UserModel.findByIdAndDelete(id);
    return user;
  }
}
