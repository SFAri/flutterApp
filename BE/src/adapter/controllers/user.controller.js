import createError from "http-errors";
import { UserService, AddressService } from "../../core/services/index.js";
// import { upload } from "../middlewares/index.js";
import {
  CheckMissingFields,
  FormatResult,
  ThrowNewError,
} from "../../utils/index.js";

class UserController {
  async createUser(req, res, next) {
    try {
      const { fullName, email, role, gender, dateOfBirth, fileImage, phone } =
        req.body;
      CheckMissingFields({
        fullName,
        email,
        role,
        gender,
        dateOfBirth,
        fileImage,
        phone,
      });

      const newUser = {
        fullName,
        email,
        role: 0,
        gender,
        dateOfBirth,
        fileImage,
        phone,
      };

      const data = await UserService.AddNewUser(newUser);
      res.status(201).json(FormatResult("success", data));
    } catch (err) {
      next(createError(400, err));
    }
  }

  async getUserDetail(req, res, next) {
    let id;
    if (req.params?.id) {
      id = req.params.id;
    } else if (req.user) {
      id = req.user._id;
    }

    try {
      const data = await UserService.GetUserById(id);
      res.status(200).json(FormatResult("success", data));
    } catch (err) {
      next(createError(400, err));
    }
  }

  async getListUser(req, res, next) {
    const { page, limit, ...filter } = req.query || {};
    const pageQuery = parseInt(page) || 1;
    const perPage = parseInt(limit) || 10;

    try {
      const data = await UserService.GetListUser();
      console.log("🚀 ~ UserController ~ getListUser ~ data[]:", data);
      res.status(200).json(FormatResult("success", data));
    } catch (err) {
      next(createError(400, err));
    }
  }

  async updateUser(req, res, next) {
    let id;
    if (req.params?.id) {
      id = req.params.id;
    } else if (req.user) {
      id = req.user._id;
    }

    try {
      const updatedUser = req.body;
      const data = await UserService.UpdateUserById(id, updatedUser);
      res.status(200).json(FormatResult("success", data));
    } catch (err) {
      next(createError(400, err));
    }
  }

  async deleteUser(req, res, next) {
    const id = req.params.id;

    try {
      const data = await UserService.DeleteUserById(id);
      res.status(200).json(FormatResult("success", data));
    } catch (err) {
      next(createError(400, err));
    }
  }

  //? Addresses
  async createAddress(req, res, next) {
    try {
      const { _id } = req.user;
      const {
        fullName,
        email,
        phone,
        province,
        district,
        ward,
        detailAddress,
        isDefault,
      } = req.body;

      CheckMissingFields({
        fullName,
        email,
        phone,
        province,
        district,
        ward,
        detailAddress,
        isDefault,
      });

      const data = await AddressService.AddNewAddress(_id, {
        fullName,
        email,
        phone,
        province,
        district,
        ward,
        detailAddress,
        isDefault,
      });
      res.status(201).json(FormatResult("success", data));
    } catch (err) {
      next(createError(400, err));
    }
  }

  async getAddress(req, res, next) {
    const { _id } = req.user;

    try {
      const data = await AddressService.GetAllAddressByUserId(_id);
      res.status(200).json(FormatResult("success", data));
    } catch (err) {
      next(createError(400, err));
    }
  }

  async updateAddress(req, res, next) {
    try {
      const id = req.params.id;
      const updatedAddress = req.body;

      const data = await AddressService.UpdateAddress(id, updatedAddress);
      res.status(200).json(FormatResult("success", data));
    } catch (err) {
      next(createError(400, err));
    }
  }

  async deleteAddress(req, res, next) {
    try {
      const { _id } = req.user;
      const id = req.params.id;

      const data = await AddressService.DeleteAddress(_id, id);
      res.status(200).json(FormatResult("success", data));
    } catch (err) {
      next(createError(400, err));
    }
  }
}

export default new UserController();
