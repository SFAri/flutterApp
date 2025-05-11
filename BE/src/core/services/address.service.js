import { FormatData, ThrowNewError } from "../../utils/index.js";
import { UserRepository, AddressRepository } from "../../infras/index.js";
class AddressService {
  constructor() {
    this.repository = new AddressRepository();
    this.userRepository = new UserRepository();
  }

  async GetAllAddressByUserId(userId) {
    const user = await this.userRepository.FindById(userId);
    if (!user) ThrowNewError("UserError", "User does not exist");

    const addresses = await Promise.all(
      user.addresses.map((address) =>
        this.repository.FindAddressById(address._id)
      )
    );

    return FormatData(addresses);
  }

  async AddNewAddress(userId, input) {
    const existingUser = await this.userRepository.FindById(userId);
    if (!existingUser) {
      ThrowNewError("UserError", "User does not exist");
    }
    const newAddress = await this.repository.AddNewAddress(existingUser, input);
    return FormatData(newAddress);
  }

  async UpdateAddress(id, input) {
    const updatedAddress = await this.repository.UpdateAddressById(id, input);
    if (!updatedAddress) {
      if (!address) ThrowNewError("AddressError", "Address does not exist");
    }
    return FormatData(updatedAddress);
  }

  async DeleteAddress(userId, addressId) {
    const user = await this.userRepository.FindById(userId);
    if (!user) ThrowNewError("UserError", "User does not exist");

    const deletedAddress = await this.repository.DeleteAddressById(addressId);

    // update user address
    user.addresses = user.addresses.filter((address) => {
      return address._id.toString() !== deletedAddress._id.toString();
    });
    user.save();

    return FormatData([]);
  }
}

export default new AddressService();
