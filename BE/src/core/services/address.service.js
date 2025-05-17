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

    if (input.isDefault) {
      // remove all other addresses
      const addresses = await this.GetAllAddressByUserId(existingUser._id);

      addresses.forEach(async (address) => {
        address.isDefault = false;
        await this.repository.UpdateAddressById(address._id, address);
      });
    }
    if (!existingUser) {
      ThrowNewError("UserError", "User does not exist");
    }
    const newAddress = await this.repository.AddNewAddress(existingUser, input);
    return FormatData(newAddress);
  }

  async UpdateAddress(id, userId, input) {
    const address = await this.repository.FindAddressById(id);

    const updatedAddress = await this.repository.UpdateAddressById(id, input);
    if (!updatedAddress) {
      if (!address) ThrowNewError("AddressError", "Address does not exist");
    }

    if (address.isDefault && !updatedAddress.isDefault) {
      const user = await this.userRepository.FindById(userId);
      if (!user) ThrowNewError("UserError", "User does not exist");

      // set first address default
      const firstAddressId = user.addresses.find(
        (addr) => addr._id.toString() !== address._id.toString()
      );

      if (firstAddressId) {
        const firstAddress = await this.repository.FindAddressById(
          firstAddressId
        );

        firstAddress.isDefault = true;
        await this.repository.UpdateAddressById(firstAddressId, firstAddress);
      }
    } else if (updatedAddress.isDefault) {
      // remove all other addresses
      const addresses = await this.GetAllAddressByUserId(userId);

      addresses.forEach(async (address) => {
        if (address._id.toString() !== updatedAddress._id.toString()) {
          address.isDefault = false;
          await this.repository.UpdateAddressById(address._id, address);
        }
      });
    }

    return FormatData(updatedAddress);
  }

  async DeleteAddress(userId, addressId) {
    const address = await this.repository.FindAddressById(addressId);
    const user = await this.userRepository.FindById(userId);
    if (!user) ThrowNewError("UserError", "User does not exist");

    await this.repository.DeleteAddressById(addressId);
    // update user
    user.addresses = user.addresses.filter(
      (addr) => addr._id.toString() !== addressId
    );
    await user.save();

    if (address.isDefault) {
      // set first address default
      const firstAddressId = user.addresses.find(
        (addr) => addr._id.toString() !== address._id.toString()
      );

      if (firstAddressId) {
        const firstAddress = await this.repository.FindAddressById(
          firstAddressId
        );

        firstAddress.isDefault = true;
        await this.repository.UpdateAddressById(firstAddressId, firstAddress);
      }
    }

    return FormatData([]);
  }
}

export default new AddressService();
