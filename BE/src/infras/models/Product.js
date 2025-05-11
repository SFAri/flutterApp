import { Schema as _Schema, model } from "mongoose";
const Schema = _Schema;

const VariantSchema = Schema({
  variantId: { type: String, required: true },
  color: { type: String, required: true },
  inventory: { type: Number, required: true },
  price: { type: Number, required: true },
});

const RatingSchema = Schema({
  userId: { type: Schema.Types.ObjectId, ref: "User" },
  stars: { type: Number, min: 1, max: 5, required: true },
  comment: { type: String },
  createdAt: { type: Date, default: Date.now },
});

const ProductSchema = Schema(
  {
    name: { type: String, required: true },
    brand: { type: String, required: true },
    description: { type: String, required: true, minlength: 100 },
    price: { type: Number, required: true },
    category: { type: String, required: true },
    images: [{ type: String, required: true }],
    variants: [VariantSchema],
    ratings: [RatingSchema],
    averageRating: { type: Number, default: 0 },
    totalReviews: { type: Number, default: 0 },
  },
  {
    timestamps: true,
  }
);

// Optional: middleware to calculate average rating
ProductSchema.pre("save", function (next) {
  if (this.ratings && this.ratings.length > 0) {
    const total = this.ratings.reduce((sum, r) => sum + r.stars, 0);
    this.averageRating = total / this.ratings.length;
    this.totalReviews = this.ratings.length;
  }
  next();
});

const ProductModel = model("product", ProductSchema);
export default ProductModel;
