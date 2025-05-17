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

  async FindByFilter(filter = {}, sortBy = {}, page = null, perPage = null) {
    let products = null;
    if (page && perPage) {
      const count = await ProductModel.countDocuments(filter);
      const totalPage = Math.ceil(count / perPage);
      const previous = page - 1 === 0 ? -1 : page - 1;
      const next = page + 1 > totalPage ? -1 : page + 1;

      const productsPagination = await ProductModel.find(filter)
        .sort(sortBy)
        .skip(perPage * (page - 1))
        .limit(perPage)
        .lean()
        .exec();

      products = {
        data: productsPagination,
        pagination: {
          previous,
          next,
          page: page,
          limit: perPage,
          totalPage,
        },
      };
    } else {
      products = await ProductModel.find(filter).sort(sortBy).lean();
    }
    return products;
  }
}
