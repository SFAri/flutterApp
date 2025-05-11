import { Schema as _Schema, model } from "mongoose";
const Schema = _Schema;

const UserSchema = new Schema(
  {
    fullName: { type: String },
    email: { type: String, required: true, unique: true },
    password: { type: String, required: true },
    refreshToken: { type: String, require: false },
    role: { type: Number, required: true, enum: [0, 1], default: 0 }, // 0. Customer - 1. Admin
    gender: { type: String, enum: ["male", "female"] },
    dateOfBirth: { type: Date },
    fileImage: { type: String },
    phone: { type: String },
    profileImage: { type: String },
    addresses: [{ type: Schema.Types.ObjectId, ref: "address" }],
    wishlist: [{ type: Schema.Types.ObjectId, ref: "product" }],
    cart: [{ type: Schema.Types.ObjectId, ref: "product" }],
    orders: [{ type: Schema.Types.ObjectId, ref: "order" }],
    paymentMethods: [{ type: Schema.Types.ObjectId, ref: "paymentMethod" }],
  },
  {
    toJSON: {
      transform(doc, ret) {
        delete ret.password;
        delete ret.refreshToken;
        delete ret.__v;
      },
    },
    timestamps: true,
  }
);

const UserModel = model("user", UserSchema);
export default UserModel;
