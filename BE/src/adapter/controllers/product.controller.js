import createError from "http-errors";
import { ProductService, AddressService } from "../../core/services/index.js";
// import { upload } from "../middlewares/index.js";
import { CheckMissingFields, FormatResult } from "../../utils/index.js";

class ProductController {
  async createProduct(req, res, next) {
    try {
      const { name, brand, description, category, images, variants } = req.body;
      CheckMissingFields({
        name,
        brand,
        description,
        category,
        images,
        variants,
      });

      const newProduct = {
        name,
        brand,
        description,
        category,
        images,
        variants,
      };

      const data = await ProductService.AddNewProduct(newProduct);
      res.status(201).json(FormatResult("success", data));
    } catch (err) {
      next(createError(400, err));
    }
  }

  async getProductDetail(req, res, next) {
    const id = req.params.id;

    try {
      const data = await ProductService.GetProductById(id);
      res.status(200).json(FormatResult("success", data));
    } catch (err) {
      next(createError(400, err));
    }
  }

  async getListProduct(req, res, next) {
    const { page, limit, ...filter } = req.query || {};
    const pageQuery = parseInt(page) || 1;
    const perPage = parseInt(limit) || 10;

    try {
      const data = await ProductService.GetListProduct();
      res.status(200).json(FormatResult("success", data));
    } catch (err) {
      next(createError(400, err));
    }
  }

  async filterProduct(req, res, next) {
    const { sortBy, filter } = req.body || {};

    try {
      const data = await ProductService.GetProductByFilter(filter, sortBy);
      res.status(200).json(FormatResult("success", data));
    } catch (err) {
      next(createError(400, err));
    }
  }

  async updateProduct(req, res, next) {
    const id = req.params.id;

    try {
      const updatedProduct = req.body;
      // get min price
      updatedProduct.price = Math.min(
        ...updatedProduct.variants.map((v) => v.price)
      );
      const data = await ProductService.UpdateProductById(id, updatedProduct);
      res.status(200).json(FormatResult("success", data));
    } catch (err) {
      next(createError(400, err));
    }
  }

  async deleteProduct(req, res, next) {
    const id = req.params.id;

    try {
      const data = await ProductService.DeleteProductById(id);
      res.status(200).json(FormatResult("success", data));
    } catch (err) {
      next(createError(400, err));
    }
  }
}

export default new ProductController();
