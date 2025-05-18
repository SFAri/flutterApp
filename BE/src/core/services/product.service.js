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

  async GetListProductByFilter(filter = {}, page = null, perpage = null) {
    let filterData = {};

    const listAlumni = await this.repository.FindByFilter(
      filterData,
      page,
      perpage
    );
    return FormatData(listAlumni);
  }

  async GetProductById(id) {
    const Product = await this.repository.FindById(id);
    if (!Product) {
      ThrowNewError("ProductError", "Product does not exist");
    }
    return FormatData(Product);
  }

  async GetProductByFilter(
    filter = {},
    sortBy = {},
    searchText = null,
    page = null,
    perpage = null
  ) {
    const { minPrice, maxPrice, brand, category, ...filterQuery } = filter;

    if (minPrice != null && maxPrice != null) {
      filterQuery["variants.salePrice"] = { $gte: minPrice, $lte: maxPrice };
    } else if (minPrice != null) {
      filterQuery["variants.salePrice"] = { $gte: minPrice };
    } else if (maxPrice != null) {
      filterQuery["variants.salePrice"] = { $lte: maxPrice };
    }

    // Add brand and category filters if they exist
    if (brand) {
      // filterQuery.brand = brand; // Assuming brand is a single value
      if (Array.isArray(brand)) {
        filterQuery.brand = { $in: brand };
      }
      else {
        filterQuery.brand = brand; // Nếu là một giá trị đơn
      }
    }
    if (category) {
      if (Array.isArray(category)) {
        filterQuery.category = { $in: category };
      }
      else {
        filterQuery.category = category; // Nếu là một giá trị đơn
      }
    }

    if (searchText) {
      filterQuery.name = { $regex: searchText, $options: "i" };
    }

    const products = await this.repository.FindByFilter(
      filterQuery,
      sortBy,
      page,
      perpage
    );
    return FormatData(products);
  }

  async AddNewProduct(input = {}) {
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
