import { AddressModel } from "../models/index.js";

export default class AddressRepository {
  async FindAddressById(id) {
    const address = await AddressModel.findById(id);
    return address;
  }

  async UpdateAddressById(id, input = {}) {
    const address = await AddressModel.findByIdAndUpdate(id, input, {
      new: true,
    });
    return address;
  }

  async DeleteAddressById(id) {
    const address = await AddressModel.findByIdAndDelete(id);
    return address;
  }

  async AddNewAddress(user = {}, input = {}) {
    const {
      fullName,
      email,
      phone,
      province,
      district,
      ward,
      detailAddress,
      isDefault,
    } = input;

    const newAddress = new AddressModel({
      fullName,
      email,
      phone,
      province,
      district,
      ward,
      detailAddress,
      isDefault,
    });

    await newAddress.save();
    user.addresses.push(newAddress);

    return await user.save();
  }
}
