import e from "express";
import { ProductRepository } from "../../infras/index.js";
import { FormatData, EncryptPass, ThrowNewError } from "../../utils/index.js";

class ProductService {
  constructor() {
    this.repository = new ProductRepository();
  }

  async GetListProduct() {
    const listProduct = await this.repository.FindAll();
    return FormatData(listProduct);
  }

  async GetProductById(id) {
    const Product = await this.repository.FindById(id);
    if (!Product) {
      ThrowNewError("ProductError", "Product does not exist");
    }
    return FormatData(Product);
  }

  async GetProductByFilter(filter = {}, sortBy = {}) {
    const { minPrice, maxPrice, brand, category, ...filterQuery } = filter;

    if (minPrice) {
      filterQuery.price = { $gte: minPrice };
    } else if (maxPrice) {
      filterQuery.price = { $lte: maxPrice };
    } else if (minPrice && maxPrice) {
      filterQuery.price = { $gte: minPrice, $lte: maxPrice };
    }

    // Add brand and category filters if they exist
    if (brand) {
        filterQuery.brand = brand; // Assuming brand is a single value
    }
    if (category) {
        filterQuery.category = category; // Assuming category is a single value
    }

    const products = await this.repository.FindByFilter(filterQuery, sortBy);
    return FormatData(products);
  }

  async AddNewProduct(input = {}) {
    input.price = Math.min(...input.variants.map((v) => v.price));

    const newProduct = await this.repository.AddProduct(input);

    return FormatData(newProduct);
  }

  async UpdateProductById(id, input) {
    const updatedProduct = await this.repository.UpdateById(id, input);
    if (!updatedProduct) {
      ThrowNewError("ProductError", "Product does not exist");
    }
    return FormatData(updatedProduct);
  }

  async DeleteProductById(id) {
    const deletedProduct = await this.repository.DeleteById(id);
    if (!deletedProduct) {
      ThrowNewError("ProductError", "Product does not exist");
    }
    return FormatData(null);
  }
}

export default new ProductService();
