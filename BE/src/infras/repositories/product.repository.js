import { ProductModel } from "../models/index.js";

export default class ProductRepository {
  async AddProduct(input = {}) {
    const { name, brand, description, category, images, variants, discount } =
      input;

    const newProduct = new ProductModel({
      name,
      brand,
      description,
      category,
      images,
      variants,
      discount,
    });

    await newProduct.save();
    return newProduct;
  }

  async FindAll() {
    const products = await ProductModel.find();
    return products;
  }

  async FindById(id) {
    const product = await ProductModel.findById(id);
    return product;
  }

  async UpdateById(id, input = {}) {
    const product = await ProductModel.findByIdAndUpdate(id, input, {
      new: true,
    });
    return product;
  }

  async DeleteById(id) {
    const product = await ProductModel.findByIdAndDelete(id);
    return product;
  }

  async FindByFilter(filter = {}, sortBy = {}, limit) {
    const products = await ProductModel.find(filter).sort(sortBy).limit(limit);
    return products;
  }
}
