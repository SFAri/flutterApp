import { Schema as _Schema, model } from "mongoose";
const Schema = _Schema;

const AddressSchema = new Schema(
  {
    fullName: { type: String, required: true },
    phone: { type: String, required: false },
    province: { type: String, required: true },
    district: { type: String, required: true },
    ward: { type: String, required: true },
    detailAddress: { type: String, required: true },
    isDefault: { type: Boolean, default: false },
  },
  {
    toJSON: {
      transform(doc, ret) {
        delete ret.__v;
      },
    },
    timestamps: true,
  }
);

const AddressModel = model("address", AddressSchema);
export default AddressModel;
